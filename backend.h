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
private:
    QQmlApplicationEngine engine;
    QObject *mainWindow;
    int ID;
    QObject *helloButton;
    QObject *iDDD;
    QObject *waitingPageText;
    QObject *loader;
    QObject *TOWNS;
    QSettings *settings;
    QString IP;

signals:

public slots:
    void slotregistrationInServer(QNetworkReply *);
    void slotGotTowns(QNetworkReply *reply);
};

#endif // BACKEND_H
