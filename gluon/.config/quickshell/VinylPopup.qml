import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick

PopupWindow {
  id: popup

  implicitWidth: 260
  implicitHeight: 340
  color: "transparent"
  //WlrLayershell.namespace: "quickshell:vinylpopup"

  grabFocus: true

  Rectangle {
    anchors.fill: parent
    radius: 14
    color: "#662f2f2f"
    border.color: "#4a4a4a"
    border.width: 1

    Column {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 12

      Item {
        id: platter
        width: 200
        height: 200
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
          id: disc
          anchors.fill: parent
          radius: width / 2
          color: "#0c0c0e"

          Repeater {
            model: 6
            Rectangle {
              anchors.centerIn: parent
              width: disc.width - (index + 1) * 14
              height: width
              radius: width / 2
              color: "transparent"
              border.color: "#2a2820"
              border.width: 1
            }
          }

          ClippingRectangle {
            id: label
            anchors.centerIn: parent
            width: parent.width * 0.42
            height: width
            radius: width / 2
            color: "#55503f"

            Image {
              anchors.fill: parent
              source: Player.artUrl
              fillMode: Image.PreserveAspectCrop
              asynchronous: true
            }
          }

          Rectangle {
            anchors.centerIn: parent
            width: 8
            height: 8
            radius: 4
            color: "#171410"
            border.color: "#8a7a55"
          }

          RotationAnimation {
            target: disc
            from: 0
            to: 360
            duration: 1800
            loops: Animation.Infinite
            running: Player.isPlaying
          }
        }

        Item {
          id: tonearm
          width: 80
          height: 10
          x: 105
          y: 15
          transformOrigin: Item.TopRight
          rotation: Player.isPlaying ? -55 : 20

          Behavior on rotation {
            NumberAnimation { duration: 400; easing.type: Easing.OutBack; easing.overshoot: 1.4 }
          }

          Rectangle {
            x: 18
            y: -2
            width: parent.width - 26
            height: 4
            radius: 2
            color: "#c9a15a"
            border.color: "#8a6d3a"
            border.width: 1
          }

          Rectangle {
            x: parent.width - 8
            y: -4
            width: 8
            height: 8
            radius: 4
            color: "#2a2418"
            border.color: "#171410"
            border.width: 1
          }

          Rectangle {
            x: parent.width + 2
            y: -7
            width: 14
            height: 14
            radius: 3
            color: "#b8935a"
            border.color: "#7a5f34"
            border.width: 1
          }

          Rectangle {
            x: 0
            y: -6
            width: 20
            height: 12
            radius: 3
            color: "#15130f"
            border.color: "#3a3527"
            border.width: 1

            Rectangle {
              x: 8
              y: -2
              width: 4
              height: 4
              radius: 2
              color: "#d4af37"
            }
          }
        }
      }

      Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 2

        Text {
          text: Player.title
          color: "#ede4d3"
          font.pixelSize: 14; font.family: "Liberation Serif"
          font.bold: true
          elide: Text.ElideRight
          width: 220
          horizontalAlignment: Text.AlignHCenter
        }
        Text {
          text: Player.artist
          color: "#a89f8c"
          font.pixelSize: 12; font.family: "Liberation Serif"
          elide: Text.ElideRight
          width: 220
          horizontalAlignment: Text.AlignHCenter
        }
      }

      Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 24

        Text {
          text: "⏮"
          font.pixelSize: 20; font.family: "Liberation Serif"
          color: "#ede4d3"
          MouseArea { anchors.fill: parent; onClicked: Player.previous() }
        }
        Text {
          text: Player.isPlaying ? "⏸" : "▶"
          font.pixelSize: 22; font.family: "Liberation Serif"
          color: "#ede4d3"
          MouseArea { anchors.fill: parent; onClicked: Player.togglePlaying() }
        }
        Text {
          text: "⏭"
          font.pixelSize: 20; font.family: "Liberation Serif"
          color: "#ede4d3"
          MouseArea { anchors.fill: parent; onClicked: Player.next() }
        }
      }
    }
  }
}
