
import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2


Rectangle {
    anchors.fill: parent
    color: "#C0C0C0"

    //В очереди, или нет
    Text {
        id: inQueue
        anchors.top: parent.top
        anchors.left: parent.left
        height: parent.height / 20
        width: parent.width
        text: "В очереди"
        font.pixelSize: height
        style: Text.Sunken
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    //Надпись направление
    Text {
        id: directionToolText
        anchors.top: inQueue.bottom
        anchors.left: parent.left
        anchors.topMargin: parent.height / 40
        anchors.leftMargin: parent.width / 20
        anchors.right: parent.right
        height: parent.height / 20
        text: "Направление:"
        font.pixelSize: height
        style: Text.Sunken
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    //Типо: Уфа-Сибай
    Text {
        id: directionText
        objectName: "directionText"
        anchors.top: directionToolText.bottom
        anchors.left: parent.left
        height: parent.height / 15
        anchors.right: parent.right
        text: "Уфа - Сибай"
        font.pixelSize: 3 * height / 4
        style: Text.Outline;
        styleColor: "lightgreen"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    //надпись "Время"
    Text {
        id: timeToolText
        objectName: "timeToolText"
        anchors.top: directionText.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        height: parent.height / 20
        anchors.right: parent.right
        text: "Время"
        font.pixelSize: height
        style: Text.Sunken
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    //Надпись 15:00-18:00
    Text {
        id: timeText
        objectName: "timeText"
        anchors.top: timeToolText.bottom
        anchors.left: parent.left
        height: parent.height / 15
        anchors.right: parent.right
        text: "15:00-18:00"
        font.pixelSize: 3 * height / 4
        style: Text.Outline;
        styleColor: "lightgreen"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    //надпись Водитель\Пассажиры:
    Text {
        id: drivePassTool
        objectName: "drivePassTool"
        anchors.top: timeText.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        height: parent.height / 20
        anchors.right: parent.right
        text: "Водитель:"
        font.pixelSize: height
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    Component {

    }

    ListView {
        anchors.top: drivePassTool.bottom
        anchors.bottom: goTime.top
        anchors.left: parent.left
        anchors.right: parent.right
        model{}
        delegate:{}
    }

    Button {
        id: goTime
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        height: parent.height / 10
        width: parent.width * 0.7
        Text {
            anchors.fill: parent
            text: "другое время"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height / 2
        }
        anchors.margins: height / 20
        onClicked: {
            loader.setSource("qrc:/QMLs/TimePage.qml")
            backEnd.getTimeTable();
            toolBarText.text = "Выберите время"
        }
    }
}
