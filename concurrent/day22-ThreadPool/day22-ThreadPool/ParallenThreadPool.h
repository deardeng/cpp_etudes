#pragma once
#include "ThreadSafeQue.h"
#include <future>
#include "ThreadSafeQue.h"
#include "join_thread.h"
#include "FutureThreadPool.h"

class parrallen_thread_pool
{
private:

	//void run_pending_task() {
	//	function_wrapper task;
	//	if (local_work_que && !local_work_que->empty()) {
	//		task = std::move(local_work_que->front());
	//		local_work_que->pop();
	//		task();
	//	}
	//	else {
	//		if (global_work_que.wait_and_pop_timeout(task)) {
	//			task();
	//		}
	//	}
	//}

	void worker_thread()
	{
		//local_work_que.reset(new local_queue_type);
		//while (!done)
		//{
		//	run_pending_task();
		//}
	}
public:

	static parrallen_thread_pool& instance() {
		static  parrallen_thread_pool pool;
		return pool;
	}
	~parrallen_thread_pool()
	{
		//⇽-- - 11
		done = true;
		global_work_que.Exit();
		for (unsigned i = 0; i < threads.size(); ++i)
		{
			//⇽-- - 9
			threads[i].join();
		}
	}

	template<typename FunctionType>
	std::future<typename std::result_of<FunctionType()>::type>
		submit(FunctionType f)
	{
		typedef typename std::result_of<FunctionType()>::type result_type;
		std::packaged_task<result_type()> task(std::move(f));
		std::future<result_type> res(task.get_future());
		if (local_work_que) {
			local_work_que->push(std::move(task));
		}
		else {
			global_work_que.push(std::move(task));
		}

		return res;
	}

private:
	parrallen_thread_pool() :
		done(false), joiner(threads)
	{
		//⇽--- 8
		unsigned const thread_count = std::thread::hardware_concurrency();
		try
		{
			thread_work_ques = std::vector<>

			for (unsigned i = 0; i < thread_count; ++i)
			{
				//⇽-- - 9
				threads.push_back(std::thread(&parrallen_thread_pool::worker_thread, this));
			}
		}
		catch (...)
		{
			//⇽-- - 10
			done = true;
			for (int i = 0; i < thread_work_ques.size(); i++) {
				thread_work_ques[i].Exit();
			}
			throw;
		}
	}

	std::atomic_bool done;
	//全局队列
	std::vector<threadsafe_queue<function_wrapper>> thread_work_ques;

	//⇽-- - 2
	std::vector<std::thread> threads;
	//⇽-- - 3
	join_threads joiner;
};