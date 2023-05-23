#include "HttpServer.h"

HttpServer::HttpServer(boost::asio::io_context& ioc, int port):
	_ioc(ioc), _acceptor(ioc, tcp::endpoint(tcp::v4(), port)), _socket(ioc)
{
	std::cout << "Server listen on port " << port << std::endl;
}


void HttpServer::Start(){
	auto self = shared_from_this();
	_acceptor.async_accept(_socket,
		[self](beast::error_code ec)
		{
			if (!ec)
			{
				std::make_shared<HttpConnection>(std::move(self->_socket))->Start();
			}
				
			self->Start();
		});
}
