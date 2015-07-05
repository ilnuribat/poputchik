import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Window 2.0
import QtQuick.Enterprise.Controls 1.3
import QtQuick.Dialogs 1.2
import "QMLs"


ApplicationWindow {
    visible: true
    width: 300
    height: 500
    objectName: "mainQML"
    id: mainQML
    property int fontPixelSize: (25.4 / 72) * Screen.pixelDensity
    property string human: ""
    property color fonCode: "#d2c444"
    Rectangle {
        id: toolBar
        x: 0
        y: 0
        width: parent.width
        height: parent.height / 10
        color: "#e6d42b"
        //800 / 5 = 160
        //800 / 480 = 5 / 3;
        Text {
            id: toolBarText
            objectName: "toolBarText"
            text: "Добро пожаловать!"
            anchors.rightMargin: parent.width * 0.1
            anchors.leftMargin: parent.width * 0.1
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "darkblue"
            font.pointSize: 72
            fontSizeMode: Text.HorizontalFit
        }
    }

    MessageDialog {
        id: sayToAuthor
        objectName: "sayToAuthor"
        title: "Сервер не отвечает"
        text: "Сообщить об этом разработчику(Ильнур)"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes:
            Qt.openUrlExternally("tel:%1".arg("+79874774911"))
        onNo:
            sayToAuthor.close()
        function callOpen() {
            sayToAuthor.open();
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

        function setQML(QML)
        {
            console.log("setting ", QML)
            console.log('start time: ', new Date().getTime() % 10000)
            loader.setSource(QML);
        }

        onLoaded: {
            console.log('finish time:', new Date().getTime() % 10000)
            backEnd.loadedSignal(loader.source);
        }
    }
}

/*
  !0(ked_entr@n(e
*/
