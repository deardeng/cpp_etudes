#ifndef HTTPMGR_H
#define HTTPMGR_H
#include "singleton.h"
#include <QString>
#include <QJsonObject>
#include <QUrl>

class HttpMgr:public Singleton<HttpMgr>
{
public:
    ~HttpMgr();
    bool PostHttpReq(QUrl url, QJsonObject data);
private:
    friend class Singleton<HttpMgr>;
    HttpMgr();
};

#endif // HTTPMGR_H
