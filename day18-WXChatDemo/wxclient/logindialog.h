#ifndef LOGINDIALOG_H
#define LOGINDIALOG_H
/******************************************************************************
 *
 * @file       logindialog.h
 * @brief      登录界面管理类
 *
 * @author     恋恋风辰
 * @date       2023/05/24
 * @history
 *****************************************************************************/
#include <QDialog>

namespace Ui {
class LoginDialog;
}

class LoginDialog : public QDialog
{
    Q_OBJECT

public:
    explicit LoginDialog(QWidget *parent = nullptr);
    ~LoginDialog();

private:
    Ui::LoginDialog *ui;
signals:
    void switchRegister();
    void forgetPwd();
};

#endif // LOGINDIALOG_H
