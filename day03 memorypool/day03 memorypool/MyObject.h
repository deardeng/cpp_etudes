#pragma once
#include "MemoryPool.h"
class MyObject
{
public:
	MyObject(int x) : data(x)
	{
		//std::cout << "contruct object" << std::endl;
	}

	~MyObject()
	{
		//std::cout << "destruct object" << std::endl;
	}

	int data;

	// override new and delete to use memory pool
	void* operator new(size_t size);
	void operator delete(void* p);
	void* operator new[](size_t size);
	void operator delete[](void* p);
};

extern MemoryPool<sizeof(MyObject), 3> gMemPool;
