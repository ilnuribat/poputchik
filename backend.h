#ifndef BACKEND_H
#define BACKEND_H

#include <QQuickItem>
#include <QQmlApplicationEngine>
#include <QNetworkAccessManager>
#include <QSettings>
#include <QtQuick>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <vector>
#include <QDate>

class BackEnd : public QQuickItem
{
    Q_OBJECT
public:
    explicit BackEnd(QQuickItem *parent = 0);

    Q_INVOKABLE void registrationInServer(QString HUMAN, QString phone, QString name);
    Q_INVOKABLE void getTowns();
    Q_INVOKABLE void standToQueue();
    Q_INVOKABLE void setTimeQueue(int x);
    Q_INVOKABLE void ChooseTimeLoaded();
    Q_INVOKABLE void getTimeTable();
    Q_INVOKABLE void setSourceTown(int index);
    Q_INVOKABLE void setDestinationTown(int index);
    Q_INVOKABLE void checkDirection();
    Q_INVOKABLE void setSeatsBooked(int count);
    Q_INVOKABLE void getStatus();
    Q_INVOKABLE void setDate(int day, int month);
    Q_INVOKABLE void loadingRegPage();

private:
  //Движок QML
  QQmlApplicationEngine engine;
  //Ссылка на главное окно в QML
  QObject *mainWindow;
  //Для работы с конфигурационными файлами
  QSettings *settings;
  //Таймер, для обновления страниц и так далее
  QTimer *timer;
  //Идентификатор юзера в сервере
  int ID;
  //Сколько дней прошло с Начальной даты(STARTDATE)
  int DATE;
  //IP адрес нашего сервера. Достану из конфиг файлов для тестирования
  QString IP;
  //Идентификатор временного промежутка
  int timeID;
  //Идентификаторы начального и конечного городов
  int townSource, townDestination;
  //Строковые переменные городов(начальной и конечной точек).
  QString townsSourceStr, townDestinationStr;
  //Количество свободных мест/забронированных мест
  int SEATS_BOOKED;
  //Идентификатор Направления. Определяется сервером
  int directionID;
  //Пассажир или Водитель
  QString HUMAN;
  //список городов
  QString townNames[100];
  //Стартовая дата, именно с этой даты будем считать, сколько дней прошло.
  QDate STARTDATE;

signals:

public slots:
    void slotregistrationInServer(QNetworkReply *);
    void slotGotTowns(QNetworkReply *reply);
    void slotGotTimeTable(QNetworkReply *reply);
    void slotGotDirection(QNetworkReply *reply);
    void slotStandToQueue(QNetworkReply *reply);
    void slotGetQueueInfo(QNetworkReply *reply);

    //Она нам нужна,чтобы таймер выполнял после таймаута.
    //Данная функция просто выполняет getStatus()
    void getQueueInfo(){getStatus();}

    void getTimeTableTimer(){getTimeTable();}

};

#endif // BACKEND_H
