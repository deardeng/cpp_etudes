#pragma once
#include <mutex>
#include <memory>

template<typename T>
class threadsafe_doublelist
{
	struct double_node
	{
		std::mutex m;
		std::shared_ptr<T> data;
		std::unique_ptr<double_node> next;
		std::unique_ptr<double_node> prev;
		double_node() :
			next(nullptr), prev(nullptr)
		{}
		double_node(T const& value) :next(nullptr), prev(nullptr),
			data(std::make_shared<T>(value))
		{}
	};

	std::unique_ptr<double_node> head;
	std::unique_ptr<double_node> tail;
public:
	threadsafe_doublelist()
	{
		head = std::make_unique<double_node>();
		tail = std::make_unique<double_node>();
		head->next = tail;
		tail->prev = head;
	}

	~threadsafe_doublelist()
	{
		remove_if([](node const&) {return true; });
	}

	threadsafe_doublelist(threadsafe_doublelist const& other) = delete;
	threadsafe_doublelist& operator=(threadsafe_doublelist const& other) = delete;

	void push_front(T const& value)
	{
		std::unique_ptr<node> new_node(new node(value));
		std::lock_guard<std::mutex> lk(head.m);
		new_node->next = std::move(head.next);
		head.next = std::move(new_node);
	}

	template<typename Function>
	void for_each(Function f)
	{
		node* current = &head;
		std::unique_lock<std::mutex> lk(head.m);
		while (node* const next = current->next.get())
		{
			std::unique_lock<std::mutex> next_lk(next->m);
			lk.unlock();
			f(*next->data);
			current = next;
			lk = std::move(next_lk);
		}
	}

	template<typename Predicate>
	std::shared_ptr<T> find_first_if(Predicate p)
	{
		node* current = &head;
		std::unique_lock<std::mutex> lk(head.m);
		while (node* const next = current->next.get())
		{
			std::unique_lock<std::mutex> next_lk(next->m);
			lk.unlock();
			if (p(*next->data))
			{
				return next->data;
			}
			current = next;
			lk = std::move(next_lk);
		}
		return std::shared_ptr<T>();
	}

	template<typename Predicate>
	void remove_if(Predicate p)
	{
		node* current = &head;
		std::unique_lock<std::mutex> lk(head.m);
		while (node* const next = current->next.get())
		{
			std::unique_lock<std::mutex> next_lk(next->m);
			if (p(*next->data))
			{
				std::unique_ptr<node> old_next = std::move(current->next);
				current->next = std::move(next->next);
				next_lk.unlock();
			}
			else
			{
				lk.unlock();
				current = next;
				lk = std::move(next_lk);
			}
		}
	}
};