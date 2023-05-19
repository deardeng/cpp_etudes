#include "http_connection.h"

// "Loop" forever accepting new connections.
void
http_server(tcp::acceptor& acceptor, tcp::socket& socket)
{
	acceptor.async_accept(socket,
		[&](beast::error_code ec)
		{
			if (!ec)
				std::make_shared<http_connection>(std::move(socket))->start();
			http_server(acceptor, socket);
		});
}

int
main(int argc, char* argv[])
{
	try
	{
		auto const address = net::ip::make_address("127.0.0.1");
		unsigned short port = static_cast<unsigned short>(8080);
		std::cout << "server run on " << address << " port is " << port << std::endl;
		net::io_context ioc{ 1 };
		tcp::acceptor acceptor{ ioc, {address, port} };
		tcp::socket socket{ ioc };
		http_server(acceptor, socket);
		ioc.run();
	}
	catch (std::exception const& e)
	{
		std::cerr << "Error: " << e.what() << std::endl;
		return EXIT_FAILURE;
	}
}