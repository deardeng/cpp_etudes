#pragma once
#include "HttpConnection.h"
#include <memory>
class HttpServer:public std::enable_shared_from_this<HttpServer>
{
public:
	HttpServer(  boost::asio::io_context& ioc,  int port);
	void Start();
private:
	  boost::asio::io_context& _ioc;
	boost::asio::ip::tcp::acceptor  _acceptor;
	boost::asio::ip::tcp::socket   _socket;
};

