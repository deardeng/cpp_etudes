#ifndef HTTPMGR_H
#define HTTPMGR_H
/******************************************************************************
 *
 * @file       httpmgr.h
 * @brief      http管理类，是一个单例类
 *
 * @author     恋恋风辰
 * @date       2023/05/24
 * @history
 *****************************************************************************/

#include "singleton.h"
#include <QString>
#include <QJsonObject>
#include <QUrl>
#include <QObject>
#include <QNetworkAccessManager>
class HttpMgr:public Singleton<HttpMgr>
{
public:
    ~HttpMgr();
    void PostHttpReq(QUrl url, QJsonObject data);
private:
    friend class Singleton<HttpMgr>;
    HttpMgr();
    QNetworkAccessManager _manager;
};

#endif // HTTPMGR_H
