import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2


Rectangle {
    anchors.fill: parent
    color: "white"
    /*
      TODO
      In this page user must see count of drivers and passengers, and make decision -
      to stand to queue or choose another segment of time
    */

    Text {
        objectName: "ChooseTime_title"
        anchors.top: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 5

        color: "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 14
    }

    Button {
        id: goTime
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        height: parent.height / 10
        width: parent.width / 2
        text: "Выбрать другое время"
        anchors.margins: height / 20
        onClicked: {
            loader.setSource("qrc:/QMLs/TimePage.qml")
            backEnd.getTimeTable();
            toolBarText.text = "Выберите время"
        }
    }
}
