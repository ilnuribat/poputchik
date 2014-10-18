#include "backend.h"

BackEnd::BackEnd(QQuickItem *parent) :
    QQuickItem(parent)
{
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    mainWindow = engine.rootObjects().value(0);

    loader = mainWindow->findChild<QObject*>("loader");

    engine.rootContext()->setContextProperty("backEnd", this);
    settings = new QSettings("settings.ini", QSettings::IniFormat);
    qDebug(settings->value("ID").toString().toUtf8());
    IP = "http://localhost";
    //IP = "http://194.58.100.50";
    if(settings->value("ID").toString() != NULL)
    {
        loader->setProperty("registered", "true");
        settings->setValue("registerred", "true");
    } else {
        loader->setProperty("registered", "false");
        settings->setValue("registerred", "false");
    }
    settings->sync();
}

void BackEnd::registrationInServer(QString HUMAN, QString phone, QString name)
{
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    //helloButton->setProperty("enabled", "false");
    connect(pManager, SIGNAL(finished(QNetworkReply*)), this,
            SLOT(slotregistrationInServer(QNetworkReply*)));
    QString prepareRequest(IP + "/registration");
    QNetworkRequest request(QUrl(prepareRequest.toUtf8()));
    request.setHeader(QNetworkRequest::ContentTypeHeader,
                      "application/x-www-form-urlencoded");
    QString params("human=");
    params.append(HUMAN);
    params.append("&name=");
    params.append(name);
    params.append("&phone=");
    params.append(phone);

    pManager->post(request, params.toUtf8());
    qDebug() << "registration in server" << HUMAN << " " << phone << " " << name;
}

void BackEnd::slotregistrationInServer(QNetworkReply *reply)
{
    if(QString(reply->readAll()).toInt() == 0)
    {//fails in registrations
        qDebug() << "error with registration: " << QString(reply->readAll());
        return ;
    }

    //Записываем значение в файл настроек
    settings->setValue("ID", QString(reply->readAll()));
    settings->setValue("registerred", "true");
    settings->sync();
    helloButton = mainWindow->findChild<QObject*>("helloButton");
    QMetaObject::invokeMethod(helloButton, "registrationSuccess");
}

void BackEnd::getTowns()
{
    //check for got towns
    settings->beginReadArray("towns");
    settings->endArray();
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply *)), this, SLOT(slotGotTowns(QNetworkReply *)));
    QString requestAddres(IP + "/towns");
    QNetworkRequest request(QUrl(requestAddres.toUtf8()));
    pManager->get(request);
}

void BackEnd::slotGotTowns(QNetworkReply *reply)
{
    //settings - checking for ready got towns, because it is not
    //good way to download towns again
    settings->setValue("townsGot", "true");


    QString JSONtowns(reply->readAll());
    TOWNS = mainWindow->findChild<QObject*>("sourceTowns");
    QJsonDocument jsonDoc = QJsonDocument::fromJson(JSONtowns.toUtf8());

    QJsonArray jsonArr;
    jsonArr = jsonDoc.array();
    QVariantMap map;
    settings->setValue("countOfTowns", QString::number(jsonArr.size()));
    settings->beginWriteArray("towns");
    for(int  i = 0; i < jsonArr.size(); i ++)
    {
        settings->setArrayIndex(i);
        settings->setValue("name", jsonArr.at(i).toString());
        map.insert("text", jsonArr.at(i).toString());
        QMetaObject::invokeMethod(TOWNS, "append", Q_ARG(QVariant, QVariant::fromValue(map)));
    }
    settings->endArray();
}

void BackEnd::waitingPageButton()
{
    qDebug() << "waiting page Button clicked!";
}
