#include "backend.h"

BackEnd::BackEnd(QQuickItem *parent) :
    QQuickItem(parent)
{
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    mainWindow = engine.rootObjects().value(0);

    engine.rootContext()->setContextProperty("backEnd", this);

    this->IP = "http://localhost:8080";
    //this->IP = "http://194.58.100.50";

    qDebug() << this->IP;

    QObject *loader = mainWindow->findChild<QObject*>("loader");
    timer = new QTimer();
    timer->start(5000);

    //Вытаскиваем ID из конфиг файлов. Если его нет, то регистрируем пользователя
    settings = new QSettings("settings.ini", QSettings::IniFormat);

    QString currentQMLPage = settings->value("currentQML").toString();
    this->HUMAN = settings->value("human").toString();
    this->ID = settings->value("ID").toInt();

    //Если пассажир зарегестриован
    if(this->ID > 0)
    {
        //Отправляем на loader страницу RegPage
        loadingRegPage();
        //Инициализация глобальных переменных
        return;
    }

    //Если не зарегистрирован, то оправляем на страницу регистрации HelloPage
    QString helloPageQML = "qrc:/QMLs/HelloPage.qml";
    QMetaObject::invokeMethod(loader, "setQML", Q_ARG(QVariant, QVariant::fromValue(helloPageQML)));

    //В случае, если ни одно время не выбрали
    //Обновление страницы статуса очереди, в которую мы уже встали
    //connect(timer, SIGNAL(timeout()), this, SLOT(getQueueInfo()));

    //Это - стартовая точка. С этого дня будем считать все даты.

}

//Hello Page
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

    this->ID = strID.toInt();
    //Записываем значение в файл настроек
    settings->setValue("ID", strID);
    settings->setValue("registerred", "true");
    settings->setValue("human", this->HUMAN);
    settings->sync();

    this->loadingRegPage();
}

//RegPage
void BackEnd::loadingRegPage() {
    //send RegPage.qml to loader.source
    QObject *loader = mainWindow->findChild<QObject*>("loader");
    QString regPageQML = "qrc:/QMLs/RegPage.qml";
    qDebug() << "setting RegPage";
    QMetaObject::invokeMethod(loader, "setQML",
                              Q_ARG(QVariant, QVariant::fromValue(regPageQML)));
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
    if(this->currentQML != "qrc:/QMLs/RegPage.qml")
    {
        qDebug() << "RegPage is not loaded" << this->currentQML;
        return;
    }

    //Получить список городов
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply *)), this, SLOT(slotGotDestTowns(QNetworkReply *)));
    //Заглушка
    QString requestAddres(IP + "/Desttowns?source=" +
                          QString::number(this->townSource) + "&date=0");
    //+ QString::number(this->DATE));

    QNetworkRequest request(QUrl(requestAddres.toUtf8()));
    pManager->get(request);
}
void BackEnd::setExactTime(QString time)
{
    this->TIME = time;
}
void BackEnd::slotGotSourceTowns(QNetworkReply *reply)
{
    QString JSONtowns(reply->readAll());
    QObject *SourceTOWNS = mainWindow->findChild<QObject*>("sourceTowns");
    QObject *DestTowns = mainWindow->findChild<QObject*>("sourceTowns");
    QMetaObject::invokeMethod(SourceTOWNS, "clearList");
    QMetaObject::invokeMethod(DestTowns, "clearList");

    QJsonDocument jsonDoc = QJsonDocument::fromJson(JSONtowns.toUtf8());
    QJsonArray jsonArr;
    jsonArr = jsonDoc.array();
    QVariantMap map;
    for(int  i = 0; i < jsonArr.size(); i ++)
    {
        map.insert("text", jsonArr.at(i).toString());
        this->townSourceNames[i] = jsonArr.at(i).toString();
        QMetaObject::invokeMethod(SourceTOWNS, "append", Q_ARG(QVariant, QVariant::fromValue(map)));
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
    qDebug() << "got destination towns";
}
void BackEnd::setDestinationTown(int index)
{
    this->townDestination = index;
    this->directionID = 0;
    this->getDirection();
    QObject *goToTableButton = this->mainWindow->findChild<QObject*>("goToTableButton");
    //Замораживаем Кнопку goToTable
    goToTableButton->setProperty("enabled", "false");
    qDebug() << index << "from DestTowns : disabled";

    //this->settings->setValue("townNameDest", this->);
}
void BackEnd::setSourceTown(int index)
{
    qDebug() << "setSourceTown";
    this->townSource = index;
    this->directionID = 0;
    this->getDirection();
    this->getDestTowns();
}
void BackEnd::getDirection()
{
    if(this->currentQML != "qrc:/QMLs/RegPage.qml")
        return;
    qDebug() << "request for getting direction";
    QNetworkAccessManager *pManager = new QNetworkAccessManager(this);
    connect(pManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotGotDirection(QNetworkReply*)));
    QString  requestAddress(IP + "/direction?source=" + QString::number(this->townSource) + "&destination=" + QString::number(this->townDestination));
    QNetworkRequest request(QUrl(requestAddress.toUtf8()));
    pManager->get(request);
}
void BackEnd::slotGotDirection(QNetworkReply *reply)
{
    this->directionID = QString(reply->readAll()).toInt();

    if(this->directionID == 0)
        return;
    this->settings->setValue("directionID", this->directionID);

    QObject *goToTableButton = this->mainWindow->findChild<QObject*>("goToTableButton");
    //Размораживаем Кнопку goToTable
    goToTableButton->setProperty("enabled", "true");
}
void BackEnd::setDate(QDate date)
{
    qDebug() << "setting date";
    this->DATE = date;
    this->getDestTowns();
}
void BackEnd::setSeatsBooked(int count)
{
    this->SEATS_BOOKED = count;
}


void BackEnd::goDriversList()
{
    //direction found!
    //Тут мы должны перевести чувака на TimePage
    QObject *loader = this->mainWindow->findChild<QObject*>("loader");
    QString driversList = "qrc:/QMLs/DrivesrList.qml";
    QMetaObject::invokeMethod(loader, "setQML", Q_ARG(QVariant, QVariant::fromValue(driversList)));

    //Установить там выбранную дату
    QObject *timeTableTitle = this->mainWindow->findChild<QObject*>("timeTableTitle");
    timeTableTitle->setProperty("text", this->chosenDate);
}


void BackEnd::loadedRegPage()
{
    //Загрузка городов отправления
    //установка сегодняшней даты
    //установка количества мест, которые были установлены в предыдущий раз
    //установка города отправления, который был назначен в предыдущий раз
    //установка записи в "меню"
    getSourceTowns();
    this->townSource = 1;
    getDestTowns();

    QObject *toolBarText = mainWindow->findChild<QObject*>("toolBarText");
    toolBarText->setProperty("text",
                             this->HUMAN == "driver" ? "Создать поездку" : "Найти водителя");

    QObject *RegPage = mainWindow->findChild<QObject*>("RegPage");
    RegPage->setProperty("human", this->HUMAN);

}
void BackEnd::loadedHelloPage()
{
    //ничего в приницпе не надо делать
}
void BackEnd::loadedSignal(QString url)
{
    qDebug() << "handled!\t" << url;
    this->currentQML = url;

    //this->settings->setValue("currentQML", url);
    //this->settings->sync();

    if(url == "qrc:/QMLs/RegPage.qml")
        this->loadedRegPage();
}
