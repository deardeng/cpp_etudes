#ifndef PRESSLABEL_H
#define PRESSLABEL_H
/******************************************************************************
 *
 * @file       presslabel.h
 * @brief      重写标签类，实现可以点击的标签，并发出点击信号
 *
 * @author     恋恋风辰
 * @date       2023/05/24
 * @history
 *****************************************************************************/
#include <QLabel>

class PressLabel:public QLabel
{
    Q_OBJECT
public:
    PressLabel(QWidget* parent = nullptr);
protected:
    void mousePressEvent(QMouseEvent* event) override;
signals:
    void clicked();
};

#endif // PRESSLABEL_H
