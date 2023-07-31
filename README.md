## 简介
该项目为C++后端学习总结和分享，分为两大板块，网络和并发。

## NetWork
网络模块主要采用boost::asio标准网络库完成封装和编写，涵盖如下内容，现将目录列举如下：
- day01-endpoint 介绍了如何创建一个网络端点。
- day02-iooperation 介绍了如何基于asio封装读写操作，包括同步和异步两种读写接口。
- day03-SyncClient  介绍了如何封装一个同步的客户端。
- day04-SyncServer  介绍了如何封装一个同步的服务器。
- day05-AsyncServer 介绍了如何封装一个异步服务器，仅支持echo模式。
- day06-AsyncServer 利用伪闭包实现连接保活,异步处理增加了全双工的通信模式，增加了缓冲队列，可以让用户无感知的方式发送数据，不用关心底层数据下发的逻辑了
- day07-AsyncServer 增加粘包处理
- day08-AsyncServer 增加逻辑处理大端小端的字节序问题，并且增加接收队列限制，防止队列溢出。
- day09-ProtobufDemo 实现一个基于protobuf序列化的demo
- day10-ProtobufServer 实现一个基于protobuf序列化的Server
- day11-JsonServer 实现一个基于json序列化的Server
- day12-MsgIdServer 完善数据包组织结构，结构更新为ID+LEN+数据域的格式
- day13-LogicServer 增加逻辑层，包括逻辑队列和单例的逻辑类在独立的线程里异步处理请求。
- day14-IocontextPoolServer 基于boost::asio实现多线程模式服务器，该模式实现了一个IocontextPool，每个Iocontext分布在一个线程里。
- day15-ThreadPoolServer 基于线程池实现boost::asio多线程模式，该模式下多个线程共享同一个Iocontext
- day16-HttpServer 基于boost::asio实现http server
- day17-beast-http-server 基于beast网络库实现http服务器
- day18-beast-websocket 基于beast网络库实现websocket服务器
- day19-Grpc-Server 基于Grpc实现服务器，Grpc多用于后台内部服务。
- day20-CoroutineDemo 基于boost::asio实现的协程server案例。
- day21-CoroutineServer 将我们之前的服务器改写为协程
- day22-AsyncLog 异步日志库
- day23-producer-consumer 生产者消费者案例实现demo

## Concurrent

该模块主要介绍并发编程技术
- day01-thread  介绍C++11 线程的基本操作，定义，启动，等待，以及后台运行等。