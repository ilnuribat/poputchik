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
    //Регистрация
    Q_INVOKABLE void registrationInServer(QString HUMAN, QString phone, QString name);
    //Получить список городов
    Q_INVOKABLE void getSourceTowns();
    //Получить список городов прибытия и число людей
    Q_INVOKABLE void getDestTowns();
    //Назначить городом отправления
    Q_INVOKABLE void setSourceTown(int index);
    //Назначить городом пребытия
    Q_INVOKABLE void setDestinationTown(int index);
    //Установить количество мест забронированных\свободных
    Q_INVOKABLE void setSeatsBooked(int count);

    //Установить выбранную дату
    Q_INVOKABLE void setDate(QDate date);
    //"Логика" загрузки RegPage.
    Q_INVOKABLE void loadingRegPage();
    //"Логика" загрузки TimePage, со стороны RegPage.
    //Узнать, есть ли такое направление, если нет, то попросить выбрать другое направление.
    Q_INVOKABLE void goDriversList();
    //Убрать пассажира из очереди
    Q_INVOKABLE void loadedSignal(QString url);
    //Узнать код маршрута
    Q_INVOKABLE void getDirection();

    //установка точного времени
    Q_INVOKABLE void setExactTime(QString time);

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
    QDate DATE;
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
    QString townSourceNames[100];
    //Стартовая дата, именно с этой даты будем считать, сколько дней прошло.
    QDate STARTDATE;
    //Пример: '5 февраля'. Этот текст будет отображаться в TimePage.
    QString chosenDate;
    //часовой отрезок из БД
    QString timeName;
    //текущая страница в loader
    QString currentQML;
    //зашли в программу, попали в waiting page
    QString directionText;
    //Точное время
    QString TIME;

    //Загруженные страницы QML
    void loadedRegPage();
    void loadedHelloPage();

signals:

public slots:
    void slotregistrationInServer(QNetworkReply *);
    void slotGotSourceTowns(QNetworkReply *reply);
    void slotGotDestTowns(QNetworkReply *reply);
    void slotGotDirection(QNetworkReply *reply);
};

#endif // BACKEND_H
