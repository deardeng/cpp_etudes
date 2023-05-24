#include "HttpServer.h"

HttpServer::HttpServer(boost::asio::io_context& ioc, int port):
	_ioc(ioc), _acceptor(ioc, tcp::endpoint(tcp::v4(), port)), _socket(ioc)
{
	std::cout << "Server listen on port " << port << std::endl;
}


//************************************
// 函数名:    Start
// 返回值:    void
// 作者:       恋恋风辰
// 功能:		  HttpServer接收连接并且将socket的管理权交给 HttpConnection处理			 
//************************************
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
