#include "backend.h"

BackEnd::BackEnd(QQuickItem *parent) :
    QQuickItem(parent)
{
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    mainWindow = engine.rootObjects().value(0);

    QObject *loader = mainWindow->findChild<QObject*>("loader");

    engine.rootContext()->setContextProperty("backEnd", this);
    settings = new QSettings("settings.ini", QSettings::IniFormat);
    qDebug() << settings->value("ID").toString() << "settings.ini -> value";
    IP = "http://localhost:8080";
    //IP = "http://194.58.100.50";
    QObject *toolBarText = mainWindow->findChild<QObject*>("toolBarText");
    if(settings->value("ID").toString() != NULL)
    {
        loader->setProperty("registered", "true");
        getTowns();
        toolBarText->setProperty("text", "Выберите направление");
    } else {
        loader->setProperty("registered", "false");
    }
    settings->sync();

    //В случае, если ни одно время не выбрали
    this->timeID = 0;
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
}

void BackEnd::slotregistrationInServer(QNetworkReply *reply)
{
    QString strID = QString(reply->readAll());
    qDebug() << strID << "ID - registration";
    if(strID.toInt() == 0)
    {//fails in registrations
        qDebug() << "error with registration: " << QString(reply->readAll());
        return ;
    }

    //Записываем значение в файл настроек
    settings->setValue("ID", strID);
    settings->setValue("registerred", "true");
    settings->sync();
    QObject *helloButton = mainWindow->findChild<QObject*>("helloButton");
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
    QObject *TOWNS = mainWindow->findChild<QObject*>("sourceTowns");
    if(!TOWNS) return;
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
    qDebug() << "towns got";
}

void BackEnd::waitingPageButton()
{
    qDebug() << "waiting page Button clicked!";
}

void BackEnd::standToQueue(int TIME)
{
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    QNetworkRequest request;
    delete pManager;
    qDebug() << "standind to Queue: " << TIME;
}

void BackEnd::setDestinationTown(int index)
{
    qDebug() << "index of destination town: " << index;
}

void BackEnd::setTimeQueue(int x)
{
    this->timeID = x;
    qDebug() << this->timeID;
}

void BackEnd::ChooseTimeLoaded()
{
    QObject *chooseTime = mainWindow->findChild<QObject*>("ChooseTime_title");
    QString str = "Выбрано время:" + QString::number(this->timeID * 3);
    chooseTime->setProperty("text", str);
}

void BackEnd::getTimeTable()
{
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotGotTimeTable(QNetworkReply*)));
    QString requestAddres(IP + "/data\?direction=2");
    QNetworkRequest request(QUrl(requestAddres.toUtf8()));
    pManager->get(request);
}

void BackEnd::slotGotTimeTable(QNetworkReply *reply)
{
    QString JSONtimes(reply->readAll());
    QObject *TIMES = mainWindow->findChild<QObject*>("timeGrid");
    if(!TIMES) return;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(JSONtimes.toUtf8());
    QJsonArray jsonArr = jsonDoc.array();
    qDebug() << jsonArr.size() << "array size";
    QVariantMap map;
    int queueArr[16] = {0};
    for(int i = 0; i < jsonArr.size(); i ++) {
        queueArr[i] = jsonArr.at(i).toInt();
    }
    for(int i = 0; i < 8; i ++)
    {
        map.insert("passengers", QString::number(queueArr[i]));
        map.insert("drivers", QString::number(queueArr[8 + i]));

        QString timeStr = QString(3*i < 10 ? "0" : "") + QString::number(3*i) + ":00";
        qDebug() << timeStr;
        map.insert("time", timeStr);

        qDebug() << map;
        QMetaObject::invokeMethod(TIMES, "append", Q_ARG(QVariant, QVariant::fromValue(map)));
    }
}
