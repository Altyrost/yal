import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: root

    required property QtObject controller
    required property QtObject shellState

    readonly property var currentPlugin: controller.currentPlugin

    visible: currentPlugin && currentPlugin.bottomView !== null
    aboveWindows: true
    focusable: false
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    WlrLayershell.namespace: "yal-launcher-bottom"

    implicitWidth: shellState.centerWidth
    implicitHeight: shellState.contentHeight

    anchors.left: true
    anchors.top: true
    margins.left: shellState.centerLeft(screen)
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
        sourceComponent: root.currentPlugin ? root.currentPlugin.bottomView : null
        active: sourceComponent !== null

        onItemChanged: {
            root.shellState.bottomViewItem = item;
        }
    }
}
