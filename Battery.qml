// Battery.qml
import QtQuick 2.15

Item {
    id: battery
    property int level: 50

    //width: 80
    //height: 30

    Rectangle {
        id: body
        width: parent.width * 0.75
        height: parent.height
        radius: height * 0.15
        border.color: "black"
        border.width: 2
        color: "white"

        // Fill inside
        Rectangle {
            width: (level / 100.0) * (body.width - 4)
            height: body.height - 4
            anchors.left: body.left
            anchors.verticalCenter: body.verticalCenter
            anchors.margins: 2
            radius: 2
            color: level <= 20 ? "red"
                  : level <= 50 ? "orange"
                  : "green"
        }

        // Terminal
        Rectangle {
            width: body.width * 0.1
            height: body.height *0.4
            x: body.width
            y: (body.height - 12) / 2
            color: "black"
        }
    }
}
