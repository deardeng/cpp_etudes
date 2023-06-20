#include "LogicSystem.h"
#include "HttpConnection.h"
#include <json/json.h>
#include <json/value.h>
#include <json/reader.h>
#include "VarifyClient.h"
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
		Json::Reader reader;
		Json::Value src_root;
		bool parse_success = reader.parse(body_str, src_root);
		if (!parse_success) {
			cout << "Failed to parse JSON data!" << endl;
			root["error"] = ErrorCodes::Error_Json;
			std::string jsonstr = root.toStyledString();
			beast::ostream(connection->response_.body()) << jsonstr;
			return true;
		}
		auto email = src_root["email"].asString();
		cout << "email is " << email << endl;
		std::string codestr = "";
		int n_res = VarifyClient::GetInstance().GetVarifyCode(email, codestr);

		if (n_res != ErrorCodes::Success) {
			root["error"] = n_res;
			std::string jsonstr = root.toStyledString();
			beast::ostream(connection->response_.body()) << jsonstr;
			return true;
		}

		root["error"] = 0;
		root["email"] = src_root["email"];
		root["code"] = codestr;
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

