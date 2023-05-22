#include "forgetdialog.h"
#include "ui_forgetdialog.h"

ForgetDialog::ForgetDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ForgetDialog)
{
    ui->setupUi(this);
}

ForgetDialog::~ForgetDialog()
{
    delete ui;
}
