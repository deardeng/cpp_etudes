#ifndef PRESSLABEL_H
#define PRESSLABEL_H
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
