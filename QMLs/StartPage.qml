import QtQuick 2.0
import QtQuick.Enterprise.Controls 1.2

Rectangle {
    anchors.fill: parent
    color: "lightgray"
    Text {
        id: welcome
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        anchors.topMargin: parent.height * 0.4
        text: "Попутчик"
        font.pixelSize: mainQML.fontPixelSize * 1.6
    }
    Text {
        rotation: -30
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: parent.width * 0.6
        anchors.topMargin: parent.height * 0.4
        font.pixelSize: mainQML.fontPixelSize * 1.5
        text: "mobile"
        color: "green"
    }
}
