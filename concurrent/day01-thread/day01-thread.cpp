// day01-thread.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include <thread>

void thead_work1(std::string str) {

}

int main()
{
    std::string hellostr = "hello world!";
    std::thread t1(thead_work1, hellostr);
    t1.join();
}


