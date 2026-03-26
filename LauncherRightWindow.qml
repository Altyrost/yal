import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: root

    required property QtObject controller
    required property QtObject shellState

    readonly property var currentPlugin: controller.currentPlugin

    visible: currentPlugin && currentPlugin.rightView !== null
    aboveWindows: true
    focusable: false
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    WlrLayershell.namespace: "yal-launcher-right"

    implicitWidth: shellState.sideWidth
    implicitHeight: shellState.contentHeight

    anchors.left: true
    anchors.top: true
    margins.left: shellState.centerLeft(screen) + shellState.centerWidth + shellState.gap
    margins.top: shellState.centerTop(screen) + shellState.centerHeight + shellState.gap

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: "#141414"
        border.width: 0
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
        anchors.margins: 16
        sourceComponent: root.currentPlugin ? root.currentPlugin.rightView : null
        active: sourceComponent !== null

        onItemChanged: {
            root.shellState.rightViewItem = item;
        }
    }
}
