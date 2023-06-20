#include "VarifyClient.h"
#include "const.h"

VarifyClient::VarifyClient(std::shared_ptr<Channel> channel):
	_stub(VarifyService::NewStub(channel)) {

}


//************************************
// ������:    GetVarifyCode
// ����ֵ:    int
// ����:       std::string email
// ����:       std::string & code
// ����:       �����糽
// ����:       ͨ��rpc��ȡ��֤��
//************************************
int VarifyClient::GetVarifyCode(std::string email, std::string& code){
	ClientContext context;
	GetVarifyReq request;
	GetVarifyRsp reply;
	request.set_email(email);

	Status status =_stub->GetVarifyCode(&context, request, &reply);
	
	if (status.ok()) {
		std::cout << "get varify code is " << reply.email() << std::endl;
		code = reply.code();
		return reply.error();
	}
	else {
		return ErrorCodes::RPCFailed;
	}
}

VarifyClient&  VarifyClient:: GetInstance() {
	static VarifyClient instance(grpc::CreateChannel("127.0.0.1:50051", grpc::InsecureChannelCredentials()));
	return instance;
}
