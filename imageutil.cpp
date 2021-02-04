#include "imageutil.h"
#include <QVariant>

ImageUtil::ImageUtil(QObject *parent) : QObject(parent)
{

}

QVariant ImageUtil::imageName(QString name)
{
    return "../images/" + name + ".png";
}
