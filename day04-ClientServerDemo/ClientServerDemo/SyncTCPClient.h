#pragma once
#include <boost/asio.hpp>
#include <iostream>
using namespace std;
using namespace boost;
class SyncTCPClient
{
public:
	SyncTCPClient(const std::string& raw_ip_address, unsigned short port_num);
	void Connect();
	void Close();
	std::string EmulateLongComputationOp(unsigned int duration_sec);
private:
	void sendRequest(const std::string& request);
	std::string receiveResponse();
	asio::io_context  m_ioc;
	asio::ip::tcp::endpoint m_ep;
	asio::ip::tcp::socket m_sock;
};

