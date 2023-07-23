// day22-producer-consumer.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include <mutex>
#include <thread>
#include <queue>
#include <iostream>
#include <boost/asio.hpp>
#include <csignal>
#include <chrono>
#include <random>

int main()
{
	//控制队列安全mtx
	std::mutex  mtx;
	//消息队列
	std::queue<int> que;
	//队列最大长度
	int que_max = 1024;
	//消费者条件变量
	std::condition_variable  consumer_cv;
	//生产者条件变量
	std::condition_variable  producer_cv;
	//退出标记
	bool bexit = false;

	auto consumer = std::thread([&]() {
		for (;;) {
			std::unique_lock<std::mutex> lock(mtx);
			//队列为空则则挂起等待
			while (que.empty() && !bexit) {
				consumer_cv.wait(lock);
			}

			//收到退出信号
			if (bexit) {
				return;
			}

			//自动加锁消费队列
			auto num = que.front();
			std::cout << "consumer consume " << num << std::endl;
			que.pop();
			//判断是否需要通知
			bool  bnotify = (que.size() == que_max - 1) ? true:false;
			lock.unlock();
			if (bnotify) {
				//通知生产者
				producer_cv.notify_one();
			}

			// 创建随机数引擎
			std::random_device rd;
			std::mt19937 gen(rd());

			// 创建分布器，这里以生成范围在[0, 100]的整数为例
			std::uniform_int_distribution<> dis(1, 3);

			// 生成随机数
			int randomValue = dis(gen);

			// 睡眠一毫秒
			std::this_thread::sleep_for(std::chrono::milliseconds(randomValue));
		}

	});

	auto producer = std::thread([&]() {
		for (int index = 0;;index++) {
			std::unique_lock<std::mutex> lock(mtx);
			//队列满并且没有设置退出标记则挂起
			while (que.size() == que_max && !bexit) {
				producer_cv.wait(lock);
			}

			//判断是否为退出标记
			if (bexit) {
				return;
			}

			que.push(index);
			std::cout << "producer produce " << index << std::endl;
			bool bnotify = (que.size() == 1) ? true : false;
			lock.unlock();
			if (bnotify) {
				consumer_cv.notify_one();
			}
			
			// 创建随机数引擎
			std::random_device rd;
			std::mt19937 gen(rd());

			// 创建分布器，这里以生成范围在[0, 100]的整数为例
			std::uniform_int_distribution<> dis(1, 3);

			// 生成随机数
			int randomValue = dis(gen);

			// 睡眠一毫秒
			std::this_thread::sleep_for(std::chrono::milliseconds(randomValue));
		}
	});

	// 全局 io_context 对象
	boost::asio::io_context ioContext;
	// 创建一个信号集对象
	boost::asio::signal_set signals(ioContext, SIGINT);

	// 异步等待信号
	signals.async_wait([&](const boost::system::error_code& error,
		int signalNumber) {
			std::cout << "Received signal: " << signalNumber << std::endl;
			bexit = true;
			consumer_cv.notify_one();
			producer_cv.notify_one();
			// 停止 io_context
			ioContext.stop();
		});

	// 运行 io_context
	ioContext.run();
	//等待线程退出
	consumer.join();
	producer.join();

	std::cout << "Exiting..." << std::endl;
}


