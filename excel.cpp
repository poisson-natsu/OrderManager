#include "excel.h"
#include <QVariant>
#include "xlsxdocument.h"
#include "xlsxworksheet.h"
#include "xlsxcellrange.h"
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QVariantMap>

using namespace QXlsx;

Excel::Excel(QObject *parent) : QObject(parent)
{
    m_tags.append("businessPark");
    m_tags.append("businessType");
    m_tags.append("category");
    m_tags.append("numbers");
    m_tags.append("driverName");

    m_tags.append("truckNo");
    m_tags.append("outTime");
    m_tags.append("applicant");
    m_tags.append("outDate");
}

void Excel::importExcel(const QString &xlsName)
{
    QVariantList ret;
    QString name = xlsName;
#ifdef Q_OS_WIN
    name = name.remove("file:///");
#else
    name = name.remove("file://");
#endif
    QFile file(name);
    qDebug() << "name:" << name;
    if (!file.exists()) {
        qDebug() << "文件不存在？？？";
        return;
    }
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "打开文件失败！";
        return;
    }
    Document xlsx(&file);
    foreach (QString sheetName, xlsx.sheetNames()) {
//        qDebug() << "sheet name: " << sheetName;
        Worksheet *sheet = dynamic_cast<Worksheet *>(xlsx.sheet(sheetName));
        if (sheet) {
            int row = 2;
            while (sheet->cellAt(row, 1) && sheet->cellAt(row, 1)->value().isValid()) {
                QVariantMap map;
                for(int c = 0; c < m_tags.size(); c++) {
                    map.insert(m_tags[c], sheet->cellAt(row, c+1)->value());
                }
                map.insert("checked", false);
                ret.append(map);
                row++;
            }
        }
    }
//    qDebug() << "ret: " << ret;
    Q_EMIT importDataChanged(ret);
    file.close();
}

QString Excel::billImagePath()
{
    qDebug() << "homePath:" << QDir::homePath();
    return QDir::homePath();
}
