import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Enterprise.Controls 1.3

Rectangle {
    anchors.fill: parent
    id: helloPage
    color: mainQML.fonCode
    Rectangle {
        //Название программы
        id: title
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: passengerButton.top
        }
        color: mainQML.fonCode
        Text {
            anchors.fill: parent
            text: "в сообщество попутчиков и водителей по Уфе!"
            font.pixelSize: parent.height * 0.1
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "black"
            wrapMode: Text.WordWrap
        }
    }
    TextField {
        //Ваше Имя
        id: humanName
        objectName: "NAME"
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: parent.width / 10
            rightMargin: parent.width / 10
            topMargin: parent.height / 2
        }
        height: parent.height / 10
        width: parent.width
        font.pixelSize: height / 2
        placeholderText: "Ваше имя"
        visible: plus7.visible
        validator: RegExpValidator {
                    regExp: /[а-яА-Яa-zA-Z]{10}/
                }
        layer.format: "RGB"
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
        anchors.leftMargin: parent.width * 0.15
        anchors.rightMargin: parent.width * 0.1
        anchors.topMargin: 10
        font.pixelSize: height / 2
        placeholderText: "Номер телефона"
        inputMethodHints: Qt.ImhPreferNumbers
        visible: plus7.visible
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
            text: "Пассажир"
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
        enabled: false
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
        enabled: true
        color: enabled ? parent.color : "white"

    }
    Text {
        id: plus7
        anchors.top: phoneNumber.top
        anchors.right: phoneNumber.left
        height: phoneNumber.height
        anchors.rightMargin: parent.width * 0.01
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: height / 2
        visible: !driverButton.enabled
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
        enabled: phoneNumber.text.length == 10 || !plus7.visible
        Text {
            anchors.fill: parent
            text: "Далее"
            font.pixelSize: parent.height / 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            if(plus7.visible)
                backEnd.registrationInServer(driverButton.enabled ? "passenger" : "driver",
                    "8" + phoneNumber.text, humanName.text);
            else backEnd.loadingRegPage()

        }

        function failRegistration(text) {
            toolBarText.text = text
        }
    }
}
