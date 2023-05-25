#-------------------------------------------------
#
# Project created by QtCreator 2023-05-15T17:58:14
#
#-------------------------------------------------

QT       += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = wxclient
TEMPLATE = app
RC_ICONS = icon.ico
DESTDIR  = ./bin

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

CONFIG += c++11

SOURCES += \
        forgetdialog.cpp \
        global.cpp \
        httpmgr.cpp \
        logindialog.cpp \
        main.cpp \
        mainwindow.cpp \
        presslabel.cpp \
        registerdialog.cpp \
        timerbtn.cpp

HEADERS += \
        forgetdialog.h \
        global.h \
        httpmgr.h \
        logindialog.h \
        mainwindow.h \
        presslabel.h \
        registerdialog.h \
        singleton.h \
        timerbtn.h

FORMS += \
        forgetdialog.ui \
        logindialog.ui \
        mainwindow.ui \
        registerdialog.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    rc.qrc

OTHER_FILES += config.ini


win32:CONFIG(release, debug | release)
{
    #指定要拷贝的文件目录为工程目录下release目录下的所有dll、lib文件，例如工程目录在D:\QT\Test
    #PWD就为D:/QT/Test，DllFile = D:/QT/Test/release/*.dll
    TargetConfig = $${PWD}/config.ini
    #将输入目录中的"/"替换为"\"
    TargetConfig = $$replace(TargetConfig, /, \\)
    #将输出目录中的"/"替换为"\"
    OutputDir =  $${OUT_PWD}/$${DESTDIR}
    OutputDir = $$replace(OutputDir, /, \\)
    //执行copy命令
    QMAKE_POST_LINK += copy /Y \"$$TargetConfig\" \"$$OutputDir\"
}