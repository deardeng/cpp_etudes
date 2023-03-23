#pragma once
#include <boost/asio.hpp>
using boost::asio::ip::tcp;
class CSession
{
public:
	CSession(boost::asio::io_context& io_context);
	tcp::socket& socket();
private:
	tcp::socket _socket;
};

