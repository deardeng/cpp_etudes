// day03 memorypool.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include "MemoryPool.h"
#include "MyObject.h"
int main()
{
 
    std::cout << "Hello World!\n";
	MyObject* p1 = new MyObject(1);
	std::cout << "p1 " << p1 << " " << p1->data << std::endl;

	MyObject* p2 = new MyObject(2);
	std::cout << "p2 " << p2 << " " << p2->data << std::endl;
	delete p2;

	MyObject* p3 = new MyObject(3);
	std::cout << "p3 " << p3 << " " << p3->data << std::endl;

	MyObject* p4 = new MyObject(4);
	std::cout << "p4 " << p4 << " " << p4->data << std::endl;

	MyObject* p5 = new MyObject(5);
	std::cout << "p5 " << p5 << " " << p5->data << std::endl;

	MyObject* p6 = new MyObject(6);
	std::cout << "p6 " << p6 << " " << p6->data << std::endl;

	delete p1;
	delete p2;
	//delete p3;
	delete p4;
	delete p5;
	delete p6;

	getchar();
	return 0;
}

// 运行程序: Ctrl + F5 或调试 >“开始执行(不调试)”菜单
// 调试程序: F5 或调试 >“开始调试”菜单

// 入门使用技巧: 
//   1. 使用解决方案资源管理器窗口添加/管理文件
//   2. 使用团队资源管理器窗口连接到源代码管理
//   3. 使用输出窗口查看生成输出和其他消息
//   4. 使用错误列表窗口查看错误
//   5. 转到“项目”>“添加新项”以创建新的代码文件，或转到“项目”>“添加现有项”以将现有代码文件添加到项目
//   6. 将来，若要再次打开此项目，请转到“文件”>“打开”>“项目”并选择 .sln 文件
