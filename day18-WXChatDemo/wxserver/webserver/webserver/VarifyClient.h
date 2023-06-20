#pragma once

#include <grpcpp/grpcpp.h>
#include "message.pb.h"
#include "message.grpc.pb.h"
#include <memory.h>
using grpc::ClientContext;
using grpc::Channel;
using grpc::Status;
using message::GetVarifyRsp;
using message::GetVarifyReq;
using message::VarifyService;

class VarifyClient
{
public:
	~VarifyClient(){}
	int GetVarifyCode(std::string email, std::string& code);
	static VarifyClient& GetInstance();
	VarifyClient(const VarifyClient&) = delete;
	VarifyClient& operator =(const VarifyClient&) = delete;
private:
	VarifyClient(std::shared_ptr<Channel> channel);
	std::unique_ptr<VarifyService::Stub> _stub;
};

