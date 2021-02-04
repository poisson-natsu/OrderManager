#ifndef EXCEL_H
#define EXCEL_H

#include <QObject>
#include "xlsxdocument.h"

class Excel : public QObject
{
    Q_OBJECT
public:
    explicit Excel(QObject *parent = nullptr);



signals:

};

#endif // EXCEL_H
