#ifndef MAINWINDOW_H
#define MAINWINDOW_H
#include "logindialog.h"
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

private:
    Ui::MainWindow *ui;
    LoginDialog* _login_dlg;
};

#endif // MAINWINDOW_H
