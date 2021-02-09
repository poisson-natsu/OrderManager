#ifndef EXCEL_H
#define EXCEL_H

#include <QObject>
#include <QVariant>
#include <QStringList>


class Excel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariant importData READ importData WRITE setImportData NOTIFY importDataChanged)
public:
    explicit Excel(QObject *parent = nullptr);

    QVariant importData() { return m_importData; }
    void setImportData(QVariant importData) { m_importData = importData; }

    Q_INVOKABLE void importExcel(const QString &xlsName);
    Q_INVOKABLE QString billImagePath();

signals:
    void importDataChanged(QVariant importData);

private:

    QVariant m_importData;
    QStringList m_tags;
};

#endif // EXCEL_H
