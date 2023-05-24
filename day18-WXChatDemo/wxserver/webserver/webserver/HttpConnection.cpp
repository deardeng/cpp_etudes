#include "HttpConnection.h"
#include "LogicSystem.h"

HttpConnection::HttpConnection(tcp::socket socket)
	 : socket_(std::move(socket)) {


}

//************************************
// ������:    ReadRequest
// ����ֵ:    void
// ����:       �����糽
// ����:       �������¼�������ͻ��˵�����
//************************************
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


//************************************
// ������:    HandleGet
// ����ֵ:    void
// ����:       �����糽
// ����:		  ����get����
//************************************
void HttpConnection::HandleGet() {
	auto self = shared_from_this();
	bool success = LogicSystem::GetInstance()->HandleGet(request_.target(), self);
	if (!success) {
		response_.result(http::status::not_found);
		response_.set(http::field::content_type, "text/plain");
		beast::ostream(response_.body()) << "url not found\r\n";
	}
}

//************************************
// ������:    HandlePost
// ����ֵ:    void
// ����:       �����糽
// ����:       ����post����
//************************************
void HttpConnection::HandlePost() {
	auto self = shared_from_this();
	bool success = LogicSystem::GetInstance()->HandlePost(request_.target(), self);
	if (!success) {
		response_.result(http::status::not_found);
		response_.set(http::field::content_type, "text/plain");
		beast::ostream(response_.body()) << "url not found\r\n";
	}
}

//************************************
// ������:    WriteResponse
// ����ֵ:    void
// ����:       �����糽
// ����:       ���ͻذ����ͻ���
//************************************
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


//************************************
// ������:    ProcessRequest
// ����ֵ:    void
// ����:       �����糽
// ����:       �ֱ���Զ˵�get��post����
//************************************
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

//************************************
// ������:    Start
// ����ֵ:    void
// ����:       �����糽
// ����:       http����������������¼����ҿ�����ʱ���
//************************************
void HttpConnection::Start(){
	ReadRequest();
	CheckDeadline();
}

//************************************
// ������:    CheckDeadline
// ����ֵ:    void
// ����:       �����糽
// ����:       ��ⳬʱ
//************************************
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
