import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

Rectangle {
    anchors.fill: parent
    id: timeMain
    color: 'darkgrey'
    Rectangle {
        //Показывает дату
        id: chooseTimeSegmentTitle
        anchors.top:  parent.top
        height: parent.height / 10
        anchors.left: parent.left
        anchors.right: parent.right
        color: "lightgrey"
        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height * 0.5
            text: "25 октября, 2014г"
            color: "black"
        }
    }

    ListModel {
        id: timeModel
        objectName: "qTimesModel" //Queue model of time segments
        ListElement {
            time: "00:00"
            passengers: "01"
            drivers: "001"
        }
        ListElement {
            time: "03:00"
            passengers: "01"
            drivers: "001"
        }
        ListElement {
            time: "06:00"
            passengers: "01"
            drivers: "001"
        }
        ListElement {
            time: "09:00"
            passengers: "01"
            drivers: "001"
        }
        ListElement {
            time: "12:00"
            passengers: "01"
            drivers: "001"
        }
        ListElement {
            time: "15:00"
            passengers: "01"
            drivers: "001"
        }
        ListElement {
            time: "18:00"
            passengers: "01"
            drivers: "001"
        }
        ListElement {
            time: "22:00"
            passengers: "01"
            drivers: "001"
        }
    }

    Component {
        id: timeDelegate
        Rectangle {
            width: listOfTimes.cellWidth
            height: listOfTimes.cellHeight
            color: "darkgray"
            Rectangle {
                id: rectIN
                anchors.fill: parent
                anchors.margins: 10
                color: "lightgray"
                Text {
                    id: timeID
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height / 2
                    text: time
                    font.pointSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: driversID
                    anchors.top: timeID.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    width: parent.width / 2
                    text: drivers
                    font.pointSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: passengersID
                    anchors.top: timeID.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: driversID.right
                    anchors.right: parent.right
                    text: passengers
                    font.pointSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: backEnd.setTimeQueue(index);
            }
        }
    }

    GridView {
        id: listOfTimes
        anchors.top: chooseTimeSegmentTitle.bottom
        anchors.bottom: goToReg.top
        width: parent.width

        cellWidth: width / 2
        cellHeight: height / 4
        clip: true
        model: timeModel
        delegate: timeDelegate
    }

    Button {
        id: goWaiting
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
            loader.setSource("qrc:/QMLs/ChosenTime.qml")
            toolBarText.text = "Ожидание"
        }
    }
    Button {
        id: goToReg
        height: parent.height / 10
        anchors.left: parent.left
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height / 30
        anchors.right: goWaiting.left
        Text {
            anchors.centerIn: parent
            font.pixelSize: parent.height / 2
            text: "Назад"
        }
        onClicked: {
            loader.setSource("qrc:/QMLs/RegPage.qml")
            backEnd.getTowns()
            toolBarText.text = "Выберите направление"
        }
    }
}
