#include "presslabel.h"
#include <QMouseEvent>

PressLabel::PressLabel( QWidget* parent):
    QLabel (parent)
{

}

void PressLabel::mousePressEvent(QMouseEvent *event)
{
    if(event->button() == Qt::LeftButton){
        emit clicked();
    }
}
