#pragma once
#include "boost/asio.hpp"
#include <atomic>
#include <memory>
#include <thread>
#include <iostream>
using namespace boost;
using namespace std;

class Service {
public:
	Service(){}
	void HandleClient(asio::ip::tcp::socket & sock) {
		try {
			asio::streambuf  request;
			asio::read_until(sock, request, '\n');
			int i = 0;
			while (i < 10000) {
				i++;
				std::this_thread::sleep_for(
					std::chrono::microseconds(500)
				);

				std::string response = "Response\n";
				asio::write(sock, asio::buffer(response));
			}
		}
		catch (system::system_error& error) {
			cout << "catch error code is " << error.code() << " message is " << error.what() << endl;
		}
	}
};

class Acceptor {

};


class Server
{
};

