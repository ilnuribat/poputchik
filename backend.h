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

private:
    QQmlApplicationEngine engine;
    QObject *mainWindow;
    QSettings *settings;
    void getDirection();
    QTimer *timer;
    int ID;
    int date;
    QString IP;
    int timeID;
    int townSource, townDestination;
    QString townsSourceStr, townDestinationStr;
    int SEATS_BOOKED;
    int directionID;
    QString HUMAN;
    QString townNames[100];

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
