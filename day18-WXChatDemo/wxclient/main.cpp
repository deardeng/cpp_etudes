#include "mainwindow.h"
#include <QApplication>
#include "global.h"
#include <QDir>
#include <QDebug>
#include <QSettings>
#include "httpmgr.h"
#include <QUrl>
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    // 获取当前应用程序的路径
    g_app_path = QCoreApplication::applicationDirPath();
    // 拼接文件名
    QString fileName = "config.ini";
    g_config_path = QDir::toNativeSeparators(g_app_path +
                             QDir::separator() + fileName);

    qDebug()<<"config path is " << g_config_path << endl;

    QSettings settings(g_config_path, QSettings::IniFormat);
    g_webhost = settings.value("webserver/host").toString();
    g_webport = settings.value("webserver/port").toString();
    g_weburl_prefix = "http://"+g_webhost+":"+g_webport;
    qDebug()<<"g_weburl_prefix is " << g_weburl_prefix << endl;

    MainWindow w;
    w.show();

    return a.exec();
}
