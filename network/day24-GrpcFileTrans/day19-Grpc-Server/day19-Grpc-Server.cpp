#include <iostream>
#include <memory>
#include <string>
#include <grpcpp/grpcpp.h>

#include "demo.grpc.pb.h"
#include <fstream>

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;
using hello::HelloRequest;
using hello::HelloReply;
using hello::Greeter;
using grpc::ServerReader;
using hello::Chunk;

// Logic and data behind the server's behavior.
class GreeterServiceImpl final : public Greeter::Service {
	Status SayHello(ServerContext* context, const HelloRequest* request,
		HelloReply* reply) override {
		std::string prefix("llfc grpc server has received :  ");
		reply->set_message(prefix + request->message());
		return Status::OK;
	}

	Status Upload(ServerContext* context, ServerReader< ::hello::Chunk>* reader, ::hello::Reply* reply) {

		Chunk chunk;
		std::ofstream outfile;
		const char* data;

		bool bRead = reader->Read(&chunk);
		if (!bRead) {
			reply->set_length(0);
			return Status::OK;
		}

		std::string filename = chunk.filename();

		outfile.open(filename, std::ofstream::out | std::ofstream::app | std::ofstream::binary);

		if (outfile.is_open()) {
			// 文件成功打开  
			std::cout << "文件已成功打开!" << std::endl;
			// 进行其他操作，如读取文件内容  
		}
		else {
			// 文件打开失败  
			std::cout << "无法打开文件!" << std::endl;
			// 处理打开失败的情况，比如输出错误消息或进行其他处理  
		}

		while (bRead && !(chunk.buffer().empty())) {
			data = chunk.buffer().c_str();
			outfile.write(data, chunk.buffer().length());
			bRead = reader->Read(&chunk);
		}
		long pos = outfile.tellp();
		reply->set_length(pos);
		outfile.close();

		return Status::OK;
	}
};

void RunServer() {
	std::string server_address("127.0.0.1:50051");
	GreeterServiceImpl service;

	ServerBuilder builder;
	// Listen on the given address without any authentication mechanism.
	// 监听给定的地址
	builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
	// Register "service" as the instance through which we'll communicate with
	// clients. In this case it corresponds to an *synchronous* service.
	builder.RegisterService(&service);
	// Finally assemble the server.
	std::unique_ptr<Server> server(builder.BuildAndStart());
	std::cout << "Server listening on " << server_address << std::endl;

	// Wait for the server to shutdown. Note that some other thread must be
	// responsible for shutting down the server for this call to ever return.
	server->Wait();
}

int main(int argc, char** argv) {
	RunServer();

	return 0;
}

