#ifndef REGISTERDIALOG_H
#define REGISTERDIALOG_H
/******************************************************************************
 *
 * @file       registerdialog.h
 * @brief      注册界面管理类
 *
 * @author     恋恋风辰
 * @date       2023/05/24
 * @history
 *****************************************************************************/
#include <QDialog>

namespace Ui {
class RegisterDialog;
}

class RegisterDialog : public QDialog
{
    Q_OBJECT

public:
    explicit RegisterDialog(QWidget *parent = nullptr);
    ~RegisterDialog();

private:
    Ui::RegisterDialog *ui;

private slots:

    void on_get_code_clicked();

    void on_email_editingFinished();

signals:
    void SigWait();

};

#endif // REGISTERDIALOG_H
