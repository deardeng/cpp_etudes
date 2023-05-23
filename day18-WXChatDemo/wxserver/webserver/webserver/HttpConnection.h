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
	//接收对端消息，监听读事件
	void ReadRequest();
	//处理请求
	void ProcessRequest();
	//处理get请求
	void HandleGet();
	//处理post请求
	void HandlePost();
	//回包
	void WriteResponse();
	//开始监听对端消息
	void Start();
	//检测截至时间
	void CheckDeadline();
private:
	//当前连接的客户端套接字
	tcp::socket socket_;

	// 读数据缓存区
	beast::flat_buffer buffer_{ 8192 };

	// 请求的消息体
	http::request<http::dynamic_body> request_;

	// 回复的消息体
	http::response<http::dynamic_body> response_;

	// 定时器，用来控制一个连接处理的最大时长为60s
	net::steady_timer deadline_{
		socket_.get_executor(), std::chrono::seconds(60) };
};

