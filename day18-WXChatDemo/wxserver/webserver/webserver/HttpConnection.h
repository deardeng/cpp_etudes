#pragma once
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio.hpp>
#include <chrono>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <memory>
#include <string>

namespace beast = boost::beast;         // from <boost/beast.hpp>
namespace http = beast::http;           // from <boost/beast/http.hpp>
namespace net = boost::asio;            // from <boost/asio.hpp>
using tcp = boost::asio::ip::tcp;       // from <boost/asio/ip/tcp.hpp>
class LogicSystem;
class HttpConnection:public std::enable_shared_from_this<HttpConnection>
{
	friend class LogicSystem;
public:
	HttpConnection(tcp::socket socket);
	//���նԶ���Ϣ���������¼�
	void ReadRequest();
	//��������
	void ProcessRequest();
	//����get����
	void HandleGet();
	//����post����
	void HandlePost();
	//�ذ�
	void WriteResponse();
	//��ʼ�����Զ���Ϣ
	void Start();
	//������ʱ��
	void CheckDeadline();
private:
	//��ǰ���ӵĿͻ����׽���
	tcp::socket socket_;

	// �����ݻ�����
	beast::flat_buffer buffer_{ 8192 };

	// �������Ϣ��
	http::request<http::dynamic_body> request_;

	// �ظ�����Ϣ��
	http::response<http::dynamic_body> response_;

	// ��ʱ������������һ�����Ӵ�������ʱ��Ϊ60s
	net::steady_timer deadline_{
		socket_.get_executor(), std::chrono::seconds(60) };
};

