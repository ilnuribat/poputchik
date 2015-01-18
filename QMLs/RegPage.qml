import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Enterprise.Controls 1.2

Rectangle {
    anchors.fill: parent
    color: 'darkgrey'

    ComboBox {
        id: sourceTown
        objectName: "sourceTowns"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: parent.height / 15
        anchors.leftMargin: parent.width / 20
        height: parent.height / 10
        width: parent.width * 0.4
        model: ListModel {
        }
        function append(newTown)
        {
            sourceTown.model.append(newTown);
            destinationTown.model.append(newTown);
        }
        onCurrentIndexChanged: {
            backEnd.setSourceTown(currentIndex + 1);
        }
    }

    ComboBox {
        id: destinationTown
        objectName: "destinationTowns"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: parent.height / 15
        anchors.rightMargin: parent.width / 20
        height: parent.height / 10
        width: parent.width * 0.4
        model: ListModel {
        }
        onCurrentIndexChanged: {
            backEnd.setDestinationTown(currentIndex + 1);
        }
    }

    ComboBox {
        id: numberSeats
        anchors.right: parent.right
        anchors.top: destinationTown.bottom
        anchors.topMargin: parent.height / 15
        anchors.rightMargin: parent.width / 20
        width: parent.width / 4
        height: parent.height / 10
        model: ListModel {
            ListElement { text: "1" }
            ListElement { text: "2" }
            ListElement { text: "3" }
            ListElement { text: "4" }
            ListElement { text: "5" }
            ListElement { text: "6" }
            ListElement { text: "7" }
            ListElement { text: "8" }
        }
        onCurrentIndexChanged: {
            backEnd.setSeatsBooked(currentIndex + 1);
        }
    }

    Text {
        //Подпись для количества мест
        id: numberSeatsBooked
        anchors.top: sourceTown.bottom
        anchors.topMargin: parent.height / 20
        anchors.right: numberSeats.left
        anchors.rightMargin: parent.width / 40
        anchors.left: parent.left
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        height: parent.height / 10
        font.pixelSize: height / 2.5
        wrapMode: Text.WordWrap
        property int isDriver: 0
        text: isDriver == 0 ? "Сколько свободных мест" : "Сколько мест забронировать"
    }

    Rectangle{
        anchors.top: numberSeats.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: goTable.top
        color: parent.color

        Tumbler {
            id: tumblerDatePicker
            objectName: "tumblerDatePicker"
            anchors.centerIn: parent
            //День
            TumblerColumn {
                id: daysColumn
                //model: 11
                model: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
                onCurrentIndexChanged: {
                    console.log("current day: ", currentIndex)
                    backEnd.setDate(daysColumn.currentIndex + 1, monthsColumn.currentIndex + 1);
                }
            }

            //Месяц
            TumblerColumn {
                id: monthsColumn
                //model: 10
                model: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентярь", "Октярь", "Ноябрь", "Декабрь"]

                onCurrentIndexChanged: {
                    //console.log("index changed:", currentIndex)

                    if(currentIndex == 0 || currentIndex == 2 || currentIndex == 4 ||
                            currentIndex == 6 || currentIndex == 7 || currentIndex == 9 ||
                            currentIndex == 11)
                        daysColumn.model = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30, 31];
                    else
                    if (currentIndex == 1) daysColumn.model = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28];
                    else
                    daysColumn.model = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30];

                    //backEnd.setDate(daysColumn.currentIndex + 1, monthsColumn.currentIndex + 1);
                }

            }

            TumblerColumn {
                model: [2015]
            }
            function setDay(day) {
                console.log("called day!: ", day);
                tumblerDatePicker.setCurrentIndexAt(0, day - 1);
            }
            function setMonth(month) {
                console.log("called month!: ", month);
                tumblerDatePicker.setCurrentIndexAt(1, month - 1);
            }
        }

    }

    Button {
        id: goTable
        objectName: "goToTableButton"
        anchors.right: parent.right
        width: parent.width * 0.7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.02
        anchors.rightMargin: parent.width * 0.01

        height: parent.height / 10

        Text {
            anchors.fill: parent
            text: "Далее"
            font.pixelSize: parent.height / 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            backEnd.checkDirection();
            //Вот это нежданчик. Я вроде это не писал
            parent.enabled = false;
        }
        function failDirection() {
            parent.enabled = true;
            console.log("there is no such direction");
            toolBarText.text = "Выберите другой маршрут"
        }
        function goToTable() {
            backEnd.getTimeTable();
            loader.setSource("qrc:/QMLs/TimePage.qml");
            toolBarText.text = "Выберите время";
        }
    }

    Button {
        id: goToBack
        height: parent.height / 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.02
        anchors.rightMargin: parent.width * 0.01
        anchors.leftMargin: parent.width * 0.01
        anchors.right: goTable.left
        visible: false
        Text {
            anchors.centerIn: parent
            font.pixelSize: parent.height / 2
            text: "Назад"
        }
        onClicked: {
            loader.setSource("qrc:/QMLs/HelloPage.qml")
            toolBarText.text = "Добро пожаловать!"
        }
    }

}
