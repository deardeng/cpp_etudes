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
    QWidget *centralWidget = new LoginDialog();
    setCentralWidget(centralWidget);
    centralWidget->show();
}

MainWindow::~MainWindow()
{
    delete ui;
}
