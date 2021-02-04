#ifndef IMAGEUTIL_H
#define IMAGEUTIL_H

#include <QObject>

class ImageUtil : public QObject
{
    Q_OBJECT
public:
    explicit ImageUtil(QObject *parent = nullptr);

    static QVariant imageName(QString name);

signals:

};

#endif // IMAGEUTIL_H
