#include "registerdialog.h"
#include "ui_registerdialog.h"
#include <QRegularExpression>
#include <QDebug>
#include "timerbtn.h"
#include "httpmgr.h"
#include <QUrl>
#include <QJsonObject>
#include "global.h"

RegisterDialog::RegisterDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::RegisterDialog)
{
    ui->setupUi(this);
    connect(this, &RegisterDialog::SigWait, ui->get_code, &TimerBtn::SlotWait);
}

RegisterDialog::~RegisterDialog()
{
    delete ui;
}

/**
 * @brief 获取验证码
 */
void RegisterDialog::on_get_code_clicked()
{
    // 待验证的邮箱地址
    auto email = ui->email->text();
    QRegularExpression regex(R"((\w+)(\.|_)?(\w*)@(\w+)(\.(\w+))+)"); // 邮箱地址的正则表达式
    bool match = regex.match(email).hasMatch(); // 执行正则表达式匹配
    if (match) {
        qDebug() << "是一个合法的邮箱地址";
        ui->err_tip->setText("");
        ui->err_tip->hide();
        emit SigWait();
        //发送获取验证码请求
        QUrl url(g_weburl_prefix+"/getvarifycode");
        QJsonObject json_obj;
        json_obj["email"]=email;
        HttpMgr::GetInstance()->PostHttpReq(std::move(url), json_obj);
        return;
    } else {
        qDebug() << "不是一个合法的邮箱地址";
        ui->err_tip->setText(tr("不是一个合法的邮箱地址"));
        ui->err_tip->show();
        return;
    }

}


/**
 * @brief 捕获email输入框输入完成事件
 */
void RegisterDialog::on_email_editingFinished()
{
    // 待验证的邮箱地址
    auto email = ui->email->text();
    QRegularExpression regex(R"((\w+)(\.|_)?(\w*)@(\w+)(\.(\w+))+)"); // 邮箱地址的正则表达式
    bool match = regex.match(email).hasMatch(); // 执行正则表达式匹配
    if (match) {
        qDebug() << "是一个合法的邮箱地址";
        ui->err_tip->setText("");
        ui->err_tip->hide();
    } else {
        qDebug() << "不是一个合法的邮箱地址";
        ui->err_tip->setText(tr("不是一个合法的邮箱地址"));
        ui->err_tip->show();
    }
}
