#pragma once
#include<csignal>
#include <atomic>
#include <thread>
#include <queue>
#include <iostream>

extern void deadlockdemo();
extern void lockdemo();
extern void reference_invalid();
extern void reference_sharedptr();
extern void shallow_copy();
extern void shallow_copy2();
extern void normal_copy();

extern std::atomic<bool>  b_stop;
extern void sig_handler(int sig);

class ProductConsumerMgr {
public:
	ProductConsumerMgr(){
		_consumer = std::thread([]() {
			while (!b_stop) {
				std::cout << "....." << std::endl;
				}
			});

		_producer = std::thread([]() {
			while (!b_stop) {
				std::cout << "....." << std::endl;
			}
			});

	}
	~ProductConsumerMgr(){
		_producer.join();
		_consumer.join();
	}
private:
	std::queue<int> _data_que;
	std::thread _consumer;
	std::thread _producer;
};

extern void TestProducerConsumer();