import QtQuick 2.0

Rectangle {
    anchors.fill: parent
    color: "white"
    /*
      TODO
      In this page user must see count of drivers and passangers, and make decision -
      to stand to queue or choose another segment of time
    */

    Text {
        //anchors.top: parent.bottom
        //anchors.left: parent.left
        //anchors.right: parent.right
        //height: parent.height / 5
        anchors.fill: parent
        color: "black"
        text: "Вы выбрали время от ** до ** часов"
        font.pointSize: 14
    }
}
