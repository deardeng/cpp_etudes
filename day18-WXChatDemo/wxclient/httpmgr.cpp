#include "httpmgr.h"
#include <QtNetwork>
#include <QUrl>
#include <QJsonDocument>


HttpMgr::HttpMgr()
{

}

HttpMgr::~HttpMgr(){

}
/**
 * @brief 发送post请求
 * @param 服务器端url如localhost:8080/varifycode
 * @param json数据
 */
void HttpMgr::PostHttpReq(QUrl url, QJsonObject json)
{
        // 创建一个 QNetworkAccessManager 对象，用于发送 HTTP 请求


        // 创建一个 HTTP POST 请求，并设置请求头和请求体
        QByteArray data = QJsonDocument(json).toJson();
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        request.setHeader(QNetworkRequest::ContentLengthHeader, QByteArray::number(data.length()));
        qDebug() << "req url is "<<url.url();
        // 发送请求，并处理响应
        QNetworkReply *reply = _manager.post(request, data);
        QObject::connect(reply, &QNetworkReply::finished, [reply](){
            if (reply->error() == QNetworkReply::NoError) {
                QString res = reply->readAll();
                qDebug() << res;
            } else {
                qDebug() << reply->errorString();
            }
            reply->deleteLater();
        });

//    qDebug() << "begin post req ";
//   auto manager =  new QNetworkAccessManager() ;

    // 创建请求对象
//    QUrl url("http://localhost:8080/getvarifycode");
//    QNetworkRequest request(url);
//    QJsonObject json_obj;
//    json_obj["email"]="sdfa.com";
//    QByteArray data = QJsonDocument(json_obj).toJson();
//    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
//    request.setHeader(QNetworkRequest::ContentLengthHeader, QByteArray::number(data.length()));
//    qDebug() << "req url is "<<url.url();
//    // 发送请求，并处理响应
//    QNetworkReply *reply = manager->post(request, data);
//    QObject::connect(reply, &QNetworkReply::finished, [reply](){
//        qDebug() << "receive resp from server";
//        if (reply->error() == QNetworkReply::NoError) {
//            QString res = reply->readAll();
//            qDebug() << "req success data is " << res << endl;
//        } else {
//            qDebug() << "req error is " << reply->errorString()<< endl;
//        }
//        reply->deleteLater();
//    });


}
