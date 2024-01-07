﻿#pragma once
#include<atomic>
#include<memory>

template<typename T>
class lock_free_queue
{
private:

    struct node_counter
    {
        unsigned internal_count : 30;
        //⇽--- 2
        unsigned external_counters : 2;
    };

    struct node;

    struct counted_node_ptr
    {
        int external_count;
        node* ptr;
    };

    struct node
    {
        std::atomic<T*> data;
        std::atomic<node_counter> count;
        //⇽---  1
        std::atomic<counted_node_ptr> next;

        node(int external_count = 2)
        {
            node_counter new_count;
            new_count.internal_count = 0;
            //⇽---  4
            new_count.external_counters = external_count;
            count.store(new_count);

            counted_node_ptr node_ptr;
            node_ptr.ptr = nullptr;
            node_ptr.external_count = 0;

            next.store(node_ptr);
        }


        void release_ref()
        {
            node_counter old_counter =
                count.load(std::memory_order_relaxed);
            node_counter new_counter;
            do
            {
                new_counter = old_counter;
                //1
                --new_counter.internal_count;
            }
            //2
            while (!count.compare_exchange_strong(
                old_counter, new_counter,
                std::memory_order_acquire, std::memory_order_relaxed));
            if (!new_counter.internal_count &&
                !new_counter.external_counters)
            {
                //3
                delete this;
                destruct_count++;
            }
        }
    };

    std::atomic<counted_node_ptr> head;
    //⇽--- 1
    std::atomic<counted_node_ptr> tail;

    // ⇽---  1
    void set_new_tail(counted_node_ptr& old_tail,
        counted_node_ptr const& new_tail)
    {
        node* const current_tail_ptr = old_tail.ptr;
        // ⇽---  2
        while (!tail.compare_exchange_weak(old_tail, new_tail) &&
            old_tail.ptr == current_tail_ptr);
        // ⇽---  3
        if (old_tail.ptr == current_tail_ptr)
            //⇽---  4   
            free_external_counter(old_tail);
        else
            //⇽---  5
            current_tail_ptr->release_ref();
    }

    static void free_external_counter(counted_node_ptr& old_node_ptr)
    {
        node* const ptr = old_node_ptr.ptr;
        int const count_increase = old_node_ptr.external_count - 2;
        node_counter old_counter =
            ptr->count.load(std::memory_order_relaxed);
        node_counter new_counter;
        do
        {
            new_counter = old_counter;
            //⇽---  1
            --new_counter.external_counters;
            //⇽---  2  
            new_counter.internal_count += count_increase;
        }
        //⇽---  3
        while (!ptr->count.compare_exchange_strong(
            old_counter, new_counter,
            std::memory_order_acquire, std::memory_order_relaxed));
        if (!new_counter.internal_count &&
            !new_counter.external_counters)
        {
            //⇽---  4
            destruct_count++;
            delete ptr;
        }
    }


    static void increase_external_count(
        std::atomic<counted_node_ptr>& counter,
        counted_node_ptr& old_counter)
    {
        counted_node_ptr new_counter;
        do
        {
            new_counter = old_counter;
            ++new_counter.external_count;
        } while (!counter.compare_exchange_strong(
            old_counter, new_counter,
            std::memory_order_acquire, std::memory_order_relaxed));
        old_counter.external_count = new_counter.external_count;
    }

public:
    lock_free_queue() {
       
        counted_node_ptr new_next;
        new_next.ptr = new node();
        new_next.external_count = 1;
        tail.store(new_next);
        head.store(new_next);
    }

    ~lock_free_queue() {
        while (pop());
    }

    void push(T new_value)
    {
        std::unique_ptr<T> new_data(new T(new_value));
        counted_node_ptr new_next;
        new_next.ptr = new node;
        new_next.external_count = 1;
        counted_node_ptr old_tail = tail.load();
        for (;;)
        {
            increase_external_count(tail, old_tail);
            T* old_data = nullptr;
            //⇽---  6
            if (old_tail.ptr->data.compare_exchange_strong(
                old_data, new_data.get()))
            {
                counted_node_ptr old_next = { 0 };
                //⇽---  7
                if (!old_tail.ptr->next.compare_exchange_strong(
                    old_next, new_next))
                {
                    //⇽---  8
                    delete new_next.ptr;
                    new_next = old_next;   // ⇽---  9
                }
                set_new_tail(old_tail, new_next);
                new_data.release();
                break;
            }
            else    // ⇽---  10
            {
                counted_node_ptr old_next = { 0 };
                // ⇽--- 11
                if (old_tail.ptr->next.compare_exchange_strong(
                    old_next, new_next))
                {
                    // ⇽--- 12
                    old_next = new_next;
                    // ⇽---  13
                    new_next.ptr = new node;
                }
                //  ⇽---  14
                set_new_tail(old_tail, old_next);
            }
        }
    }


    std::unique_ptr<T> pop()
    {
        counted_node_ptr old_head = head.load(std::memory_order_relaxed);
            for (;;)
            {
                increase_external_count(head, old_head);
                node* const ptr = old_head.ptr;
                if (ptr == tail.load().ptr)
                {
                    return std::unique_ptr<T>();
                }
                //  ⇽---  2
                counted_node_ptr next = ptr->next.load();
                if (head.compare_exchange_strong(old_head, next))
                {
                    T* const res = ptr->data.exchange(nullptr);
                    free_external_counter(old_head);
                    return std::unique_ptr<T>(res);
                }
                ptr->release_ref();
            }
    }

    static std::atomic<int> destruct_count;
};

template<typename T>
std::atomic<int> lock_free_queue<T>::destruct_count = 0;