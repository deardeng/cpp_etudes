#include "LogicSystem.h"
#include "HttpConnection.h"
#include <json/json.h>
#include <json/value.h>
#include <json/reader.h>
using namespace std;

//************************************
// 函数名:    LogicSystem
// 返回值:    
// 作者:       恋恋风辰
// 功能:		  构造函数内创建url和回调函数的映射，
// post请求放入_post_handlers，get放入_get_handlers
//************************************
LogicSystem::LogicSystem(){
	_post_handlers.insert(make_pair("/getvarifycode", [](std::shared_ptr<HttpConnection> connection) {
		auto& body = connection->request_.body();
		auto body_str = boost::beast::buffers_to_string(body.data());
		cout << "receive body is " << body_str << endl;
		connection->response_.set(http::field::content_type, "text/json");
		Json::Value root;
		root["error"] = 0;
		root["varifycode"] = "helloworld";
		std::string jsonstr = root.toStyledString();
		beast::ostream(connection->response_.body()) << jsonstr;

		return true;
		}));
}

LogicSystem::~LogicSystem(){

}

//************************************
// 函数名:    HandlePost
// 返回值:    bool
// 参数:       url路径
// 参数:       要处理的连接
// 作者:       恋恋风辰
// 功能:       处理post请求
//************************************
bool LogicSystem::HandlePost(std::string path, std::shared_ptr<HttpConnection> connection) {
	auto iter_handler = _post_handlers.find(path);
	if (iter_handler  == _post_handlers.end()) {
		return false;
	}

	(iter_handler->second)(connection);
	return true;
}

//************************************
// 函数名:    HandleGet
// 返回值:    bool
// 参数:       url路径
// 参数:       要处理的连接
// 作者:       恋恋风辰
// 功能:		  处理get请求
//************************************
bool LogicSystem::HandleGet(std::string path, std::shared_ptr<HttpConnection> connection) {
	if (_get_handlers.find(path) == _get_handlers.end()) {
		return false;
	}
	return true;
}

