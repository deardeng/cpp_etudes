#ifndef FORGETDIALOG_H
#define FORGETDIALOG_H

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
