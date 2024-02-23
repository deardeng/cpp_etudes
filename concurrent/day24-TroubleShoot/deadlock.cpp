#include "deadlock.h"
#include <thread>
#include <future>
#include <mutex>
#include <iostream>
#include <queue>
#include <functional>

void deadlockdemo() {
	std::mutex mtx;
	int global_data = 0;
	std::thread t1([&mtx, &global_data]() {
		std::cout << "begin lock outer_lock..." << std::endl;
		std::lock_guard<std::mutex> outer_lock(mtx);
		std::cout << "after lock outer_lock..." << std::endl;
		global_data++;
		std::async([&mtx, &global_data]() {
			std::cout << "begin lock inner_lock..." << std::endl;
			std::lock_guard<std::mutex> inner_lock(mtx);
			std::cout << "after lock inner_lock..." << std::endl;
			global_data++;
			std::cout << global_data << std::endl;
			std::cout << "unlock inner_lock..." << std::endl;
			});
		std::cout << "unlock  outer_lock..." << std::endl;
	});

	t1.join();
}

void lockdemo() {
	std::mutex mtx;
	int global_data = 0;
	std::future<void> future_res;
	std::thread t1([&mtx, &global_data,&future_res]() {
		std::cout << "begin lock outer_lock..." << std::endl;
		std::lock_guard<std::mutex> outer_lock(mtx);
		std::cout << "after lock outer_lock..." << std::endl;
		global_data++;
		future_res = std::async([&mtx, &global_data]() {
			std::cout << "begin lock inner_lock..." << std::endl;
			std::lock_guard<std::mutex> inner_lock(mtx);
			std::cout << "after lock inner_lock..." << std::endl;
			global_data++;
			std::cout << global_data << std::endl;
			std::cout << "unlock inner_lock..." << std::endl;
			});
		std::cout << "unlock  outer_lock..." << std::endl;
		});

	t1.join();
}

 void reference_invalid()
{
	 class task_data {
	 public:
		 task_data(int i):_data(new int(i)){}
		 ~task_data() { delete _data; }
		 int* _data;
	 };
	 std::queue<std::function<void()>> task_que;
	 for (int i = 0; i < 10; i++) {
		 task_data data(i);
		 task_que.push([&data]() {
			 (*data._data)++;
			 std::cout << "data is " << *data._data << std::endl;
			 });
	 }

	auto res_future =  std::async([&task_que]() {
			for (;;) {
				if (task_que.empty()) {
					break;
				}
				auto& task = task_que.front();
				task();
				task_que.pop();
			}
		});

	res_future.wait();
}


 void reference_sharedptr()
 {
	 class task_data {
	 public:
		 task_data(int i) :_data(new int(i)) {}
		 ~task_data() { 
			 delete _data; 
		 }
		 int* _data;
	 };
	 std::queue<std::function<void()>> task_que;
	 for (int i = 0; i < 10; i++) {
		 std::shared_ptr<task_data> taskptr = std::make_shared<task_data>(i);
		 task_que.push([taskptr]() {
			(*( taskptr->_data))++;
			 std::cout << "data is " << *(taskptr->_data) << std::endl;
			 });
	 }

	 auto res_future = std::async([&task_que]() {
		 for (;;) {
			 if (task_que.empty()) {
				 break;
			 }
			 auto& task = task_que.front();
			 task();
			 task_que.pop();
		 }
		 });

	 res_future.wait();
 }

 void shallow_copy(){
	 class task_data {
	 public:
		 task_data(int i) :_data(new int(i)) {}
		 ~task_data() { 
			 std::cout << "call task_data destruct" << std::endl;
			 delete _data; 
		 }
		 int* _data;
	 };

	 task_data data1(1);
	 task_data data2 = std::move(data1);
 }

 void shallow_copy2(){
	 class task_data {
	 public:
		 task_data(int i) :_data(new int(i)) {}
		 ~task_data() {
			 std::cout << "call task_data destruct" << std::endl;
			 delete _data;
		 }
		 int* _data;
	 };

	 auto task_call = []() -> task_data {
		 task_data data(100);
		 return data;
	 };

	 task_call();
 }

 void normal_copy() {
	 class task_data {
	 public:
		 task_data(int i) :_data(new int(i)) {}
		 ~task_data() {
			 std::cout << "call task_data destruct" << std::endl;
			 delete _data;
		 }
		 task_data(const task_data& src) {
			 _data = new int(*(src._data));
		 }

		 task_data(task_data&& src) noexcept{
			 _data = new int(*(src._data));
		 }

		 int* _data;
	 };

	 auto task_call = []() -> task_data {
		 task_data data(100);
		 return data;
	 };

	 task_call();
 }

 std::atomic<bool>  b_stop = false;
 void sig_handler(int sig)
 {
	 if (sig == SIGINT || sig == SIGTERM)
	 {
		 b_stop = 0;
	 }
 }

  void TestProducerConsumer()
 {
	  signal(SIGINT, sig_handler);
	  ProductConsumerMgr mgr;
	  while (!b_stop) {
		  std::this_thread::sleep_for(std::chrono::milliseconds(10));
	  }
 }
