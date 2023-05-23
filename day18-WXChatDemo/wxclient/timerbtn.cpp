#include "timerbtn.h"
#include <QDebug>

TimerBtn::TimerBtn(QWidget *parent):QPushButton(parent),_seconds(20)
{
    _timer = new QTimer(parent);

    // 设置定时器超时时间和触发模式
    _timer->setInterval(1000);
    _timer->setSingleShot(false); // 周期性触发

    // 连接定时器的 timeout 信号和槽函数
    connect(_timer, &QTimer::timeout, this, &TimerBtn::SlotTimeOut);
}



void TimerBtn::SlotTimeOut()
{
    _seconds--;
    if(_seconds > 0){
       this->setText(QString::number(_seconds));
    }else{
        _timer->stop();
        this->setText(_text);
        _seconds = 20;
        this->setEnabled(true);
    }

}

void TimerBtn::SlotWait(){
    _text = this->text();
    qDebug() << "_text is " << _text ;
    this->setEnabled(false);
    _timer->stop();
    _timer->start();
}
