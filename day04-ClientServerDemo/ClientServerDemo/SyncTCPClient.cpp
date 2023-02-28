#include "SyncTCPClient.h"


SyncTCPClient::SyncTCPClient(const std::string& raw_ip_address, unsigned short port_num) :
	m_ep(asio::ip::address::from_string(raw_ip_address), port_num), m_sock(m_ioc) {
	m_sock.open(m_ep.protocol());
}
void SyncTCPClient::Connect() {
	m_sock.connect(m_ep);
}
	
void SyncTCPClient::Close() {
	m_sock.shutdown(boost::asio::ip::tcp::socket::shutdown_both);
	m_sock.close();
}
std::string SyncTCPClient::EmulateLongComputationOp(unsigned int duration_sec) {
	std::string  request = "EMULATE_LONG_COMP_OP " + std::to_string(duration_sec) + "\n";
	sendRequest(request);
	return receiveResponse();
}

void SyncTCPClient::sendRequest(const std::string& request) {
	asio::write(m_sock, asio::buffer(request));
}

std::string SyncTCPClient::receiveResponse(){
	asio::streambuf   buf;
	asio::read_until(m_sock, buf, '\n');
	std::istream input(&buf);
	std::string  response;
	std::getline(input, response);
	return response;
}
