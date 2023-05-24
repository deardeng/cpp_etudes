// webserver.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include "HttpConnection.h"
#include "HttpServer.h"

//************************************
// 函数名:    http_server
// 返回值:    void
// 参数:       tcp::acceptor & acceptor
// 参数:       tcp::socket & socket
// 作者:       恋恋风辰
// 功能:       监听对端连接请求，socket交给新的连接处理
//************************************
void
http_server(tcp::acceptor& acceptor, tcp::socket& socket)
{
	acceptor.async_accept(socket,
		[&](beast::error_code ec)
		{
			if (!ec)
				std::make_shared<HttpConnection>(std::move(socket))->Start();
			http_server(acceptor, socket);
		});
}

//************************************
// 函数名:    main
// 返回值:    int
// 参数:       int argc
// 参数:       char * argv[]
// 作者:       恋恋风辰
// 功能:       主程序启动入口，监听SIGINT信号等待退出。
//************************************
int
main(int argc, char* argv[])
{
	try
	{	
		unsigned short port = static_cast<unsigned short>(8080);
		net::io_context ioc{ 1 };
		boost::asio::signal_set signals(ioc, SIGINT, SIGTERM);
		signals.async_wait([&ioc](const boost::system::error_code& error, int signal_number) {
			
				if (error) {
					return;
				}	
				ioc.stop();
		});
		std::make_shared<HttpServer>(ioc, port)->Start();
		ioc.run();
	}
	catch (std::exception const& e)
	{
		std::cerr << "Error: " << e.what() << std::endl;
		return EXIT_FAILURE;
	}
}


