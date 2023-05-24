#ifndef MAINWINDOW_H
#define MAINWINDOW_H
/******************************************************************************
 *
 * @file       mainwindow.h
 * @brief      登录界面管理类
 *
 * @author     恋恋风辰
 * @date       2023/05/24
 * @history
 *****************************************************************************/
#include "logindialog.h"
#include "registerdialog.h"
#include <QMainWindow>
class LoginDialog;
namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
public slots:
    void SlotSwitchReg();
private:
    Ui::MainWindow *ui;
    LoginDialog* _login_dlg;
    RegisterDialog* _reg_dlg;
};

#endif // MAINWINDOW_H
