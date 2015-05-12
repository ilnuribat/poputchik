#include "backend.h"

BackEnd::BackEnd(QQuickItem *parent) :
    QQuickItem(parent)
{
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    mainWindow = engine.rootObjects().value(0);


    engine.rootContext()->setContextProperty("backEnd", this);
    settings = new QSettings("settings.ini", QSettings::IniFormat);
#ifdef _DEBUG
    this->IP = "http://localhost";
#endif
    //this->IP = "http://10.10.14.141:8080";
    this->IP = "http://194.58.100.50";

    //Вытаскиваем IP адрес из конфиг файлов. Зачем этот кусок кода вообще нужен?
    if(settings->value("IP").toString() != NULL)
      this->IP = settings->value("IP").toString();
    qDebug() << this->IP;

    QObject *loader = mainWindow->findChild<QObject*>("loader");

    //Вытаскиваем ID из конфиг файлов. Если его нет, то регистрируем пользователя
    QString IDFromSettings = settings->value("ID").toString();
    if(IDFromSettings != NULL)
    {

        loader->setProperty("registered", "true");
        //Отправляем на loader страницу RegPage
        loadingRegPage();
        //Инициализация глобальных переменных
        this->ID = IDFromSettings.toInt();
        this->HUMAN = settings->value("human").toString();
        emit getDestTowns();
    } else {
        //Если не зарегистрирован, то оправляем на страницу регистрации HelloPage
        QString helloPageQML = "qrc:/QMLs/HelloPage.qml";
        QMetaObject::invokeMethod(loader, "setQML", Q_ARG(QVariant, QVariant::fromValue(helloPageQML)));
        loader->setProperty("registered", "false");
    }
    settings->sync();

    //В случае, если ни одно время не выбрали
    timer = new QTimer();
    timer->start(3000);

    //Обновление страницы статуса очереди, в которую мы уже встали
    connect(timer, SIGNAL(timeout()), this, SLOT(getQueueInfo()));

    //Обновление таблицы очередей на странице TimeTable
    connect(timer, SIGNAL(timeout()), this, SLOT(getTimeTableTimer()));

    //Это - стартовая точка. С этого дня будем считать все даты.
    this->STARTDATE.setDate(2015, 1, 1);
    this->DATE = this->STARTDATE.daysTo(QDate::currentDate());
    this->townSource = 1;

}
void BackEnd::getTimeTable()
{
    //Мы находимся на странице TimeTable
    //Отправляем запрос на вывод состояния очереди по данному направлению
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotGotTimeTable(QNetworkReply*)));
    QString requestAddres(IP + "/data?direction=" + QString::number(this->directionID) + "&date=" + QString::number(this->DATE));
    QNetworkRequest request(QUrl(requestAddres.toUtf8()));
    pManager->get(request);
}
void BackEnd::slotGotTimeTable(QNetworkReply *reply)
{


    //Получили ответ сервера, парсим ответ. JSON
    QObject *TIMES = mainWindow->findChild<QObject*>("timeGrid");
    if(!TIMES) return;


    //Установить там выбранную дату
    QObject *timeTableTitle = this->mainWindow->findChild<QObject*>("timeTableTitle");
    if(timeTableTitle)
        timeTableTitle->setProperty("text", this->chosenDate);

    //Очистка списка
    QMetaObject::invokeMethod(TIMES, "clearTimeTable");

    QString JSONtimes(reply->readAll());

    //if response = 'unknown direction'
    if(JSONtimes[0] == 'u') {
        return;
    }
    QJsonDocument jsonDoc = QJsonDocument::fromJson(JSONtimes.toUtf8());
    QJsonArray jsonArr = jsonDoc.array();

    for(int i = 0; i < jsonArr.size(); i ++)
    {
        QMetaObject::invokeMethod(TIMES, "append", Q_ARG(QVariant, jsonArr.at(i).toVariant()));
    }

}
void BackEnd::standToQueue()
{
    //
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotStandToQueue(QNetworkReply*)));
    QString requestAddress(IP + "/q" + this->HUMAN);
    QNetworkRequest request(QUrl(requestAddress.toUtf8()));
    QString params("id=" + QString::number(this->ID));
    params.append("&direction=" + QString::number(this->directionID));
    params.append("&time=" + QString::number(this->timeID));
    params.append(this->HUMAN == "driver" ? "&seats=" : "&booked=");
    params.append(QString::number(this->SEATS_BOOKED));
    params.append("&date=" + QString::number(this->DATE));
    qDebug() << params;
    pManager->post(request, params.toUtf8());
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
  requestAddress.append("&date=" + QString::number(this->DATE));
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
  QObject *drivePassTool = mainWindow->findChild<QObject*>("drivePassTool");
  QObject *listHumans = mainWindow->findChild<QObject*>("listHumans");
  drivePassTool->setProperty("text", this->HUMAN == "driver" ? "Пассажиры:" : "Водитель");
  directionText->setProperty("text", this->townSourceNames[this->townSource - 1] +
      " - " + this->townSourceNames[this->townDestination - 1]);

  //Пережитки старой идеи
  timeText->setProperty("text", this->timeName);

  QMetaObject::invokeMethod(listHumans, "clearList");
  QString str = QString(reply->readAll());
  QStringList people = str.split('.');
  inQueueText->setProperty("text", people.at(0));
  QVariantMap map;
  for(int i = 1; i < people.size(); i ++)
  {
      QStringList human = people.at(i).split(',');
      map.insert("name", human.at(0));
      map.insert("phone", human.at(1));
      QMetaObject::invokeMethod(listHumans, "append", Q_ARG(QVariant, QVariant::fromValue(map)));
  }
}
void BackEnd::loadingRegPage() {
    //make load RegPage. include setQML, getTowns, toolBar, tumbler
    QObject *loader = mainWindow->findChild<QObject*>("loader");
    QObject *toolBarText = mainWindow->findChild<QObject*>("toolBarText");
    QString regPageQML = "qrc:/QMLs/RegPage.qml";
    QMetaObject::invokeMethod(loader, "setQML", Q_ARG(QVariant, QVariant::fromValue(regPageQML)));
    getSourceTowns();
    toolBarText->setProperty("text", "Выберите направление");

    QObject *tumblerDatePicker = mainWindow->findChild<QObject*>("tumblerDatePicker");
    if(!tumblerDatePicker) {
        qDebug() << "tumbler is not found";
        return;
    }
    qDebug() << "tumbler is found";
    QVariant month;
    month.setValue(QDate::currentDate().month());
    QMetaObject::invokeMethod(tumblerDatePicker, "setMonth", Q_ARG(QVariant, month));
    QVariant day;
    day.setValue(QDate::currentDate().day());
    QMetaObject::invokeMethod(tumblerDatePicker, "setDay", Q_ARG(QVariant, day));

    QObject *textSeatsBooked = mainWindow->findChild<QObject *>("textSeatsBooked");
    QString howMuchSeatsBooked = "Сколько ";
    howMuchSeatsBooked.append(this->HUMAN == "driver" ? "свободных мест:" : "мест забронировать:");
    textSeatsBooked->setProperty("text", howMuchSeatsBooked);
}
void BackEnd::getSourceTowns()
{
    //Получить список городов
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply *)), this, SLOT(slotGotSourceTowns(QNetworkReply *)));
    QString requestAddres(IP + "/towns");
    QNetworkRequest request(QUrl(requestAddres.toUtf8()));
    pManager->get(request);
}
void BackEnd::getDestTowns()
{
    //Получить список городов
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply *)), this, SLOT(slotGotDestTowns(QNetworkReply *)));
    QString requestAddres(IP + "/Desttowns?source=" +
                          QString::number(this->townSource) + "&date=" + QString::number(this->DATE));

    QNetworkRequest request(QUrl(requestAddres.toUtf8()));
    pManager->get(request);
}


void BackEnd::slotGotSourceTowns(QNetworkReply *reply)
{
    QString JSONtowns(reply->readAll());
    QObject *TOWNS = mainWindow->findChild<QObject*>("sourceTowns");
    QMetaObject::invokeMethod(TOWNS, "clearList");

    if(!TOWNS) return;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(JSONtowns.toUtf8());
    QJsonArray jsonArr;
    jsonArr = jsonDoc.array();
    QVariantMap map;
    for(int  i = 0; i < jsonArr.size(); i ++)
    {
        map.insert("text", jsonArr.at(i).toString());
        this->townSourceNames[i] = jsonArr.at(i).toString();
        QMetaObject::invokeMethod(TOWNS, "append", Q_ARG(QVariant, QVariant::fromValue(map)));
    }
}
void BackEnd::slotGotDestTowns(QNetworkReply *reply)
{
    QString JSONtowns(reply->readAll());
    QObject *TOWNS = mainWindow->findChild<QObject*>("destinationTowns");
    QMetaObject::invokeMethod(TOWNS, "clearList");

    if(!TOWNS) return;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(JSONtowns.toUtf8());
    QJsonArray jsonArr;
    jsonArr = jsonDoc.array();
    QVariantMap map;
    for(int  i = 0; i < jsonArr.size(); i ++)
    {
        map.insert("text", jsonArr.at(i).toString());
        QMetaObject::invokeMethod(TOWNS, "append", Q_ARG(QVariant, QVariant::fromValue(map)));
    }
}
void BackEnd::setTimeQueue(int x, QString timeName)
{
    this->timeID = x;
    this->timeName = timeName;
}

void BackEnd::setDestinationTown(int index)
{
    this->townDestination = index;
}
void BackEnd::setSourceTown(int index)
{
    this->townSource = index;

}
void BackEnd::goTimeTable()
{
    QObject *RegPage = this->mainWindow->findChild<QObject*>("RegPage");
    //Замораживаем страницу
    RegPage->setProperty("enabled", "false");

    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotGotDirection(QNetworkReply*)));
    QString  requestAddress(IP + "/direction?source=" + QString::number(this->townSource) + "&destination=" + QString::number(this->townDestination));
    QNetworkRequest request(QUrl(requestAddress.toUtf8()));
    pManager->get(request);
}
void BackEnd::slotGotDirection(QNetworkReply *reply)
{
    QString directionID = QString(reply->readAll());
    this->directionID = directionID.toInt();

    if(this->directionID == 0)
    {//there is no such direction
        qDebug() << "there is no such direction";
        //Сейчас надо всё разморозаить, сказать, чтобы он выбрал
        //другой направление
        QObject *RegPage = this->mainWindow->findChild<QObject*>("RegPage");
        //Размораживаем страницу
        RegPage->setProperty("enabled", "true");
        QObject *toolBarText = this->mainWindow->findChild<QObject*>("toolBarText");
        toolBarText->setProperty("text", "Выберите другой маршрут");
        getSourceTowns();
        return ;
    }
    //direction found!
    //Тут мы должны перевести чувака на TimePage
    QObject *loader = this->mainWindow->findChild<QObject*>("loader");
    QString TimePage = "qrc:/QMLs/TimePage.qml";
    QMetaObject::invokeMethod(loader, "setQML", Q_ARG(QVariant, QVariant::fromValue(TimePage)));

    //Установить там выбранную дату
    QObject *timeTableTitle = this->mainWindow->findChild<QObject*>("timeTableTitle");
    timeTableTitle->setProperty("text", this->chosenDate);
}

void BackEnd::setDate(int day, int month)
{
    //До инициализации страницы к нам почему-то уже прилетают вызовы
    if(day * month == 0) return;

    QDate *date = new QDate(2015, month, day);

    QString monthList[12] = {"января", "февраля", "марта", "апреля", "мая",
                                 "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"};

    this->chosenDate = QString::number(day) + " " + monthList[month - 1];
    qDebug() << this->chosenDate;
    this->DATE = - date->daysTo(this->STARTDATE);
}
void BackEnd::setSeatsBooked(int count)
{
    this->SEATS_BOOKED = count;
}
void BackEnd::removeFromQueue()
{
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotDropFromQueue(QNetworkReply*)));
    QString requestAddress(IP);
    requestAddress.append("/dropFromQueue?");
    requestAddress.append("human=" + this->HUMAN);
    requestAddress.append("&time=" + QString::number(this->timeID));
    requestAddress.append("&direction=" + QString::number(this->directionID));
    requestAddress.append("&id=" + QString::number(this->ID));
    requestAddress.append("&date=" + QString::number(this->DATE));
    QNetworkRequest request(QUrl(requestAddress.toUtf8()));
    pManager->get(request);
}
void BackEnd::slotDropFromQueue(QNetworkReply *reply)
{
    QString strReply(reply->readAll());
    qDebug() << strReply << "removed from Queue";
}

void BackEnd::loadedRegPage()
{
    //Загрузка городов отправления
    //установка сегодняшней даты
    //установка количества мест, которые были установлены в предыдущий раз
    //установка города отправления, который был назначен в предыдущий раз
    //установка записи в "меню"

}
void BackEnd::loadedHelloPage()
{
    //ничего в приницпе не надо делать
    //установка записи в "меню"
}
void BackEnd::loadedTimePage()
{
    //загрузка данных
    //Установка даты
    //установка записи в "меню"
}
void BackEnd::loadedWaitingPage()
{
    //Установка даты
    //установка маршрута
    //установка записи в "меню"
}

void BackEnd::loadedSignal()
{
    qDebug() << "handled!";
}
