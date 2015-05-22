#include "backend.h"
//Все файлы, связанные со страницой helloPage

void BackEnd::registrationInServer(QString HUMAN, QString phone, QString name)
{
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply*)), this,
            SLOT(slotregistrationInServer(QNetworkReply*)));
    this->HUMAN = HUMAN;
    QString prepareRequest(IP + "/registration");
    QNetworkRequest request(QUrl(prepareRequest.toUtf8()));
    request.setHeader(QNetworkRequest::ContentTypeHeader,
                      "application/x-www-form-urlencoded");
    QString params("human=" + this->HUMAN);
    params.append("&name=" + name);
    params.append("&phone=" + phone);
    pManager->post(request, params.toUtf8());
    qDebug() << this->IP;
    qDebug() << params;
}
void BackEnd::slotregistrationInServer(QNetworkReply *reply)
{
    if(this->currentQML != "qrc:/QMLs/HelloPage.qml") {
        qDebug() << "slotRegistration: hello page is not current";
        return;
    }

    QObject *sayToAuthor = mainWindow->findChild<QObject*>("sayToAuthor");


    if(reply->error()) {
        qDebug() << "server is down or problems with the internet";
        QMetaObject::invokeMethod(sayToAuthor, "callOpen");
        return;
    }
    QString strID = QString(reply->readAll());
    qDebug() << strID << "ID - registration";
    QObject *helloButton = mainWindow->findChild<QObject*>("helloButton");

    if(strID.toInt() == 0 || strID.size() == 0)
    {//fails in registrations
        qDebug() << "Этот номер уже используется" << QString(reply->readAll());
        return ;
    }
    this->ID = strID.toInt();
    //Записываем значение в файл настроек
    settings->setValue("ID", strID);
    settings->setValue("registerred", "true");
    settings->setValue("human", this->HUMAN);
    settings->sync();

    QMetaObject::invokeMethod(helloButton, "registrationSuccess");
}

