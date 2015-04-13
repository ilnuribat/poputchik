import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Enterprise.Controls 1.3
import "QMLs"


ApplicationWindow {
    visible: true
    width: 300
    height: 500
    objectName: "mainQML"
    id: mainQML
    property int fontPixelSize: height / 30
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
            font.pixelSize: parent.height * 0.4
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "darkblue"
        }
    }

    Loader {
        id: loader
        objectName: "loader"
        visible: status == Loader.Ready
        x: 0
        y: toolBar.y + toolBar.height
        height: parent.height - y
        width: parent.width
        property string registered
        property bool loadig: true
        focus: true
        source: "qrc:/QMLs/StartPage.qml"

        function setQML(QML)
        {
            loader.setSource(QML);
        }

        onLoaded: {
            console.log("new qml page loaded", loader.source);
        }
        onStatusChanged: console.log("status", status,  "item", item)

        Rectangle {
            id: loadingAnimation
            color: "lightgreen"
            opacity: 0.5
            anchors.fill: parent
            visible: true
            Text {
                anchors.centerIn: parent
                font.pixelSize: 20
                text: "Загрузка"
            }
        }

    }
}

/*
  !0(ked_entr@n(e
*/
