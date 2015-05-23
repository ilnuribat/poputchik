import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Enterprise.Controls 1.2

Rectangle {
    id: parentGlobal
    anchors.fill: parent
    color: "#C0C0C0"

    //В очереди, или нет
    Text {
        id: inQueue
        objectName: "inQueueText"
        anchors.top: parent.top
        anchors.left: parent.left
        height: parent.height / 20
        width: parent.width
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
        font.pixelSize: height * 0.75
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
        font.pixelSize: height * 0.75
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
        font.pixelSize: height
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    ListView {
        id: listNamePhone
        anchors.bottom: goTime.top
        anchors.top: drivePassTool.bottom
        anchors.topMargin: parent.height * 0.01
        anchors.left: parent.left
        anchors.right: parent.right
        objectName: "listHumans"
        model: ListModel{}
        delegate: Rectangle {
            id: listDelegate
            anchors.left: parent.left
            anchors.right: parent.right
            height: parentGlobal.height / 8
            color: parentGlobal.color
            //Надпись: Имя
            Rectangle {
                color: parent.color
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 10
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height / 2
                Text {
                    id: textOfName
                    anchors.fill: parent;
                    font.pixelSize: 0.8 * height
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: name
                }
            }
            //Надпись: Номер
            Rectangle {
                color: parent.color
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: parent.width / 10
                anchors.bottom: parent.bottom
                height: parent.height / 2
                Text {
                    id: textOfPhone
                    anchors.fill: parent;
                    font.pixelSize: parent.height
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: phone
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log(textOfName.text, "trying to make call", textOfName.text)
                    var flag = Qt.openUrlExternally("tel:%1".arg(textOfName.text));
                    console.log(flag, " - make call");
                }
            }
        }
        function append(newElement){
            listNamePhone.model.append(newElement)
        }
        function clearList()
        {
            listNamePhone.model.clear();
        }
    }

    Button {
        id: goTime
        anchors.bottom: parent.bottom
        height: parent.height / 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin:parent.width * 0.01
        anchors.bottomMargin: parent.height * 0.02
        anchors.rightMargin: parent.width * 0.01
        visible: inQueue.text != "Готово!"

        Text {
            anchors.fill: parent
            text: "Выбрать другое время"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height / 2
        }
        anchors.margins: height / 20
        onClicked: {
            console.log("goTimeTable clicked");
            loader.setSource("qrc:/QMLs/TimePage.qml")
            backEnd.getTimeTable();
            backEnd.removeFromQueue();
            toolBarText.text = "Выберите время"
        }
    }
    Button {
        id: exitButton
        anchors.fill: goTime
        visible: inQueue.text == "Готово!"
        Text {
            anchors.fill: parent
            text: "Выход"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height / 2
        }
        onClicked: {
            console.log("exitButton clicked");
            Qt.quit();
        }
    }
}

