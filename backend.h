#ifndef BACKEND_H
#define BACKEND_H

#include <QQuickItem>
#include <QQmlApplicationEngine>
#include <QNetworkAccessManager>
#include <QtQuick>

class BackEnd : public QQuickItem
{
    Q_OBJECT
public:
    explicit BackEnd(QQuickItem *parent = 0);

    Q_INVOKABLE void registrationInServer(QString HUMAN, QString phone, QString name);
    Q_INVOKABLE void waitingPageButton();
private:
    QQmlApplicationEngine engine;
    QObject *mainWindow;
    int ID;
    QObject *helloButton;
    QObject *iDDD;\
    QObject *waitingPageText;

signals:

public slots:
    void slotregistrationInServer(QNetworkReply *);
};

#endif // BACKEND_H
