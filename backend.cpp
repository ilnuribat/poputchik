#include "backend.h"

BackEnd::BackEnd(QQuickItem *parent) :
    QQuickItem(parent)
{
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    mainWindow = engine.rootObjects().value(0);
    helloButton = mainWindow->findChild<QObject*>("helloButton");
    iDDD = mainWindow->findChild<QObject*>("idDD");
    engine.rootContext()->setContextProperty("backEnd", this);

}

void BackEnd::registrationInServer(QString HUMAN, QString phone, QString name)
{
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    //helloButton->setProperty("enabled", "false");
    connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotregistrationInServer(QNetworkReply*)));
    QString prepareRequest("http://192.168.1.168:8080/registration");
    QNetworkRequest request(QUrl(prepareRequest.toUtf8()));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QString params("human=");
    params.append(HUMAN);
    params.append("&name=");
    params.append(name);
    params.append("&phone=");
    params.append(phone);
    pManager->deleteLater();
}

void BackEnd::slotregistrationInServer(QNetworkReply *reply)
{
    QString str = QString(reply->readAll());
    qDebug() << str;
    iDDD->setProperty("text", str);
}
