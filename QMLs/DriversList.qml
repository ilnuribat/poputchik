import QtQuick 2.0
import QtQuick.Controls 1.2

Rectangle {
    id: rectangle1
    anchors.fill: parent

    Text {
        id: text1
        height: parent.height / 10
        text: qsTr("Список водителей")
        font.pixelSize: height * 0.6
        wrapMode: Text.NoWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
    }

    Button {
        id: goRegPage

        height: parent.height / 10
        text: qsTr("Button")
        clip: false
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }

    ListView {
        id: listOfDrivers

        spacing: 4
        cacheBuffer: 999
        maximumFlickVelocity: 1500
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: goRegPage.top
        anchors.top: text1.bottom
        delegate: Item {
            x: 5
            width: 80
            height: 40
            Row {
                id: row1
                Rectangle {
                    width: 40
                    height: 40
                    color: colorCode
                }

                Text {
                    text: name
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
                spacing: 10
            }
        }
        model: ListModel {
            ListElement {
                name: "Grey"
                colorCode: "grey"
            }

            ListElement {
                name: "Red"
                colorCode: "red"
            }

            ListElement {
                name: "Blue"
                colorCode: "blue"
            }

            ListElement {
                name: "Green"
                colorCode: "green"
            }
        }
    }

}
