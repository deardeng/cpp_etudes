const grpc = require('@grpc/grpc-js')
const message_proto = require('./proto')

let cnt = 1

function GetVarifyCode(call, callback) {
    callback(null, { email: `[${cnt++}] echo: ` + call.request.email,
                code:"1024",
                error:0
             });
}

function main() {
    var server = new grpc.Server()
    server.addService(message_proto.VarifyService.service, { GetVarifyCode: GetVarifyCode })
    server.bindAsync('0.0.0.0:50051', grpc.ServerCredentials.createInsecure(), () => {
        server.start()
        console.log('grpc server started')        
    })
}

main()