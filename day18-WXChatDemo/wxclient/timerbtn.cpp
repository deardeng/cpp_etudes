#include "timerbtn.h"

TimerBtn::TimerBtn(QWidget *parent):QPushButton(parent),_seconds(60)
{
    _timer = new QTimer(parent);

    // 设置定时器超时时间和触发模式
    _timer->setInterval(1000);
    _timer->setSingleShot(false); // 周期性触发

    // 连接定时器的 timeout 信号和槽函数
    connect(_timer, &QTimer::timeout, this, &TimerBtn::SlotTimeOut);
    _text = this->text();
}

void TimerBtn::keyPressEvent(QKeyEvent *event)
{
    this->setEnabled(false);
    _timer->start();
    QPushButton::keyPressEvent(event);
}

void TimerBtn::SlotTimeOut()
{
    _seconds--;
    if(_seconds > 0){
       this->setText(QString::number(_seconds));
    }else{
        _timer->stop();
        this->setText(_text);
        _seconds = 60;
        this->setEnabled(true);
    }

}
