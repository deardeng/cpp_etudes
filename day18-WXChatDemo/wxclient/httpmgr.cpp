#include "httpmgr.h"
#include <QtNetwork/QNetworkAccessManager>
#include <QUrl>
#include <QJsonDocument>
#include <QtNetwork/QNetworkReply>

HttpMgr::HttpMgr()
{

}

HttpMgr::~HttpMgr(){

}
/**
 * @brief 发送post请求
 * @param 服务器端url如localhost:8080/varifycode
 * @param json数据
 * @return 成功或失败
 */
bool HttpMgr::PostHttpReq(QUrl url, QJsonObject json)
{
        bool res=true;
        // 创建一个 QNetworkAccessManager 对象，用于发送 HTTP 请求
        QNetworkAccessManager manager;

        // 创建一个 HTTP POST 请求，并设置请求头和请求体
        QByteArray data = QJsonDocument(json).toJson();
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        request.setHeader(QNetworkRequest::ContentLengthHeader, QByteArray::number(data.length()));

        // 发送请求，并处理响应
        QNetworkReply *reply = manager.post(request, data);
        QObject::connect(reply, &QNetworkReply::finished, [&](){
            if (reply->error() == QNetworkReply::NoError) {
                QString res = reply->readAll();
                qDebug() << res;
                res =true;
            } else {
                qDebug() << reply->errorString();
                res = false;
            }
            reply->deleteLater();
        });

        return res;
}
