#include "mainwindow.h"
#include <QApplication>
#include "global.h"
#include <QDir>
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    // 获取当前应用程序的路径
    g_app_path = QCoreApplication::applicationDirPath();
    // 拼接文件名
    QString fileName = "config.ini";
    g_config_path = QDir::toNativeSeparators(g_app_path +
                             QDir::separator() + fileName);

    MainWindow w;
    w.show();

    return a.exec();
}
