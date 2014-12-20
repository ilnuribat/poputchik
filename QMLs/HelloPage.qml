import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

Rectangle {
    anchors.fill: parent
    id: helloPage
    color: 'darkgrey'
    Rectangle {
            //Название программы
            id: title

            color: parent.color
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: parent.height / 40
            height: parent.height / 15
            Text {
                anchors.fill: parent
                text: "Мы Вас не знаем..."
                font.pixelSize: height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
            }
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
                    regExp: /[а-яА-Яa-zA-Z]{10}/
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
        //Ваш номер
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
    Rectangle {
        //Пассажир
        id: passengerButton
        Text {
            anchors.centerIn: parent
            text: "Попутчик"
            font.pixelSize: parent.height / 2
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                driverButton.enabled = true
                passengerButton.enabled = false
            }
        }
        anchors.bottom: humanName.top
        anchors.left: parent.left
        height: parent.height / 10
        width: parent.width * 0.4
        anchors.leftMargin: parent.width / 20
        anchors.bottomMargin: parent.height / 10
        color: enabled ? parent.color : "white"

    }
    Rectangle {

        //Водитель
        id: driverButton
        Text {
            text: "Водитель"
            font.pixelSize: parent.height / 2
            anchors.centerIn: parent
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                driverButton.enabled = false
                passengerButton.enabled = true
            }
        }
        anchors.bottom: humanName.top
        anchors.right: parent.right
        height: parent.height / 10
        width: parent.width * 0.4
        anchors.rightMargin: parent.width / 20
        anchors.bottomMargin: parent.height / 10
        color: enabled ? parent.color : "white"

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
    Rectangle {
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
        MouseArea {
            anchors.fill: parent
            onClicked: {
                backEnd.registrationInServer(driverButton.enabled ? "passenger" : "driver",
                                                                    phoneNumber.text, humanName.text);
            }
        }
        function registrationSuccess() {
            loader.setSource("qrc:/QMLs/RegPage.qml");
            backEnd.getTowns();
            toolBarText.text = "Выберите направление";
        }
        function failRegistration() {
            toolBarText.text = "Какая-то ошибка"
        }
    }
}
