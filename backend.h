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
    //Встать в очередь
    Q_INVOKABLE void standToQueue();
    //Получить ячейку, куда нажали. Страница TimePage.qml
    Q_INVOKABLE void setTimeQueue(int x, QString timeName);
    //Получить состояние очереди на определенную дату и направление
    Q_INVOKABLE void getTimeTable();
    //Назначить городом отправления
    Q_INVOKABLE void setSourceTown(int index);
    //Назначить городом пребытия
    Q_INVOKABLE void setDestinationTown(int index);
    //Установить количество мест забронированных\свободных
    Q_INVOKABLE void setSeatsBooked(int count);
    //После того, как встал в очередь, нужно узнать, есть ли водитель\пассажир
    Q_INVOKABLE void getStatus();
    //Установить выбранную дату
    Q_INVOKABLE void setDate(int day, int month);
    //"Логика" загрузки RegPage.
    Q_INVOKABLE void loadувRegPage();
    //"Логика" загрузки TimePage, со стороны RegPage.
    //Узнать, есть ли такое направление, если нет, то попросить выбрать другое направление.
    Q_INVOKABLE void goTimeTable();
    //Убрать пассажира из очереди
    Q_INVOKABLE void removeFromQueue();
    //handle the signal from Loader
    Q_INVOKABLE void LoaderLoaded();

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
  QString townSourceNames[100];
  //Стартовая дата, именно с этой даты будем считать, сколько дней прошло.
  QDate STARTDATE;
  //Пример: '5 февраля'. Этот текст будет отображаться в TimePage.
  QString chosenDate;
  //часовой отрезок из БД
  QString timeName;
  //текущая страница в loader
  QString currentQML;

  //Загруженные страницы QML
  void loadedRegPage();
  void loadedHelloPage();
  void loadedTimePage();
  void loadedWaitingPage();

signals:

public slots:
    void slotregistrationInServer(QNetworkReply *);
    void slotGotSourceTowns(QNetworkReply *reply);
    void slotGotDestTowns(QNetworkReply *reply);
    void slotGotTimeTable(QNetworkReply *reply);
    void slotGotDirection(QNetworkReply *reply);
    void slotStandToQueue(QNetworkReply *reply);
    void slotGetQueueInfo(QNetworkReply *reply);
    void slotDropFromQueue(QNetworkReply *reply);

    //Она нам нужна,чтобы таймер выполнял после таймаута.
    //Данная функция просто выполняет getStatus()
    void getQueueInfo(){getStatus();}

    void getTimeTableTimer(){getTimeTable();}

};

#endif // BACKEND_H
