#ifndef TIMERBTN_H
#define TIMERBTN_H
#include <QPushButton>
#include <QTimer>

class TimerBtn: public QPushButton
{
    Q_OBJECT
public:
    TimerBtn(QWidget *parent = nullptr);
    QTimer* _timer;
protected:

private:
    unsigned int _seconds;
    QString _text;
public slots:
    void SlotTimeOut();
    void SlotWait();
};

#endif // TIMERBTN_H
