#pragma once

#include <future>
#include <thread>
#include "ThreadPool.h"
#include <vector>

template<typename Iterator, typename Func>
void parallel_for_each(Iterator first, Iterator last, Func f)
{
    unsigned long const length = std::distance(first, last);
    if (!length)
        return;
    unsigned long const min_per_thread = 25;
    unsigned long const num_threads =
        (length + min_per_thread - 1) / min_per_thread;

    unsigned long const block_size = length / num_threads;
    std::vector<std::future<void>> futures(num_threads - 1);   //⇽-- - 1
    Iterator block_start = first;
    for (unsigned long i = 0; i < (num_threads - 1); ++i)
    {
        Iterator block_end = block_start;
        std::advance(block_end, block_size);

        futures[i] = ThreadPool::instance().commit([=]()
            {
                std::for_each(block_start, block_end, f);
            });

        block_start = block_end;
    }
    std::for_each(block_start, last, f);
    for (unsigned long i = 0; i < (num_threads - 1); ++i)
    {
        futures[i].get();   // ⇽-- - 4
    }
}

template<typename Iterator, typename Func>
void recursion_for_each(Iterator first, Iterator last, Func f)
{
    std::mutex mtx;
    std::vector<std::future<void>> futures;
    unsigned long const length = std::distance(first, last);
    if (!length)
        return;
    unsigned long const min_per_thread = 25;
    if (length < (2 * min_per_thread))
    {
        std::for_each(first, last, f);    //⇽-- - 1
    }
    else
    {
        Iterator const mid_point = first + length / 2;
        {
            std::lock_guard<std::mutex> lock(mtx);
            futures.push_back(
                ThreadPool::instance().commit([=]()
                {
                    std::for_each(first, mid_point, f);
                }));
        }

        recursion_for_each(mid_point, last, f);

        for (auto& future : futures) {
            future.get();
       }
    }
}