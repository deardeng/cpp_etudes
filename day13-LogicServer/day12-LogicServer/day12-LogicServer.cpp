#include <iostream>
#include "CServer.h"
#include "Singleton.h"
#include "LogicSystem.h"
using namespace std;
int main()
{
	try {
		boost::asio::io_context  io_context;
		CServer s(io_context, 10086);
		io_context.run();
		/*	LogicSystem::GetInstance()->PrintAddress();
			LogicSystem::GetInstance()->PrintAddress();*/
	}
	catch (std::exception& e) {
		std::cerr << "Exception: " << e.what() << endl;
	}
	
}