﻿// day24-TroubleShoot.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include "lockfreequetest.h"
int main()
{

	//测试崩溃版本
	TestCrushQue();

	//测试内存泄露版本
	//TestLeakQue();


	//TestLockFreeQue();
   // TestLockFreeQueBase();
	//TestLockFreeQueMultiPop();
	//测试多个生产和多个消费线程
	//TestLockFreeQueMultiPushPop();
	//TestLockFreeQueMultiPushPop2();
}


