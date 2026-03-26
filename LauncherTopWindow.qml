import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: root

    required property QtObject controller
    required property QtObject shellState

    visible: topViewHeight > 0
    aboveWindows: true
    focusable: false
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    WlrLayershell.namespace: "yal-launcher-top"

    readonly property var currentPlugin: controller.currentPlugin
    readonly property int topViewHeight: Math.round(previewLoader.item && previewLoader.item.implicitHeight ? previewLoader.item.implicitHeight : 0)

    implicitWidth: shellState.centerWidth
    implicitHeight: shellState.topHeight

    anchors.left: true
    anchors.top: true
    margins.left: shellState.centerLeft(screen)
    margins.top: shellState.centerTop(screen) - shellState.gap - shellState.topHeight

    mask: Region {
        x: 0
        y: root.height - root.topViewHeight
        width: root.width
        height: root.topViewHeight
    }

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: "#141414"
        border.width: 0
    }

    Loader {
        id: previewLoader
        anchors.fill: parent
        anchors.margins: 16
        sourceComponent: root.currentPlugin ? root.currentPlugin.topView : null
        active: sourceComponent !== null
        visible: root.topViewHeight > 0

        onItemChanged: {
            root.shellState.topViewItem = item;
            if (item)
                item.anchors.fill = previewLoader;
        }
    }
}
