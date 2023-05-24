#ifndef FORGETDIALOG_H
#define FORGETDIALOG_H
/******************************************************************************
 *
 * @file       forgetdialog.h
 * @brief      找回密码界面管理类
 *
 * @author     恋恋风辰
 * @date       2023/05/24
 * @history
 *****************************************************************************/
#include <QDialog>

namespace Ui {
class ForgetDialog;
}

class ForgetDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ForgetDialog(QWidget *parent = nullptr);
    ~ForgetDialog();

private:
    Ui::ForgetDialog *ui;
};

#endif // FORGETDIALOG_H
