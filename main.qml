import QtQuick 2.15
import CustomControls 1.0
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import "./"
ApplicationWindow {
    width: 800
    height: 480
    visible: true
    title: qsTr("Car DashBoard")
    color: "#1E1E1E"
    visibility: "Windowed"
    property int nextSpeed: 60
    property int batteryLevel: 50

    function generateRandom(maxLimit = 70){
        let rand = Math.random() * maxLimit;
        rand = Math.floor(rand);
        return rand;
    }

    function speedColor(value){
        if(value < 60 ){
            return "green"
        } else if(value > 60 && value < 150){
            return "yellow"
        }else{
            return "Red"
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered:{

            currentTime.text = Qt.formatDateTime(new Date(), "hh:mm")
        }
    }

    Timer{
        repeat: true
        interval: 3000
        running: true
        onTriggered: {
            nextSpeed = generateRandom()
        }
    }

    Shortcut {
        sequence: "Ctrl+Q"
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }


    Image {
        id: dashboard
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        source: "qrc:/assets/Dashboard.svg"


         // Top Bar Of Screen


        Image {
            id: topBar
            width: 548.28
            height : 100
            source: "qrc:/assets/Vector 70.svg"

            anchors{
                top: parent.top
                topMargin: 13.25
                horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: headLight
                property bool indicator: false
                width: 17.17
                height: 19.125
                anchors{
                    top: parent.top
                    topMargin: 12.5
                    leftMargin: 92.93
                    left: parent.left
                }
                source: indicator ? "qrc:/assets/Low beam headlights.svg" : "qrc:/assets/Low_beam_headlights_white.svg"
                Behavior on indicator { NumberAnimation { duration: 300 }}
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        headLight.indicator = !headLight.indicator
                    }
                }
            }

            Label{
                id: currentTime
                text: Qt.formatDateTime(new Date(), "hh:mm")
                font.pixelSize: 16
                font.family: "Inter"
                font.bold: Font.DemiBold
                color: "#FFFFFF"
                anchors.top: parent.top
                anchors.topMargin: 12.5
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label{
                id: currentDate
                text: Qt.formatDateTime(new Date(), "dd/MM/yyyy")
                font.pixelSize: 16
                font.family: "Inter"
                font.bold: Font.DemiBold
                color: "#FFFFFF"
                anchors.right: parent.right
                anchors.rightMargin: 92.93
                anchors.top: parent.top
                anchors.topMargin: 12.5
            }
        }



        /*
          Speed Label
        */

        //        Label{
        //            id:speedLabel
        //            text: "68"
        //            font.pixelSize: 134
        //            font.family: "Inter"
        //            color: "#01E6DE"
        //            font.bold: Font.DemiBold
        //            anchors.top: parent.top
        //            anchors.topMargin:Math.floor(parent.height * 0.35)
        //            anchors.horizontalCenter: parent.horizontalCenter
        //        }

        //Speedometer display
        Gauge {
            id: speedLabel
            width: 320
            height: 320
            property bool accelerating
            value: accelerating ? maximumValue : 0
            maximumValue: 250

            anchors.top: parent.top
            anchors.topMargin:Math.floor(parent.height * 0.1)
            anchors.horizontalCenter: parent.horizontalCenter

            Component.onCompleted: forceActiveFocus()

            Behavior on value { NumberAnimation { duration: 1000 }}


            //set action to keyboard key
            Keys.onReleased: {
                if (event.key === Qt.Key_Space) {
                    accelerating = false;
                    event.accepted = true;
                }else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    radialBar.accelerating = false;
                    event.accepted = true;
                }
            }
            Keys.onSpacePressed: accelerating = true
            Keys.onEnterPressed: radialBar.accelerating = true
            Keys.onReturnPressed: radialBar.accelerating = true
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Up)
                batteryLevel = Math.min(100, batteryLevel + 10)
            else if (event.key === Qt.Key_Down)
                batteryLevel = Math.max(0, batteryLevel - 10)
        }

        //        Label{
        //            text: "MPH"
        //            font.pixelSize: 46
        //            font.family: "Inter"
        //            color: "#01E6DE"
        //            font.bold: Font.Normal
        //            anchors.top:speedLabel.bottom
        //            anchors.horizontalCenter: parent.horizontalCenter
        //        }



        //Middle Speed Limit Label
        Rectangle{
            id:speedLimit
            width: 40
            height: 40
            radius: height/2
            color: "#D9D9D9"
            border.color: speedColor(maxSpeedlabel.text)
            border.width: 5

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12.5

            Label{
                id:maxSpeedlabel
                text: getRandomInt(150, speedLabel.maximumValue).toFixed(0)
                font.pixelSize: 15
                font.family: "Inter"
                font.bold: Font.Bold
                color: "#01E6DE"
                anchors.centerIn: parent

                function getRandomInt(min, max) {
                    return Math.floor(Math.random() * (max - min + 1)) + min;
                }
            }
        }
        //Car icon shadow
        Image {
            id:shadowcar
            width : 50
            height : 50
            anchors{
                bottom: car.top
                bottomMargin: 15
                horizontalCenter:car.horizontalCenter
            }
            source: "qrc:/assets/Model 3.png"
        }

        //Car Icon
        Image {
            id:car
            width : 80
            height : 80
            anchors{
                bottom: speedLimit.top
                bottomMargin: 15
                horizontalCenter:speedLimit.horizontalCenter
            }
            source: "qrc:/assets/Car.svg"
        }

        // IMGonline.com.ua  ==> Compress Image With



        //Leftside Road
        Image {
            id: leftRoad
            width: 51.31
            height: 198.5
            anchors{
                left: speedLimit.left
                leftMargin: 40.40
                bottom: parent.bottom
                bottomMargin: 13.25
            }

            source: "qrc:/assets/Vector 2.svg"
        }


        //Rightside Road
        Image {
            id: rightRoad
            width: 51.31
            height: 198.5
            anchors{
                right: speedLimit.right
                rightMargin: 40.40
                bottom: parent.bottom
                bottomMargin: 13.25
            }

            source: "qrc:/assets/Vector 1.svg"
        }


        //Temp display in C
        RowLayout{
            spacing: 10

            anchors{
                left: parent.left
                leftMargin: 101.01
                bottom: parent.bottom
                bottomMargin: 13.25 + 32.5
            }

            RowLayout{
                spacing: 1.5
                Label{
                    text: "20"
                    font.pixelSize: 16
                    font.family: "Inter"
                    font.bold: Font.Normal
                    font.capitalization: Font.AllUppercase
                    color: "#FFFFFF"
                }

                Label{
                    text: "°C"
                    font.pixelSize: 16
                    font.family: "Inter"
                    font.bold: Font.Normal
                    font.capitalization: Font.AllUppercase
                    opacity: 0.2
                    color: "#FFFFFF"
                }
            }

            RowLayout{
                spacing: 1
                Layout.topMargin: 10
                Rectangle{
                    width: 8
                    height: 7.5
                    color: speedLabel.value.toFixed(0) > 31.25 ? speedLabel.speedColor : "#01E6DC"
                }
                Rectangle{
                    width: 8
                    height: 7.5
                    color: speedLabel.value.toFixed(0) > 62.5 ? speedLabel.speedColor : "#01E6DC"
                }
                Rectangle{
                    width: 8
                    height: 7.5
                    color: speedLabel.value.toFixed(0) > 93.75 ? speedLabel.speedColor : "#01E6DC"
                }
                Rectangle{
                    width: 8
                    height: 7.5
                    color: speedLabel.value.toFixed(0) > 125.25 ? speedLabel.speedColor : "#01E6DC"
                }
                Rectangle{
                    width: 8
                    height: 7.5
                    color: speedLabel.value.toFixed(0) > 156.5 ? speedLabel.speedColor : "#01E6DC"
                }
                Rectangle{
                    width: 8
                    height: 7.5
                    color: speedLabel.value.toFixed(0) > 187.75 ? speedLabel.speedColor : "#01E6DC"
                }
                Rectangle{
                    width: 8
                    height: 7.5
                    color: speedLabel.value.toFixed(0) > 219 ? speedLabel.speedColor : "#01E6DC"
                }
            }

            Label{
                text: speedLabel.value.toFixed(0) + " RPM "
                font.pixelSize: 16
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase
                color: "#FFFFFF"
            }
        }




          //Right Side Gear display


        RowLayout{
            spacing: 10
            anchors{
                right: parent.right
                rightMargin: 141.41
                bottom: parent.bottom
                bottomMargin: 13.25 + 32.5
            }

            Label{
                text: "Ready"
                font.pixelSize: 16
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase
                color: "#32D74B"
            }

            Label{
                text: "P"
                font.pixelSize: 16
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase
                color: "#FFFFFF"
            }

            Label{
                text: "R"
                font.pixelSize: 16
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase
                opacity: 0.2
                color: "#FFFFFF"
            }
            Label{
                text: "N"
                font.pixelSize: 16
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase
                opacity: 0.2
                color: "#FFFFFF"
            }
            Label{
                text: "D"
                font.pixelSize: 16
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase
                opacity: 0.2
                color: "#FFFFFF"
            }
        }

        //Left Side Icons
        Image {
            id:forthLeftIndicator
            property bool parkingLightOn: true
            width: 29.1
            height: 31
            anchors{
                left: parent.left
                leftMargin: 70.7
                bottom: thirdLeftIndicator.top
                bottomMargin: 12.5
            }
            Behavior on parkingLightOn { NumberAnimation { duration: 300 }}
            source: parkingLightOn ? "qrc:/assets/Parking lights.svg" : "qrc:/assets/Parking_lights_white.svg"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    forthLeftIndicator.parkingLightOn = !forthLeftIndicator.parkingLightOn
                }
            }
        }

        Image {
            id:thirdLeftIndicator
            property bool lightOn: true
            width: 21.01
            height: 35.1
            anchors{
                left: parent.left
                leftMargin: 58.59
                bottom: secondLeftIndicator.top
                bottomMargin: 12.5
            }
            source: lightOn ? "qrc:/assets/Lights.svg" : "qrc:/assets/Light_White.svg"
            Behavior on lightOn { NumberAnimation { duration: 300 }}
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    thirdLeftIndicator.lightOn = !thirdLeftIndicator.lightOn
                }
            }
        }

        Image {
            id:secondLeftIndicator
            property bool headLightOn: true
            width: 25.5
            height: 25.5
            anchors{
                left: parent.left
                leftMargin: 50.51
                bottom: firstLeftIndicator.top
                bottomMargin: 15
            }
            Behavior on headLightOn { NumberAnimation { duration: 300 }}
            source:headLightOn ?  "qrc:/assets/Low beam headlights.svg" : "qrc:/assets/Low_beam_headlights_white.svg"

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    secondLeftIndicator.headLightOn = !secondLeftIndicator.headLightOn
                }
            }
        }

        Image {
            id:firstLeftIndicator
            property bool rareLightOn: false
            width: 25.5
            height: 25.5
            anchors{
                left: parent.left
                leftMargin: 40.4
                verticalCenter: speedLabel.verticalCenter
            }
            source: rareLightOn ? "qrc:/assets/Rare_fog_lights_red.svg" : "qrc:/assets/Rare fog lights.svg"
            Behavior on rareLightOn { NumberAnimation { duration: 300 }}
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    firstLeftIndicator.rareLightOn = !firstLeftIndicator.rareLightOn
                }
            }
        }

        //Right Side Icons

        Image {
            id:forthRightIndicator
            property bool indicator: true
            width: 22.96
            height: 18.085
            anchors{
                right: parent.right
                rightMargin: 78.79
                bottom: thirdRightIndicator.top
                bottomMargin: 25
            }
            source: indicator ? "qrc:/assets/FourthRightIcon.svg" : "qrc:/assets/FourthRightIcon_red.svg"
            Behavior on indicator { NumberAnimation { duration: 300 }}
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    forthRightIndicator.indicator = !forthRightIndicator.indicator
                }
            }
        }

        Image {
            id:thirdRightIndicator
            property bool indicator: true
            width: 22.96
            height: 18.085
            anchors{
                right: parent.right
                rightMargin: 62.63
                bottom: secondRightIndicator.top
                bottomMargin: 25
            }
            source: indicator ? "qrc:/assets/thirdRightIcon.svg" : "qrc:/assets/thirdRightIcon_red.svg"
            Behavior on indicator { NumberAnimation { duration: 300 }}
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    thirdRightIndicator.indicator = !thirdRightIndicator.indicator
                }
            }
        }

        Image {
            id:secondRightIndicator
            property bool indicator: true
            width: 22.96
            height: 18.085
            anchors{
                right: parent.right
                rightMargin: 50.51
                bottom: firstRightIndicator.top
                bottomMargin: 25
            }
            source: indicator ? "qrc:/assets/SecondRightIcon.svg" : "qrc:/assets/SecondRightIcon_red.svg"
            Behavior on indicator { NumberAnimation { duration: 300 }}
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    secondRightIndicator.indicator = !secondRightIndicator.indicator
                }
            }
        }

        Image {
            id:firstRightIndicator
            property bool sheetBelt: true
            width: 14.55
            height: 22.5
            anchors{
                right: parent.right
                rightMargin: 40.40
                verticalCenter: speedLabel.verticalCenter
            }
            source: sheetBelt ? "qrc:/assets/FirstRightIcon.svg" : "qrc:/assets/FirstRightIcon_grey.svg"
            Behavior on sheetBelt { NumberAnimation { duration: 300 }}
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    firstRightIndicator.sheetBelt = !firstRightIndicator.sheetBelt
                }
            }
        }

        // Brake display
        RadialBar {
            id:radialBar
            anchors{
                //verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: parent.width / 10
                bottom : parent.bottom
                bottomMargin: 80
            }

            width: 169
            height: 169
            penStyle: Qt.RoundCap
            dialType: RadialBar.FullDial
            progressColor: "#01E4E0"
            backgroundColor: "transparent"
            dialWidth: 14
            startAngle: 270
            spanAngle: 3.6 * value
            minValue: 0
            maxValue: 100
            value: accelerating ? maxValue : 0
            textFont {
                family: "inter"
                italic: false
                bold: Font.Medium
                pixelSize: 30
            }
            showText: false
            suffixText: ""
            textColor: "#FFFFFF"

            property bool accelerating
            Behavior on value { NumberAnimation { duration: 1000 }}

            ColumnLayout{
                anchors.centerIn: parent
                Label{
                    text: radialBar.value.toFixed(0) + "%"
                    font.pixelSize: 20
                    font.family: "Inter"
                    font.bold: Font.Normal
                    color: "#FFFFFF"
                    Layout.alignment: Qt.AlignHCenter
                }

                Label{
                    text: "BRAKE"
                    font.pixelSize: 16
                    font.family: "Inter"
                    font.bold: Font.Normal
                    opacity: 0.8
                    color: "#FFFFFF"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
        //Icon
        ColumnLayout{
            spacing: 20

            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: parent.width / 8
            }

            RowLayout{
                spacing: 15

                 Image {

                     Layout.preferredWidth:  30
                     Layout.preferredHeight : 30
                     source: "qrc:/assets/road.svg"
                 }


                ColumnLayout{
                    Label{
                        text: "188 KM"
                        font.pixelSize: 15
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                    Label{
                        text: "Distance"
                        font.pixelSize: 10
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                }
            }
            RowLayout{

                spacing: 15
                /*Image {
                    Layout.preferredWidth: 30
                    Layout.preferredHeight:   30
                    source: "qrc:/assets/fuel.svg"
                }*/

                Battery {
                    id:batteryLv
                    level : batteryLevel
                    //property int level: 50
                    Layout.preferredWidth: 50
                    Layout.preferredHeight :25
                }


                ColumnLayout{
                    Label{
                        text: batteryLevel + "%"
                        font.pixelSize: 15
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                    Label{
                        text: "Battery"
                        font.pixelSize: 10
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                }
            }
            RowLayout{
                spacing: 15
                Image {
                    Layout.preferredWidth: 30
                    Layout.preferredHeight:  30
                    source: "qrc:/assets/speedometer.svg"
                }

                ColumnLayout{
                    Label{
                        text: "78 mph"
                        font.pixelSize: 15
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                    Label{
                        text: "Avg. Speed"
                        font.pixelSize: 10
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                }
            }
        }
    }
}
