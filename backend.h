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

class BackEnd : public QQuickItem
{
    Q_OBJECT
public:
    explicit BackEnd(QQuickItem *parent = 0);

    Q_INVOKABLE void registrationInServer(QString HUMAN, QString phone, QString name);
    Q_INVOKABLE void waitingPageButton();
    Q_INVOKABLE void getTowns();
    Q_INVOKABLE void standToQueue(int TIME);
    Q_INVOKABLE void setDestinationTown(int index);
    Q_INVOKABLE void setTimeQueue(int x);
    Q_INVOKABLE void ChooseTimeLoaded();
    Q_INVOKABLE void getTimeTable();

private:
    QQmlApplicationEngine engine;
    QObject *mainWindow;
/*
    QObject *helloButton;
    QObject *iDDD;
    QObject *waitingPageText;
    QObject *loader;
    QObject *TOWNS;
*/
    QSettings *settings;

    int ID;
    QString IP;
    int timeID;
    QString townSource, townDestination;
    int SEATS, BOOKED;
    QString HUMAN;
signals:

public slots:
    void slotregistrationInServer(QNetworkReply *);
    void slotGotTowns(QNetworkReply *reply);
    void slotGotTimeTable(QNetworkReply *reply);
};

#endif // BACKEND_H
