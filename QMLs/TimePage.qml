import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Enterprise.Controls 1.2

Rectangle {
    anchors.fill: parent
    id: timeMain
    objectName: "timeTablePage"
    color: "#959595"
    Rectangle {
        //Показывает дату
        id: chooseTimeSegmentTitle
        objectName: "chooseTimeSegmentTitle"
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
            color: "black"
        }
    }

    Component {
        id: timeDelegate
        Rectangle {
            width: listOfTimes.cellWidth
            height: listOfTimes.cellHeight
            color: timeMain.color
            Rectangle {
                id: rectIN
                anchors.fill: parent
                anchors.margins: 10
                color: index != listOfTimes.highLightIndex ? "#AFAFAF" : "#CECECE"
                Text {//Текст сегмента времени
                    id: timeID
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height / 2
                    text: time
                    font.pixelSize: height * 0.8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Image {
                    id: driverICON
                    source: "qrc:/icons/images/pngFromGoogle/car/ic_directions_car_black_48dp.png"
                    anchors.top: timeID.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    width: height
                }
                Text {
                    id: driversID
                    anchors.top: timeID.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: driverICON.right
                    width: parent.width / 4
                    text: drivers
                    font.pointSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Image {
                    id: passengerICON
                    source: "qrc:/icons/images/pngFromGoogle/2Person/ic_people_black_48dp.png"
                    anchors.top: timeID.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: driversID.right
                    width: height
                }
                Text {
                    id: passengersID
                    anchors.top: timeID.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: passengerICON.right
                    anchors.right: parent.right
                    text: passengers
                    font.pointSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listOfTimes.highLightIndex = index
                    backEnd.setTimeQueue(index + 1);
                }
            }
        }
    }
    GridView {
        id: listOfTimes
        objectName: "timeGrid"
        property int highLightIndex: -1
        anchors.top: chooseTimeSegmentTitle.bottom
        anchors.bottom: goToReg.top
        width: parent.width
        cellWidth: width / 2
        cellHeight: height / 4
        clip: true
        model: ListModel {}
        delegate: timeDelegate
        function append(countOfPassengersDrivers) {
            listOfTimes.model.append(countOfPassengersDrivers);
        }
        function clearTimeTable()
        {
            listOfTimes.model.clear();
        }
    }
    Button {
        id: goToReg
        height: parent.height / 10
        anchors.left: parent.left
        anchors.right: goWaiting.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: parent.width * 0.01
        anchors.bottomMargin: parent.height * 0.02
        anchors.rightMargin: parent.width * 0.01
        Text {
            anchors.centerIn: parent
            font.pixelSize: parent.height / 2
            text: "Назад"
        }
        onClicked: {
            backEnd.loadingRegPage();
        }
    }
    Button {
        id: goWaiting
        anchors.right: parent.right
        width: parent.width * 0.7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.02
        anchors.rightMargin: parent.width * 0.01
        height: parent.height / 10
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
            backEnd.standToQueue();
            backEnd.getStatus();
        }
    }
}
