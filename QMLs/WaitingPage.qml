import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

Rectangle {
    anchors.fill: parent
    color: "darkgrey"
    Text {
        anchors.centerIn: parent
        text: "Ожидание"
        objectName: "waitingPageText"
        font.pixelSize: parent.height / 15
    }
    Button {
        id: goPrev
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 20
        height: parent.height / 10
        //enabled: phoneNumber.text.length == 10 ? true : false

        Text {
            anchors.fill: parent
            text: "Назад"
            font.pixelSize: parent.height / 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            //loader.setSource("qrc:/QMLs/TimePage.qml")
            backEnd.waitingPageButton();
            toolBarText.text = "Выберите время"
        }
    }
}
