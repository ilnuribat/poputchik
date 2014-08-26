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
            visible: true
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
                    if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                        Qt.inputMethod.hide()
                        loader.forceActiveFocus()
                        event.accepted = true
                    }
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
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 20
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
            requestPOST("http://192.168.1.168:8080/registration", "human=driver&name=ILNUR&phone=000111")
            requestGET("http://192.168.1.168:8080/towns")
            loader.setSource("qrc:/QMLs/RegPage.qml")
            toolBarText.text = "Выберите направление"
        }
    }

    function requestGET(url) {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                console.log("townsGet:", doc.responseText)
            }
        }
        doc.open("get", url);
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send();
    }

    function requestPOST(url, post) {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                console.log("registrated!:", doc.responseText)
            }
        }
        doc.open("post", url);
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send(post);
    }
}
