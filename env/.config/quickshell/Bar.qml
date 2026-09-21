import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick

Scope {
  id: root

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 34
      color: "#662f2f2f"
      WlrLayershell.namespace: "quickshell:bar"

      readonly property int workspacesPerMonitor: 5
      readonly property var hyprMonitor: Hyprland.monitorFor(bar.screen)
      readonly property int monitorIndex: {
        const sorted = [...Hyprland.monitors.values].sort((a, b) => a.id - b.id);
        const idx = sorted.findIndex(m => m.id === bar.hyprMonitor?.id);
        return idx >= 0 ? idx : 0;
      }
      readonly property int workspaceBase: bar.monitorIndex * bar.workspacesPerMonitor

      Row {
        id: workspaces
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        Repeater {
          model: bar.workspacesPerMonitor

          Rectangle {
            id: wsPill
            required property int index
            property int localWs: index + 1
            property int wsId: bar.workspaceBase + localWs
            property bool isActive: Hyprland.focusedWorkspace?.id === wsId

            width: isActive ? 30 : 8
            height: 10
            radius: 5
            color: "#ede4d3"

            Behavior on width {
              NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }

            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: Hyprland.dispatch("workspace " + wsPill.wsId)
            }
          }
        }
      }

      Row {
        id: rightGroup
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        spacing: 16

        Item {
          id: musicIcon
          width: 34
          height: bar.height
          anchors.verticalCenter: parent.verticalCenter

          Text {
            anchors.centerIn: parent
            text: "♫"
            font.pixelSize: 18; font.family: "Liberation Serif"
            color: Player.isPlaying ? "#c9a15a" : "#ede4d3"
          }

          MouseArea {
            anchors.fill: parent
            onClicked: {
              if (!vinyl.visible) {
                const pos = musicIcon.mapToItem(null, 0, musicIcon.height);
                vinyl.anchor.rect.x = pos.x + musicIcon.width / 2 - vinyl.implicitWidth / 2;
                vinyl.anchor.rect.y = pos.y;
              }
              vinyl.visible = !vinyl.visible;
            }
          }
        }

        Text {
          anchors.verticalCenter: parent.verticalCenter
          font.pixelSize: 14; font.family: "Liberation Serif"
          color: "#ede4d3"

          property string weekday: ""
          property string dateStr: ""
          property string timeStr: ""
          text: weekday + ", " + dateStr + "  " + timeStr

          function pad(n) {
            return n < 10 ? "0" + n : "" + n;
          }

          function ordinal(n) {
            if (n % 10 === 1 && n % 100 !== 11) return n + "st";
            if (n % 10 === 2 && n % 100 !== 12) return n + "nd";
            if (n % 10 === 3 && n % 100 !== 13) return n + "rd";
            return n + "th";
          }

          function refresh() {
            const now = new Date();
            const weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
            const months = ["January", "February", "March", "April", "May", "June",
                             "July", "August", "September", "October", "November", "December"];
            weekday = weekdays[now.getDay()];
            dateStr = ordinal(now.getDate()) + " " + months[now.getMonth()] + " " + now.getFullYear();
            timeStr = pad(now.getHours()) + ":" + pad(now.getMinutes());
          }

          Component.onCompleted: refresh()

          Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: parent.refresh()
          }
        }
      }

      VinylPopup {
        id: vinyl
        anchor.window: bar
      }
    }
  }
}
