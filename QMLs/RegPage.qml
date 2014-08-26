import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

Rectangle {
    anchors.fill: parent
    color: 'darkgrey'

    Button {
        //Водитель
        id: driverButton
        anchors.top: parent.top
        anchors.left: parent.left
        height: parent.height / 10
        width: parent.width * 0.4
        anchors.leftMargin: parent.width / 20
        anchors.topMargin: parent.height / 15
        Text {
            text: "Водитель"
            font.pixelSize: parent.height / 2
            anchors.centerIn: parent
        }
        onClicked: {
            driverButton.enabled = false
            passangerButton.enabled = true
        }
    }

    Button {
        //Пассажир
        id: passangerButton
        anchors.top: parent.top
        anchors.right: parent.right
        height: parent.height / 10
        width: parent.width * 0.4
        anchors.rightMargin: parent.width / 20
        anchors.topMargin: parent.height / 15
        Text {
            anchors.centerIn: parent
            text: "Пассажир"
            font.pixelSize: parent.height / 2
        }
        onClicked: {
            driverButton.enabled = true
            passangerButton.enabled = false
        }
    }

    ComboBox {
        id: sourceTown
        anchors.left: parent.left
        anchors.top: driverButton.bottom
        anchors.topMargin: parent.height / 15
        anchors.leftMargin: parent.width / 20
        height: parent.height / 10
        width: parent.width * 0.4
        model: ListModel {
            id: model
            ListElement { text: "Уфа" }
            ListElement { text: "Сибай" }
            ListElement { text: "Учалы" }
        }
        onAccepted: {
            if (editableCombo.find(currentText) === -1) {
                model.append({text: editText})
                currentIndex = editableCombo.find(editText)
            }
        }

    }

    ComboBox {
        id: destinationTown
        anchors.right: parent.right
        anchors.top: passangerButton.bottom
        anchors.topMargin: parent.height / 15
        anchors.rightMargin: parent.width / 20
        height: parent.height / 10
        width: parent.width * 0.4
        model: ListModel {
            id: model1
            ListElement { text: "Уфа" }
            ListElement { text: "Сибай" }
            ListElement { text: "Учалы" }
        }
        onAccepted: {
            if (editableCombo.find(currentText) === -1) {
                model1.append({text: editText})
                currentIndex = editableCombo.find(editText)
            }
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
        text: passangerButton.enabled ? "Сколько свободных мест" : "Сколько мест забронировать"
    }

    Button {
        id: goTable
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
            loader.setSource("qrc:/QMLs/TimePage.qml")
            toolBarText.text = "Выберите время"
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

    function setText(url) {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                mainText.text = doc.responseText;
            }
        }
        doc.open("post", url);
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send("human=driver&name=ILNUR&phone=000111");
    }
}
