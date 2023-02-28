// ClientServerDemo.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include <boost/asio.hpp>
#include "SyncTCPClient.h"
using namespace std;
using namespace boost;
int main()
{
    const std::string raw_ip_address = "127.0.0.1";
    const unsigned short port_num = 3333;
    try {
        SyncTCPClient client(raw_ip_address, port_num);
        client.Connect();
        std::cout << "Sending request to the server ..." << endl;
        std::string response = client.EmulateLongComputationOp(10);
        std::cout << "Receive Response is " << response << endl;
        client.Close();
    }
    catch (system::system_error& e) {
        cout << "Error occured, code is " << e.code() << " .Message is  " << e.what();
        return e.code().value();
   }

    return 0;
}


