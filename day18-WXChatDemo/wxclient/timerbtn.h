#ifndef TIMERBTN_H
#define TIMERBTN_H
/******************************************************************************
 *
 * @file       timerbtn.h
 * @brief      实现倒计时的按钮效果
 *
 * @author     恋恋风辰
 * @date       2023/05/24
 * @history
 *****************************************************************************/
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
