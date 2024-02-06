// day22-ThreadPool.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include "ParallenForeach.h"
#include "SimpleThreadPool.h"
#include "NotifyThreadPool.h"
#include "QuickSort.h"
#include "binddemo.h"

void TestParallenForEach() {

    std::vector<int> nvec;
    for (int i = 0; i < 26; i++) {
        nvec.push_back(i);
    }

    parallel_for_each(nvec.begin(), nvec.end(), [](int& i) {
        i *= i;
        });

    for (int i = 0; i < nvec.size(); i++) {
        std::cout << nvec[i] << " ";
    }

    std::cout << std::endl;
}

void TestRecursiveForEach() {

    std::vector<int> nvec;
    for (int i = 0; i < 26; i++) {
        nvec.push_back(i);
    }

    recursion_for_each(nvec.begin(), nvec.end(), [](int& i) {
        i *= i;
        });

    for (int i = 0; i < nvec.size(); i++) {
        std::cout << nvec[i] << " ";
    }

    std::cout << std::endl;
    
}

void TestSimpleThread() {
	std::vector<int> nvec;
	for (int i = 0; i < 26; i++) {
		nvec.push_back(i);
	}

    simple_for_each(nvec.begin(), nvec.end(), [](int& i) {
		i *= i;
		});

	for (int i = 0; i < nvec.size(); i++) {
		std::cout << nvec[i] << " ";
	}

	std::cout << std::endl;
}

void TestFutureThread() {
	std::vector<int> nvec;
	for (int i = 0; i < 26; i++) {
		nvec.push_back(i);
	}

	future_for_each(nvec.begin(), nvec.end(), [](int& i) {
		i *= i;
		});

	for (int i = 0; i < nvec.size(); i++) {
		std::cout << nvec[i] << " ";
	}

	std::cout << std::endl;
}

void TestNotifyThread() {
	std::vector<int> nvec;
	for (int i = 0; i < 26; i++) {
		nvec.push_back(i);
	}

	notify_for_each(nvec.begin(), nvec.end(), [](int& i) {
		i *= i;
		});

	for (int i = 0; i < nvec.size(); i++) {
		std::cout << nvec[i] << " ";
	}

	std::cout << std::endl;
    
}

void TestQuickSort() {
	std::list<int> nlist = { 6,1,0,5,2,9,11 };

	auto sortlist = parallel_quick_sort<int>(nlist);

	for (auto & value : sortlist) {
		std::cout << value << " ";
	}

	std::cout << std::endl;
}

void TestParrallenThreadPool() {
	std::list<int> nlist = { 6,1,0,5,2,9,11 };

	auto sortlist = parallen_pool_quick_sort<int>(nlist);

	for (auto& value : sortlist) {
		std::cout << value << " ";
	}

	std::cout << std::endl;
}

void TestBindDemo() {
	bindfunction();
}

int main()
{
    TestParallenForEach();
    TestRecursiveForEach();
    TestSimpleThread();
    TestFutureThread();
	TestNotifyThread();
	TestQuickSort();
	TestParrallenThreadPool();
	TestBindDemo();
	reference_collapsing();
	reference_collapsing2();
}


