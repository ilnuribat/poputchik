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
        objectName: "TimePageData"
        ListElement {
            time: "00:00"
        }
        ListElement {
            time: "03:00"
        }
        ListElement {
            time: "06:00"
        }
        ListElement {

            time: "09:00"
        }
        ListElement {
            time: "12:00"
        }
        ListElement {
            time: "15:00"
        }
        ListElement {
            time: "18:00"
        }
        ListElement {
            time: "21:00"
        }
    }

    GridView {
        id: listOfTimes
        anchors.top: chooseTimeSegmentTitle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: goToReg.top
        clip: true
        model: timeModel
        delegate: Rectangle {
            id: timesDelegate
            height: timeMain.height * 0.15
            width: timeMain.width
            anchors.rightMargin: width
            anchors.leftMargin: width
            color: "darkgray"
            Text {
                id: delegateTime
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.width * 0.2
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "time"
                font.pixelSize: height * 0.3
            }
            //TODO to be able to change properties of other list elements
            MouseArea {
                id: timeChoosen
                anchors.fill: parent
                onClicked: {
                    backEnd.standToQueue(index);
                    changeColor();
                    timesDelegate.color = "lightgreen";
                }
            }
            function changeColor(){
                console.log("function of changing Color of other list elements")
            }
        }
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
        anchors.bottomMargin: 20
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
