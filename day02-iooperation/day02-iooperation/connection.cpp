#include "connection.h"
#include "boost/asio.hpp"
#include <iostream>
#include "session.h"
using namespace std;
using namespace boost;

int accept_new_connection(){
	// The size of the queue containing the pending connection
			// requests.
	const int BACKLOG_SIZE = 30;

	// Step 1. Here we assume that the server application has
	// already obtained the protocol port number.
	unsigned short port_num = 3333;

	// Step 2. Creating a server endpoint.
	asio::ip::tcp::endpoint ep(asio::ip::address_v4::any(),
		port_num);

	asio::io_context  ios;

	try {
		// Step 3. Instantiating and opening an acceptor socket.
		asio::ip::tcp::acceptor acceptor(ios, ep.protocol());

		// Step 4. Binding the acceptor socket to the 
		// server endpint.
		acceptor.bind(ep);

		// Step 5. Starting to listen for incoming connection
		// requests.
		acceptor.listen(BACKLOG_SIZE);

		// Step 6. Creating an active socket.
		asio::ip::tcp::socket sock(ios);

		// Step 7. Processing the next connection request and 
		// connecting the active socket to the client.
		acceptor.accept(sock);

		// At this point 'sock' socket is connected to 
		//the client application and can be used to send data to
		// or receive data from it.
	}
	catch (system::system_error& e) {
		std::cout << "Error occured! Error code = " << e.code()
			<< ". Message: " << e.what();

		return e.code().value();
	}
}


void use_buffer_str() {
	asio::const_buffers_1 output_buf = asio::buffer("hello world");
}

void use_buffer_array(){
	 const size_t  BUF_SIZE_BYTES = 20;
	std::unique_ptr<char[] > buf(new char[BUF_SIZE_BYTES]);
	auto input_buf = asio::buffer(static_cast<void*>(buf.get()), BUF_SIZE_BYTES);
}

void use_const_buffer() {
	std::string buf = "hello world!";
	asio::const_buffer  asio_buf(buf.c_str(), buf.length());
	std::vector<asio::const_buffer> buffers_sequence;
	buffers_sequence.push_back(asio_buf);
}

void use_stream_buffer() {
	asio::streambuf buf;

	std::ostream output(&buf);

	// Writing the message to the stream-based buffer.
	output << "Message1\nMessage2";

	// Now we want to read all data from a streambuf
	// until '\n' delimiter.
	// Instantiate an input stream which uses our 
	// stream buffer.
	std::istream input(&buf);

	// We'll read data into this string.
	std::string message1;

	std::getline(input, message1);

	// Now message1 string contains 'Message1'.
}

void  wirte_to_socket(asio::ip::tcp::socket& sock) {
	std::string buf = "Hello World!";
	std::size_t  total_bytes_written = 0;
	//循环发送
	//write_some返回每次写入的字节数
	//total_bytes_written是已经发送的字节数。
	//每次发送buf.length()- total_bytes_written)字节数据
	
	while (total_bytes_written != buf.length()) {
		total_bytes_written += sock.write_some(
			asio::buffer(buf.c_str()+total_bytes_written, 
				buf.length()- total_bytes_written));
	}
}

int send_data_by_write_some() {
	std::string raw_ip_address = "127.0.0.1";
	unsigned short port_num = 3333;

	try {
		asio::ip::tcp::endpoint
			ep(asio::ip::address::from_string(raw_ip_address),
				port_num);

		asio::io_service ios;

		// Step 1. Allocating and opening the socket.
		asio::ip::tcp::socket sock(ios, ep.protocol());

		sock.connect(ep);

		wirte_to_socket(sock);
	}
	catch (system::system_error& e) {
		std::cout << "Error occured! Error code = " << e.code()
			<< ". Message: " << e.what();

		return e.code().value();
	}
	return 0;
}

int send_data_by_send(){
	std::string raw_ip_address = "127.0.0.1";
	unsigned short port_num = 3333;

	try {
		asio::ip::tcp::endpoint
			ep(asio::ip::address::from_string(raw_ip_address),
				port_num);

		asio::io_service ios;

		// Step 1. Allocating and opening the socket.
		asio::ip::tcp::socket sock(ios, ep.protocol());

		sock.connect(ep);
		std::string buf = "Hello World!";
		int send_length = sock.send(asio::buffer(buf.c_str(), buf.length()));
		if (send_length <= 0) {
			cout << "send failed" << endl;
			return 0;
		}
	}
	catch (system::system_error& e) {
		std::cout << "Error occured! Error code = " << e.code()
			<< ". Message: " << e.what();

		return e.code().value();
	}
	return 0;
}

int send_data_by_wirte() {
	std::string raw_ip_address = "127.0.0.1";
	unsigned short port_num = 3333;

	try {
		asio::ip::tcp::endpoint
			ep(asio::ip::address::from_string(raw_ip_address),
				port_num);

		asio::io_service ios;

		// Step 1. Allocating and opening the socket.
		asio::ip::tcp::socket sock(ios, ep.protocol());

		sock.connect(ep);
		std::string buf = "Hello World!";
		int send_length  = asio::write(sock, asio::buffer(buf.c_str(), buf.length()));
		if (send_length <= 0) {
			cout << "send failed" << endl;
			return 0;
		}
	}
	catch (system::system_error& e) {
		std::cout << "Error occured! Error code = " << e.code()
			<< ". Message: " << e.what();

		return e.code().value();
	}
	return 0;
 }

std::string read_from_socket(asio::ip::tcp::socket& sock) {
	const unsigned char MESSAGE_SIZE = 7;
	char buf[MESSAGE_SIZE];
	std::size_t total_bytes_read = 0;

	while (total_bytes_read != MESSAGE_SIZE) {
		total_bytes_read += sock.read_some(
			asio::buffer(buf + total_bytes_read,
				MESSAGE_SIZE - total_bytes_read));
	}

	return std::string(buf, total_bytes_read);
}


int read_data_by_read_some() {
	std::string raw_ip_address = "127.0.0.1";
	unsigned short port_num = 3333;

	try {
		asio::ip::tcp::endpoint
			ep(asio::ip::address::from_string(raw_ip_address),
				port_num);

		asio::io_service ios;

		asio::ip::tcp::socket sock(ios, ep.protocol());

		sock.connect(ep);

		read_from_socket(sock);
	}
	catch (system::system_error& e) {
		std::cout << "Error occured! Error code = " << e.code()
			<< ". Message: " << e.what();

		return e.code().value();
	}

	return 0;
}

int read_data_by_receive() {
	std::string raw_ip_address = "127.0.0.1";
	unsigned short port_num = 3333;

	try {
		asio::ip::tcp::endpoint
			ep(asio::ip::address::from_string(raw_ip_address),
				port_num);

		asio::io_service ios;

		asio::ip::tcp::socket sock(ios, ep.protocol());

		sock.connect(ep);
		const unsigned char BUFF_SIZE = 7;
		 char buffer_receive[BUFF_SIZE];
		int receive_length =  sock.receive(asio::buffer(buffer_receive, BUFF_SIZE));
		if (receive_length <= 0) {
			cout << "receive failed" << endl;
		}
	}
	catch (system::system_error& e) {
		std::cout << "Error occured! Error code = " << e.code()
			<< ". Message: " << e.what();

		return e.code().value();
	}

	return 0;
}

int read_data_by_read() {
	std::string raw_ip_address = "127.0.0.1";
	unsigned short port_num = 3333;

	try {
		asio::ip::tcp::endpoint
			ep(asio::ip::address::from_string(raw_ip_address),
				port_num);

		asio::io_service ios;

		asio::ip::tcp::socket sock(ios, ep.protocol());

		sock.connect(ep);
		const unsigned char BUFF_SIZE = 7;
		char buffer_receive[BUFF_SIZE];
		int receive_length = asio::read(sock, asio::buffer(buffer_receive, BUFF_SIZE));
		if (receive_length <= 0) {
			cout << "receive failed" << endl;
		}
	}
	catch (system::system_error& e) {
		std::cout << "Error occured! Error code = " << e.code()
			<< ". Message: " << e.what();

		return e.code().value();
	}

	return 0;
 }

std::string  read_data_by_until(asio::ip::tcp::socket& sock) {
	asio::streambuf buf;

	// Synchronously read data from the socket until
	// '\n' symbol is encountered.  
	asio::read_until(sock, buf, '\n');

	std::string message;

	// Because buffer 'buf' may contain some other data
	// after '\n' symbol, we have to parse the buffer and
	// extract only symbols before the delimiter. 

	std::istream input_stream(&buf);
	std::getline(input_stream, message);
	return message;
 }


int async_write_data() {
	std::string raw_ip_address = "127.0.0.1";
	unsigned short port_num = 3333;
	try {
		asio::ip::tcp::endpoint ep(asio::ip::address::from_string(raw_ip_address), port_num);
		asio::io_context  iox;
		auto socket_ptr = std::make_shared<asio::ip::tcp::socket>(iox, ep.protocol());
		auto session_ptr = std::make_shared<Session>("Hello World!", socket_ptr);
		session_ptr->Connect(ep);
		session_ptr->WriteToSocket();
		iox.run();
	}
	catch (system::system_error& e) {
		std::cout << "Error occured! Error code = " << e.code() << " . Message: " << e.what();
		return e.code().value();
	}

	return 0;
}

