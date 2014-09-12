import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import "QMLs"

ApplicationWindow {
    visible: true
    width: 480
    height: 800
    objectName: "mainWindow"

    ToolBar {
        id: toolBar
        x: 0
        y: 0
        width: parent.width
        height: parent.height / 10
        Text {
            id: toolBarText
            text: "Добро пожаловать!"
            anchors.fill: parent
            font.pixelSize: parent.height * 0.5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "darkblue"
        }
    }

    Loader {
        id: loader
        x: 0
        y: toolBar.y + toolBar.height
        height: parent.height - y
        width: parent.width
        focus: true
        source: "qrc:/QMLs/HelloPage.qml"
    }
}
