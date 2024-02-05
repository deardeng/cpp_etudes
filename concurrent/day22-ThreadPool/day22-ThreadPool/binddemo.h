#pragma once
#include <iostream>
#include <functional>
#include <queue>
#include <thread>
#include <future>
int functionint(int param) {
	std::cout << "param is " << param << std::endl;
	return 0;
}

void bindfunction() {
	std::function<int(void)> functionv = std::bind(functionint, 3);
	functionv();
}

void pushtasktoque() {
	std::function<int(void)> functionv = std::bind(functionint, 3);
	using Task = std::packaged_task<void()>;
	std::queue<Task> taskque;
	taskque.emplace([functionv]() {
		functionv();
		});
}

std::future<int> committask() {
	std::function<int(void)> functionv = std::bind(functionint, 3);
	auto taskf = std::make_shared<std::packaged_task<int(void)>>(functionv);
	auto res = taskf->get_future();
	using Task = std::packaged_task<void()>;
	std::queue<Task> taskque;
	taskque.emplace([taskf]() {
		(*taskf)();
		});

	return res;
}
