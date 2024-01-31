// day22-ThreadPool.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include "ParallenForeach.h"
#include "SimpleThreadPool.h"

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


int main()
{
    TestParallenForEach();
    TestRecursiveForEach();
    TestSimpleThread();
    TestFutureThread();
}


