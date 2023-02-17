#include "session.h"
Session::Session():_buf(""), _socket(NULL), _total_bytes_written(0){

}

Session::Session(std::string buf, std::shared_ptr<asio::ip::tcp::socket> socket) 
: _buf(buf), _total_bytes_written(0),_socket(socket){

}

void Session::Connect(const asio::ip::tcp::endpoint  &ep) {
	_socket->connect(ep);
}

void Session::WriteCallBack(const boost::system::error_code & ec,  std::size_t bytes_transferred){
	if (ec.value() != 0) {
		std::cout << "Error , code is " << ec.value() << " . Message is " << ec.message();
		return;
	}

	this->_total_bytes_written += bytes_transferred;
	if (this->_total_bytes_written == this->_buf.length()) {
		return;
	}

	this->_socket->async_write_some(asio::buffer(_buf.c_str() + _total_bytes_written, _buf.length() - _total_bytes_written), std::bind(&Session::WriteCallBack,
		this, std::placeholders::_1, std::placeholders::_2));
}


void Session::WriteToSocket(){
	this->_socket->async_write_some(asio::buffer(_buf), std::bind(&Session::WriteCallBack, this, std::placeholders::_1, std::placeholders::_2));
}


void Session::WriteAllToSocket() {
	_socket->async_send(asio::buffer(_buf), std::bind(&Session::WriteAllCallBack, this, std::placeholders::_1, std::placeholders::_2));
}

void Session::WriteAllCallBack(const boost::system::error_code& ec, std::size_t bytes_transferred){
	if (ec.value() != 0) {
		std::cout << "Error occured! Error code = "
			<< ec.value()
			<< ". Message: " << ec.message();

		return;
	}
		// Here we know that all the data has
		// been written to the socket.
}
