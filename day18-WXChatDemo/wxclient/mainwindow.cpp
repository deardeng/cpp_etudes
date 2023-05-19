#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QVBoxLayout>
#include "logindialog.h"
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    // 创建一个 CentralWidget，并将其设置为 MainWindow 的中心部件
    _login_dlg = new LoginDialog();
    setCentralWidget(_login_dlg);
    _login_dlg->show();

    //创建和注册消息的链接
    connect(_login_dlg, &LoginDialog::switchRegister,
            this, &MainWindow::SlotSwitchReg);

    _reg_dlg = new RegisterDialog();

}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::SlotSwitchReg(){
    setCentralWidget(_reg_dlg);
    _login_dlg->hide();
    _reg_dlg->show();
}
