#include "backend.h"


BackEnd::BackEnd(QQuickItem *parent) :
    QQuickItem(parent)
{
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    mainWindow = engine.rootObjects().value(0);
    helloButton = mainWindow->findChild<QObject*>("helloButton");
    loader = mainWindow->findChild<QObject*>("loader");

    engine.rootContext()->setContextProperty("backEnd", this);
    settings = new QSettings("settings.ini", QSettings::IniFormat);
    qDebug(settings->value("value1").toString().toUtf8());
    IP = "http://localhost";
    //IP = "http://194.58.100.50";
    if(settings->value("value1").toString() != NULL)
    {
        loader->setProperty("registered", "true");
    } else {
        loader->setProperty("registered", "false");
    }
    settings->setValue("value1", "26");
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
    QString str = QString(reply->readAll());

    //QSettings settings("settings.ini", QSettings::IniFormat);
    QString stringToSave = str;

    //Записываем значение в файл настроек
    settings->setValue("value1", stringToSave);
    settings->sync();

}

void BackEnd::getTowns()
{
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply *)), this, SLOT(slotGotTowns(QNetworkReply *)));
    QString requestAddres(IP + "/towns");
    QNetworkRequest request(QUrl(requestAddres.toUtf8()));
    pManager->get(request);
    qDebug() << "getting list of towns";
}

void BackEnd::slotGotTowns(QNetworkReply *reply)
{

    QString JSONtowns(reply->readAll());
    TOWNS = mainWindow->findChild<QObject*>("sourceTowns");
    QJsonDocument jsonDoc = QJsonDocument::fromJson(JSONtowns.toUtf8());
    QJsonObject jsonObj;
    QJsonValue jsonVal;
    QJsonArray jsonArr;
    jsonArr = jsonDoc.array();
    QVariantMap map;
    for(int  i = 0; i < jsonArr.size(); i ++)
    {
        map.insert("name" + QString(i), jsonArr.at(i).toString().toUtf8());
        qDebug() << jsonArr.at(i).toString();
        QMetaObject::invokeMethod(TOWNS, "append", Q_ARG(QVariant, QVariant::fromValue(map)));
    }
    int iterator = 0;
    qDebug() << map.size() << " :map, json: " << jsonArr.size();
    for(QVariantMap::iterator it = map.begin(); it != map.end(); it++)
    {
        iterator ++;
        qDebug() << it.value().toString() << " " << iterator;
    }
}


void BackEnd::waitingPageButton()
{
    qDebug() << "waiting page Button clicked!";
}
