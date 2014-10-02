import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

Rectangle {
    anchors.fill: parent
    id: helloPage
    color: 'darkgrey'

    Text {
            //Название программы
            id: title
            text: "Найди попутчика"
            color: "white"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: parent.height / 10
            width: parent.width
            height: parent.height / 8
            font.pixelSize: height / 2
            horizontalAlignment: Text.AlignHCenter
    }

    TextField {
        //Ваше Имя
        id: humanName
        objectName: "NAME"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height / 10
        width: parent.width
        anchors.leftMargin: parent.width / 10
        anchors.rightMargin: parent.width / 10
        anchors.topMargin: parent.height / 2
        font.pixelSize: height / 2
        placeholderText: "Ваше имя"

        validator: RegExpValidator {
                    regExp: /[а-яА-Яa-zA-Z]{16}/
                }
        Keys.onPressed: {
                    if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                        Qt.inputMethod.hide()
                        loader.forceActiveFocus()
                        event.accepted = true
                    }
                }
    }

    TextField {
        //Ваше Имя
        id: phoneNumber
        objectName: "PHONE"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: humanName.bottom
        height: parent.height / 10
        width: parent.width
        anchors.leftMargin: parent.width / 10
        anchors.rightMargin: parent.width / 10
        anchors.topMargin: 10
        font.pixelSize: height / 2
        placeholderText: "Номер телефона"
        inputMethodHints: Qt.ImhPreferNumbers
        Keys.onPressed: {
                //Свернуть клавиатуру
                    if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                        Qt.inputMethod.hide()
                        loader.forceActiveFocus()
                        event.accepted = true
                    }
                }
    }

    Button {
        //Водитель
        id: driverButton
        anchors.top: title.bottom
        anchors.left: parent.left
        height: parent.height / 10
        width: parent.width * 0.4
        anchors.leftMargin: parent.width / 20
        anchors.topMargin: parent.height / 10
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
        anchors.top: title.bottom
        anchors.right: parent.right
        height: parent.height / 10
        width: parent.width * 0.4
        anchors.rightMargin: parent.width / 20
        anchors.topMargin: parent.height / 10
        Text {
            anchors.centerIn: parent
            text: "Попутчик"
            font.pixelSize: parent.height / 2
        }
        onClicked: {
            driverButton.enabled = true
            passangerButton.enabled = false
        }
    }

    Text {
        id: plus7
        anchors.top: phoneNumber.top
        anchors.right: phoneNumber.left
        anchors.rightMargin: 5
        height: parent.height / 10
        anchors.topMargin: height / 6
        font.pixelSize: height / 2
        text: "+7"
    }

    Button {
        id: goNext
        objectName: "helloButton"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 20
        height: parent.height / 10
        opacity: phoneNumber.text.length == 10 ? 1 : 0.8
        Text {
            anchors.fill: parent
            text: "Далее"
            font.pixelSize: parent.height / 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            backEnd.registrationInServer(driverButton.enabled ? "passanger" : "driver", phoneNumber.text, humanName.text);
            loader.setSource("qrc:/QMLs/RegPage.qml")
            backEnd.getTowns();
            toolBarText.text = "Выберите направление"
        }
    }
}
