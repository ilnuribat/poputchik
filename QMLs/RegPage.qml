import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.1

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
            console.log(currentIndex + 1);
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
    Button {
        id: goTable
        objectName: "goToTableButton"
        anchors.right: parent.right
        width: parent.width * 0.7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        height: parent.height / 10
        //enabled: phoneNumber.text.length == 10 ? true : false
        Text {
            anchors.fill: parent
            text: "Далее"
            font.pixelSize: parent.height / 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            backEnd.checkDirection();
            parent.enabled = false;
        }
        function failDirection() {
            parent.enabled = true;
            console.log("there is no such direction");
            toolBarText.text = "Увы, пока таких маршрутов нет"
        }
        function goToTable() {
            console.log("go to Table from QML!")
            backEnd.getTimeTable();
            loader.setSource("qrc:/QMLs/TimePage.qml");
            toolBarText.text = "Выберите время";
        }
    }
    Button {
        id: goToBack
        height: parent.height / 10
        anchors.left: parent.left
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.right: goTable.left
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
