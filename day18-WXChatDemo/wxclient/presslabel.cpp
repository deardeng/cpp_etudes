#include "presslabel.h"
#include <QMouseEvent>

PressLabel::PressLabel( QWidget* parent):
    QLabel (parent)
{

}

/**
 * @brief 重写label按下事件
 * @param event
 */
void PressLabel::mousePressEvent(QMouseEvent *event)
{
    if(event->button() == Qt::LeftButton){
        emit clicked();
    }
}
