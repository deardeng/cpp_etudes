#include "LogicSystem.h"
#include "HttpConnection.h"
#include <json/json.h>
#include <json/value.h>
#include <json/reader.h>
using namespace std;

//************************************
// ������:    LogicSystem
// ����ֵ:    
// ����:       �����糽
// ����:		  ���캯���ڴ���url�ͻص�������ӳ�䣬
// post�������_post_handlers��get����_get_handlers
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
// ������:    HandlePost
// ����ֵ:    bool
// ����:       url·��
// ����:       Ҫ���������
// ����:       �����糽
// ����:       ����post����
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
// ������:    HandleGet
// ����ֵ:    bool
// ����:       url·��
// ����:       Ҫ���������
// ����:       �����糽
// ����:		  ����get����
//************************************
bool LogicSystem::HandleGet(std::string path, std::shared_ptr<HttpConnection> connection) {
	if (_get_handlers.find(path) == _get_handlers.end()) {
		return false;
	}
	return true;
}

