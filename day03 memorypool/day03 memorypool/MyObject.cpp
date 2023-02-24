#include "MyObject.h"

MemoryPool<sizeof(MyObject), 3> gMemPool;


void* MyObject::operator new(size_t size)
{
	//std::cout << "new object space" << std::endl;
	return gMemPool.allocate();
}

void MyObject::operator delete(void* p)
{
	//std::cout << "free object space" << std::endl;
	gMemPool.deallocate(p);
}


