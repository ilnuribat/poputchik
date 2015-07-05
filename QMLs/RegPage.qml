import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Enterprise.Controls 1.2

Rectangle {
    id: globalParent
    objectName: "RegPage"
    anchors.fill: parent
    property int heightMargin: height * 0.042
    property int side_margin: parent.width * 0.05
    property string human: ""

    Text {
        anchors {
            left: parent.left
            right: sourceTown.left
            top: sourceTown.top
            bottom: sourceTown.bottom
            leftMargin: side_margin
        }

        text: "Откуда"
        font.pixelSize: height * 0.6
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    ComboBox {
        id: sourceTown
        objectName: "sourceTowns"
        anchors {
            right: parent.right
            top: parent.top
            topMargin: heightMargin
            rightMargin: side_margin
        }

        height: parent.height / 10
        width: parent.width * 0.55
        model: ListModel {}
        function append(newTown) {
            sourceTown.model.append(newTown);
        }
        function clearList() {
            //sourceTown.model.clear();
        }
        onCurrentIndexChanged: {
            if(sourceTown.model.count > 0)
                backEnd.setSourceTown(currentIndex + 1);
        }
    }

    Text {
        anchors {
            left: parent.left
            right: destinationTown.left
            top: destinationTown.top
            bottom:destinationTown.bottom
            leftMargin: side_margin
        }
        text: "Куда"
        font.pixelSize: height * 0.6
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    ComboBox {
        id: destinationTown
        objectName: "destinationTowns"
        anchors {
            right: parent.right
            top: sourceTown.bottom
            topMargin: heightMargin
            rightMargin: side_margin
        }
        width: parent.width * 0.55
        height: parent.height / 10

        
        model: ListModel {
        }

        function append(newTown) {
            destinationTown.model.append(newTown);
        }
        function clearList() {
            destinationTown.model.clear();
        }
        onCurrentIndexChanged: {
            if(destinationTown.model.count > 0)
                backEnd.setDestinationTown(currentIndex + 1);
        }
    }

    Text {
        id: titleDateChoose
        anchors {
            top: selectDate.top
            right: selectDate.left
            left: parent.left
            bottom: selectDate.bottom
            leftMargin: side_margin
        }
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: height * 0.6
        text: "Когда"
    }

    Rectangle {
        //Выбор даты
        id: selectDate
        anchors {
            right: parent.right
            top: destinationTown.bottom
            topMargin: heightMargin
            rightMargin: side_margin
        }
        height:parent.height / 10
        width: parent.width * 0.55
        radius: height / 4
        Text {
            id: selectDateText
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height * 0.6
            text: new Date().toLocaleDateString()
            fontSizeMode: Text.HorizontalFit
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                chosseDateDialog.open()
            }
        }
    }

    Dialog {
        id: chosseDateDialog
        title: "Выберите дату"
        Calendar {
            selectedDate : new Date()
            onClicked: {
                selectDateText.text = selectedDate.toLocaleDateString();
                backEnd.setDate(selectDate);
            }
        }
    }

    Rectangle {
        id: selectTime
        anchors {
            top: numberSeats.bottom
            right: parent.right
            topMargin: heightMargin
            rightMargin: side_margin
        }
        visible: human == "driver"
        width: parent.width * 0.55
        height: parent.height * 0.1
        Text {
            id: selectTimeText
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height / 2
            text: (new Date().toTimeString()).slice(0,5)
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                selectTimeDialog.open();
                timeSelectTubmler.onLoaded();
            }
        }
    }

    Dialog {
        id: selectTimeDialog
        title: "Выберите точное время"
        Tumbler {
            id: timeSelectTubmler

            TumblerColumn {
                id: hoursColumn
                model: ListModel {}
            }
            TumblerColumn {
                id: minutesColumn

                model: ListModel {}
            }
            function onLoaded() {
                for(var i = 0; i < 24; i ++)
                    hoursColumn.model.append({"value": i < 10 ? "0" + i : "" + i})
                for(var i = 0; i < 60; i ++)
                    minutesColumn.model.append({"value": i < 10 ? "0" + i : "" + i})
                timeSelectTubmler.setCurrentIndexAt(0, new Date().getHours());
                timeSelectTubmler.setCurrentIndexAt(1, new Date().getMinutes());
            }
        }
        onAccepted: {
            var hh = (hoursColumn.currentIndex < 10 ? "0" : "") + hoursColumn.currentIndex;
            var mm = (minutesColumn.currentIndex < 10 ? "0" : "") + minutesColumn.currentIndex;
            selectTimeText.text = hh + ":" + mm;
            backEnd.setExactTime(hh + ":" + mm);
        }
    }

    Text {
        id: titleSelectTime
        anchors {
            top: selectTime.top
            bottom: selectTime.bottom
            right: selectTime.left
            left: parent.left
            leftMargin: side_margin
            rightMargin: parent.width * 0.02
        }
        visible: human == "driver"
        font.pointSize: 72
        fontSizeMode: Text.HorizontalFit
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        text: "Точное время"
    }


    TextField {
        id: exactStreet
        anchors {
            left: parent.left
            right: parent.right
            top: selectTime.bottom
            topMargin: heightMargin
            rightMargin: side_margin
            leftMargin: side_margin
        }
        visible: human == "driver"
        height: parent.height / 10
        placeholderText: "Улица, дом в Уфе"
    }

    Button {
        id: goDriversList
        objectName: "goDriversList"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.02
        anchors.rightMargin: parent.width * 0.01
        anchors.leftMargin: parent.width * 0.01

        height: parent.height / 10
        text: qsTr("Далее")
        isDefault: false
        activeFocusOnPress: false
        onClicked: {
            backEnd.goDriversList
        }
    }




}
