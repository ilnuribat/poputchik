#include "backend.h"

BackEnd::BackEnd(QQuickItem *parent) :
    QQuickItem(parent)
{
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    mainWindow = engine.rootObjects().value(0);
    helloButton = mainWindow->findChild<QObject*>("helloButton");
    waitingPageText = mainWindow->findChild<QObject*>("waitingPageText");
    iDDD = mainWindow->findChild<QObject*>("idDD");
    loader = mainWindow->findChild<QObject*>("loader");
    engine.rootContext()->setContextProperty("backEnd", this);
    settings = new QSettings("settings.ini", QSettings::IniFormat);
    qDebug(settings->value("value1").toString().toUtf8());
    if(settings->value("value1").toString() != NULL)
    {
        iDDD->setProperty("text", "true");
        //loader->setProperty("registered", "true");
    } else {
        //iDDD->setProperty("text", "false");
        //loader->setProperty("registered", "false");
    }
}

void BackEnd::registrationInServer(QString HUMAN, QString phone, QString name)
{
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    //helloButton->setProperty("enabled", "false");
    connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotregistrationInServer(QNetworkReply*)));
    QString prepareRequest("http://localhost/registration");
    QNetworkRequest request(QUrl(prepareRequest.toUtf8()));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QString params("human=");
    params.append(HUMAN);
    params.append("&name=");
    params.append(name);
    params.append("&phone=");
    params.append(phone);
    pManager->post(request, params.toUtf8());
    qDebug() << "registration in server";
}

void BackEnd::slotregistrationInServer(QNetworkReply *reply)
{
    QString str = QString(reply->readAll());
    qDebug() << "slot!" << str;
    //QSettings settings("settings.ini", QSettings::IniFormat);
    QString stringToSave = str;

    //Записываем значение в файл настроек
    settings->setValue("value1", stringToSave);
    settings->sync();
    //Считываем записанное значение и выводим в лог
    qDebug(settings->value("value1").toString().toUtf8());

}

void BackEnd::waitingPageButton()
{
    qDebug() << "set property.backend";
}
