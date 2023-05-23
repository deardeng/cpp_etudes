#include "HttpConnection.h"
#include "LogicSystem.h"

HttpConnection::HttpConnection(tcp::socket socket)
	 : socket_(std::move(socket)) {


}

void HttpConnection::ReadRequest() {
	auto self = shared_from_this();

	http::async_read(
		socket_,
		buffer_,
		request_,
		[self](beast::error_code ec,
			std::size_t bytes_transferred)
		{
			boost::ignore_unused(bytes_transferred);
			if (!ec)
				self->ProcessRequest();
		});
}

//处理get请求
void HttpConnection::HandleGet() {
	auto self = shared_from_this();
	bool success = LogicSystem::GetInstance()->HandleGet(request_.target(), self);
	if (!success) {
		response_.result(http::status::not_found);
		response_.set(http::field::content_type, "text/plain");
		beast::ostream(response_.body()) << "url not found\r\n";
	}
}
//处理post请求
void HttpConnection::HandlePost() {
	auto self = shared_from_this();
	bool success = LogicSystem::GetInstance()->HandlePost(request_.target(), self);
	if (!success) {
		response_.result(http::status::not_found);
		response_.set(http::field::content_type, "text/plain");
		beast::ostream(response_.body()) << "url not found\r\n";
	}
}

void HttpConnection::WriteResponse() {
	auto self = shared_from_this();

	response_.content_length(response_.body().size());

	http::async_write(
		socket_,
		response_,
		[self](beast::error_code ec, std::size_t)
		{
			self->socket_.shutdown(tcp::socket::shutdown_send, ec);
			self->deadline_.cancel();
		});
}


void HttpConnection::ProcessRequest() {
	response_.version(request_.version());
	response_.keep_alive(false);

	switch (request_.method())
	{
	case http::verb::get:
		response_.result(http::status::ok);
		response_.set(http::field::server, "Beast");
		HandleGet();
		break;

	case http::verb::post:
		response_.result(http::status::ok);
		response_.set(http::field::server, "Beast");
		HandlePost();
		break;

	default:
		// We return responses indicating an error if
		// we do not recognize the request method.
		response_.result(http::status::bad_request);
		response_.set(http::field::content_type, "text/plain");
		beast::ostream(response_.body())
			<< "Invalid request-method '"
			<< std::string(request_.method_string())
			<< "'";
		break;
	}

	WriteResponse();
}

void HttpConnection::Start(){
	ReadRequest();
	CheckDeadline();
}

void HttpConnection::CheckDeadline(){
	auto self = shared_from_this();

	deadline_.async_wait(
		[self](beast::error_code ec)
		{
			if (!ec)
			{
				// Close socket to cancel any outstanding operation.
				self->socket_.close(ec);
			}
		});
}
