#include "backend.h"

BackEnd::BackEnd(QQuickItem *parent) :
    QQuickItem(parent)
{
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    mainWindow = engine.rootObjects().value(0);

    QObject *loader = mainWindow->findChild<QObject*>("loader");

    engine.rootContext()->setContextProperty("backEnd", this);
    settings = new QSettings("settings.ini", QSettings::IniFormat);
    QString IDFromSettings = settings->value("ID").toString();
    IP = "http://localhost:8080";
    //IP = "http://194.58.100.50";
    QObject *toolBarText = mainWindow->findChild<QObject*>("toolBarText");
    if(IDFromSettings != NULL)
    {
        loader->setProperty("registered", "true");
        getTowns();
        toolBarText->setProperty("text", "Выберите направление");
        this->ID = IDFromSettings.toInt();
        this->HUMAN = settings->value("human").toString();
    } else {
        loader->setProperty("registered", "false");
    }
    settings->sync();
    //В случае, если ни одно время не выбрали
    timer = new QTimer();
    timer->start(1000);
    connect(timer, SIGNAL(timeout()), this, SLOT(getQueueInfo()));
    //connect(timer, SIGNAL(timeout()), this, SLOT(getTimeTableTimer()));
    this->date = 1;
}
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
    this->ID = strID.toInt();
    //Записываем значение в файл настроек
    settings->setValue("ID", strID);
    settings->setValue("registerred", "true");
    settings->setValue("human", this->HUMAN);
    settings->sync();
    QObject *helloButton = mainWindow->findChild<QObject*>("helloButton");
    QMetaObject::invokeMethod(helloButton, "registrationSuccess");
}
void BackEnd::getTowns()
{
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply *)), this, SLOT(slotGotTowns(QNetworkReply *)));
    QString requestAddres(IP + "/towns");
    QNetworkRequest request(QUrl(requestAddres.toUtf8()));
    pManager->get(request);
}
void BackEnd::slotGotTowns(QNetworkReply *reply)
{
    QString JSONtowns(reply->readAll());
    QObject *TOWNS = mainWindow->findChild<QObject*>("sourceTowns");
    if(!TOWNS) return;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(JSONtowns.toUtf8());
    QJsonArray jsonArr;
    jsonArr = jsonDoc.array();
    QVariantMap map;
    for(int  i = 0; i < jsonArr.size(); i ++)
    {
        map.insert("text", jsonArr.at(i).toString());
        this->townNames[i] = jsonArr.at(i).toString();
        QMetaObject::invokeMethod(TOWNS, "append", Q_ARG(QVariant, QVariant::fromValue(map)));
    }
}
void BackEnd::setTimeQueue(int x)
{
    this->timeID = x;
    qDebug() << "time:" << this->timeID;
}
void BackEnd::ChooseTimeLoaded()
{
    QObject *chooseTime = mainWindow->findChild<QObject*>("ChooseTime_title");
    QString str = "Выбрано время:" + QString::number(this->timeID * 3);
    chooseTime->setProperty("text", str);
}
void BackEnd::getTimeTable()
{
  //Проверяем, находимся ли мы на странице WaitingPage.qml
  qDebug() << "timeTable called";
  QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
  connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotGotTimeTable(QNetworkReply*)));
  QString requestAddres(IP + "/data?direction=" + QString::number(this->directionID) + "&date=" + QString::number(1));
  QNetworkRequest request(QUrl(requestAddres.toUtf8()));
  pManager->get(request);
}
void BackEnd::slotGotTimeTable(QNetworkReply *reply)
{
    QString JSONtimes(reply->readAll());
    qDebug() << JSONtimes;
    QObject *TIMES = mainWindow->findChild<QObject*>("timeGrid");
    if(!TIMES) return;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(JSONtimes.toUtf8());
    QJsonArray jsonArr = jsonDoc.array();
    QVariantMap map;
    int queueArr[16] = {0};
    for(int i = 0; i < jsonArr.size(); i ++) {
        queueArr[i] = jsonArr.at(i).toInt();
    }
    for(int i = 0; i < 8; i ++)
    {
        map.insert("drivers", QString::number(queueArr[i]));
        map.insert("passengers", QString::number(queueArr[8 + i]));

        QString timeStr = QString(3*i < 10 ? "0" : "") + QString::number(3*i) + ":00";
        map.insert("time", timeStr);
        QMetaObject::invokeMethod(TIMES, "append", Q_ARG(QVariant, QVariant::fromValue(map)));
    }
}
void BackEnd::setDestinationTown(int index)
{
    qDebug() << "index of destination town: " << index;
    this->townDestination = index;
}
void BackEnd::setSourceTown(int index)
{
    qDebug() << "index of source town: " << index;
    this->townSource = index;
}
void BackEnd::checkDirection()
{
  qDebug() << "checking direction";
  QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
  connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotGotDirection(QNetworkReply*)));
  QString  requestAddress(IP + "/direction?source=" + QString::number(this->townSource) + "&destination=" + QString::number(this->townDestination));
  QNetworkRequest request(QUrl(requestAddress.toUtf8()));
  pManager->get(request);
}
void BackEnd::slotGotDirection(QNetworkReply *reply)
{
  QObject *goToTableButton = mainWindow->findChild<QObject*>("goToTableButton");
  QString directionID = QString(reply->readAll());
  qDebug() << directionID;
  if(directionID.size() == 0)
  {//fails to get direction ID
    qDebug() << "Fail: getting direction ID";
    return;
  }
  this->directionID = directionID.toInt();
  if(this->directionID == 0)
  {//there is no such direction
      qDebug() << "there is no such direction";
      QMetaObject::invokeMethod(goToTableButton, "failDirection");
      return ;
  }

  //direction found!
  QMetaObject::invokeMethod(goToTableButton, "goToTable");
}
void BackEnd::standToQueue()
{
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    qDebug() << "standind to Queue:";
    qDebug() << "-HUMAN-" << this->HUMAN;
    qDebug() << "--ID---" << this->ID;
    qDebug() << "-SEATS-" << this->SEATS_BOOKED;
    qDebug() << "direct-" << this->directionID;
    qDebug() << "--TIME-" << this->timeID;
    qDebug() << "--DATE-" << this->date;
    connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotStandToQueue(QNetworkReply*)));

    QString requestAddress(IP + "/q" + this->HUMAN);
    QNetworkRequest request(QUrl(requestAddress.toUtf8()));
    QString params("id=");
    params.append(QString::number(this->ID));
    params.append("&direction=");
    params.append(QString::number(this->directionID));
    params.append("&time=");
    params.append(QString::number(this->timeID));
    params.append(this->HUMAN == "driver" ? "&seats=" : "&booked=");
    params.append(QString::number(this->SEATS_BOOKED));
    params.append("&date=");
    params.append(QString::number(this->date));
    pManager->post(request, params.toUtf8());
}
void BackEnd::setSeatsBooked(int count)
{
    this->SEATS_BOOKED = count;
    qDebug() << "seats: " << this->SEATS_BOOKED;
}
void BackEnd::slotStandToQueue(QNetworkReply *reply)
{
    QString str = QString(reply->readAll());
    qDebug() << str;
}
void BackEnd::getStatus(){
  //get request to Server. I want to know
  //all about Queue, I am standing on
  //ONLY FOR WAITING PAGE

  QObject *refreshWaitingPage = mainWindow->findChild<QObject*>("refreshWaitingPage");
  //Проверяем, находимся ли мы на странице WaitingPage.qml
  if(!refreshWaitingPage) return;

  QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
  connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotGetQueueInfo(QNetworkReply*)));
  QString requestAddress(IP);
  requestAddress.append("/queueStatus?");
  requestAddress.append("human=" + this->HUMAN);
  requestAddress.append("&time=" + QString::number(this->timeID));
  requestAddress.append("&direction=" + QString::number(this->directionID));
  requestAddress.append("&id=" + QString::number(this->ID));
  QNetworkRequest request(QUrl(requestAddress.toUtf8()));
  pManager->get(request);
}
void BackEnd::slotGetQueueInfo(QNetworkReply *reply)
{
  QObject *refreshWaitingPage = mainWindow->findChild<QObject*>("refreshWaitingPage");
  //Проверяем, находимся ли мы на странице WaitingPage.qml
  if(!refreshWaitingPage) return;

  QObject *inQueueText = mainWindow->findChild<QObject*>("inQueueText");
  QObject *directionText = mainWindow->findChild<QObject*>("directionText");
  QObject *timeText = mainWindow->findChild<QObject*>("timeText");
  directionText->setProperty("text", this->townNames[this->townSource - 1] +
      " - " + this->townNames[this->townDestination - 1]);


  qDebug() << "Got info about queue";
  QString str = QString(reply->readAll());
  qDebug() << str;
}
