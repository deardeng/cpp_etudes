#pragma once
#include "boost/asio.hpp"
#include <iostream>
using namespace std;
using namespace boost;
class Session {
public:
	Session();
	Session(std::string buf, std::shared_ptr<asio::ip::tcp::socket> socket);
	void Connect(const asio::ip::tcp::endpoint& ep);
	void WriteCallBack(const boost::system::error_code& ec, std::size_t bytes_transferred);
	void WriteToSocket();
	void WriteAllToSocket();
	void WriteAllCallBack(const boost::system::error_code& ec, std::size_t bytes_transferred);
private:
	std::string _buf;
	int _total_bytes_written;
	std::shared_ptr<asio::ip::tcp::socket> _socket;
};


