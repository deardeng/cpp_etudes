#include "deadlock.h"
#include <thread>
#include <future>
#include <mutex>
#include <iostream>

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