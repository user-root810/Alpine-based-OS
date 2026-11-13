import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    color: "#0a0a0d"

    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: "demon-512.png"
        fillMode: Image.PreserveAspectFit
        width: 256
        height: 256
        opacity: 0.9
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        text: "Faustix — signum pacti"
        color: "#a11226"
        font.family: "JetBrains Mono Nerd Font"
        font.pixelSize: 16
    }
}
