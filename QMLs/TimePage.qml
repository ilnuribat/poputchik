import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2


Rectangle {
    anchors.fill: parent
    id: timeMain
    color: 'darkgrey'
    Rectangle {
        id: chooseTimeSegmentTitle
        anchors.top:  parent.top
        height: parent.height / 10
        anchors.left: parent.left
        anchors.right: parent.right
        color: "lightblue"
        Text {
            //Время
            id: titleTime
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width * 0.6
            height: parent.height
            font.pixelSize: height / 2
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Время"
        }
        Image {
            id: carImage
            anchors.left: titleTime.right
            anchors.top: parent.top
            width: parent.height * 1.2
            height: parent.height
            source: "qrc:/image/images/car50.png"
        }
        Image {
            id: passagerImage
            anchors.right: parent.right
            width: parent.height * 1.2
            anchors.rightMargin: parent.height * 0.2
            anchors.top: parent.top
            height: parent.height
            horizontalAlignment: Image.AlignHCenter
            source: "qrc:/image/images/human.png"
        }
    }

    ListModel {
        id: timeModel
        objectName: "TimePageData"
        ListElement {

            passanger: "0"
            driver: "0"
            time: "00:00 - 03:00"
        }
        ListElement {
            passanger: "0"
            driver: "0"
            time: "03:00 - 06:00"
        }
        ListElement {
            passanger: "0"
            driver: "0"
            time: "06:00 - 09:00"
        }
        ListElement {
            passanger: "0"
            driver: "0"
            time: "09:00 - 12:00"
        }
        ListElement {
            passanger: "0"
            driver: "0"
            time: "12:00 - 15:00"
        }
        ListElement {
            passanger: "0"
            driver: "0"
            time: "15:00 - 18:00"
        }
        ListElement {
            passanger: "0"
            driver: "0"
            time: "18:00 - 21:00"
        }
        ListElement {
            passanger: "0"
            driver: "0"
            time: "21:00 - 24:00"
        }
    }

    ListView {
        anchors.top: chooseTimeSegmentTitle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: goToReg.top
        clip: true
        model: timeModel
        delegate: Rectangle {
            height: timeMain.height * 0.15
            width: timeMain.width
            anchors.rightMargin: width
            anchors.leftMargin: width
            color: "darkgray"
            Text {
                id: delegateTime
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.width * 0.6
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: time
                font.pixelSize: height * 0.3
            }
            Text {
                id: delegateDriver
                x: delegateTime.width
                anchors.top: parent.top
                width: parent.width * 0.1
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: driver
                font.pixelSize: height * 0.3
            }
            Text {
                id: delegatePassanger
                anchors.left: delegateDriver.right
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: passanger
                font.pixelSize: height * 0.3
            }
        }
        snapMode: ListView.SnapOneItem
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
            loader.setSource("qrc:/QMLs/WaitingPage.qml")
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
