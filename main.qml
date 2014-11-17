import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import "QMLs"


ApplicationWindow {
    visible: true
    width: 480
    height: 800
    objectName: "mainQML"
    /*
      TODO
      loader!
      make animation of loader
    */
    //TODO using HTTPS

    ToolBar {
        id: toolBar
        x: 0
        y: 0
        width: parent.width
        height: parent.height / 10
        //800 / 5 = 160
        //800 / 480 = 5 / 3;
        Text {
            id: toolBarText
            objectName: "toolBarText"
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
        objectName: "loader"
        x: 0
        y: toolBar.y + toolBar.height
        height: parent.height - y
        width: parent.width
        property string registered
        focus: true
        source: registered == "true" ? "qrc:/QMLs/RegPage.qml" : "qrc:/QMLs/HelloPage.qml"
    }
}

/*
  !0(ked_entr@n(e
*/
