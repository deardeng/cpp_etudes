#include "logindialog.h"
#include "ui_logindialog.h"
#include <QtGui>
#include "presslabel.h"

LoginDialog::LoginDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::LoginDialog)
{
    ui->setupUi(this);
    ui->forget_label->setCursor(QCursor(Qt::PointingHandCursor));
    connect(ui->forget_label, &PressLabel::clicked, this, &LoginDialog::forgetPwd);
    connect(ui->reg_btn, &QPushButton::clicked, this, &LoginDialog::switchRegister);
}

LoginDialog::~LoginDialog()
{
    delete ui;
}
