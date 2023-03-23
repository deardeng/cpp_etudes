#include "CSession.h"
CSession::CSession(boost::asio::io_context& io_context):_socket(io_context){
	
}

tcp::socket& CSession::socket() {
	return _socket;
}
