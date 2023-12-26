#include <string>
#include <iostream>
#include <fstream>
#include <memory>
#include <grpcpp/grpcpp.h>
#include <filesystem>
#include "demo.grpc.pb.h"
#include <windows.h>  
using grpc::ClientContext;
using grpc::Channel;
using grpc::Status;
using hello::HelloReply;
using hello::HelloRequest;
using hello::Greeter;

using hello::Chunk;
using hello::Reply;
using grpc::ClientWriter;

#define CHUNK_SIZE 1024 *1024

// static method : Greeter::NewStub
class FCClient {
public:
	FCClient(std::shared_ptr<Channel> channel)
		:stub_(Greeter::NewStub(channel)) {
	}

	std::string SayHello(std::string name) {
		ClientContext context;
		HelloReply reply;
		HelloRequest request;
		request.set_message(name);

		Status status = stub_->SayHello(&context, request, &reply);

		if (status.ok()) {
			return reply.message();
		}
		else {
			return "failure " + status.error_message();
		}
	}

	void Upload();

    void Upload(std::string filepath);

private:
	std::unique_ptr<Greeter::Stub> stub_;
};

void FCClient::Upload(std::string filepath) {
    
        Chunk chunk;
        char data[CHUNK_SIZE];
        Reply stats;
        ClientContext context;
        std::ifstream infile;
        int len = 0;

        //1.获取不带路径的文件名

        std::string::size_type iPos = filepath.find_last_of('/') + 1;
        std::string filename = filepath.substr(iPos, filepath.length() - iPos);

        std::cout << "文件名: " << filename << std::endl;

        infile.open(filepath, std::ifstream::in | std::ifstream::binary);

        if (infile.is_open()) {
            // 文件成功打开  
            std::cout << "文件已成功打开!" << std::endl;
            // 进行其他操作，如读取文件内容  
        }
        else {
            // 文件打开失败  
            std::cout << "无法打开文件!" << std::endl;
            // 处理打开失败的情况，比如输出错误消息或进行其他处理  
        }

        std::unique_ptr<ClientWriter<Chunk>> writer(stub_->Upload(&context, &stats));
        while (!infile.eof()) {
            infile.read(data, CHUNK_SIZE);
            chunk.set_buffer(data, infile.gcount());
            chunk.set_filename(filename);
            if (!writer->Write(chunk)) {
                // Broken stream.
                break;
            }
            len += infile.gcount();
        }
        writer->WritesDone();
        Status status = writer->Finish();
        if (status.ok()) {
            std::cout << "Transfer " << filename << " success!" << std::endl;
        }
        else {
            std::cout << "TransferFile rpc failed. error is " << status.error_message()  << std::endl;
        }

        infile.close();
    
}

void FCClient::Upload()
{
    std::unordered_map<int, std::string> vis;
	vis[1] = "./1630026318562.jpg";
	vis[2] = "./a.jpg";
	vis[3] = "./c.txt";

	std::ifstream infile;
    for (int i = 1; i <= 3; ++i) {
        char data[CHUNK_SIZE];
        std::string filepath = vis[i];
        Upload(filepath);
    }

}

int main(int argc, char* argv[]) {
	auto channel = grpc::CreateChannel("127.0.0.1:50051", grpc::InsecureChannelCredentials());
    if (!channel) {
        return 0;
    }
    FCClient client(channel);
	// block until get result from RPC server
	/*std::string result = client.SayHello("hello , llfc.club !");
	printf("get result [%s]\n", result.c_str());*/
    

    client.Upload();

	return 0;
}
