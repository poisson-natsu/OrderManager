#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QtQuick/QQuickView>
#include <QScreen>
#include "excel.h"
#include "imageutil.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("OrderManager");
    app.setApplicationVersion("1.0.0");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    const char*        uri = "com.natsu.qrcode";
    const int versionMajor = 1;
    const int versionMinor = 0;
    qmlRegisterType<Excel>(uri, versionMajor, versionMinor, "Excel");

    /*
    QQmlApplicationEngine engine(QUrl("qrc:/qml/main.qml"));
    QObject* topLevel = engine.rootObjects().value(0);
    QQuickWindow* window = qobject_cast<QQuickWindow*>(topLevel);
    if (!window) {
        qWarning("Error: Your root item has to be a Window.");
        return -1;
    }

    */

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    // window->show();

    return app.exec();
}
