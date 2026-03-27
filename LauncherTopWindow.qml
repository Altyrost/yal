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
    readonly property int topViewWidth: Math.round(previewLoader.item && previewLoader.item.implicitWidth !== undefined && previewLoader.item.implicitWidth > 0 ? previewLoader.item.implicitWidth : shellState.centerWidth)
    readonly property int topViewHeight: Math.round(previewLoader.item && previewLoader.item.implicitHeight !== undefined ? previewLoader.item.implicitHeight : 0)

    implicitWidth: topViewWidth
    implicitHeight: topViewHeight

    anchors.left: true
    anchors.top: true
    margins.left: shellState.centerLeft(screen) + Math.round((shellState.centerWidth - root.implicitWidth) / 2)
    margins.top: shellState.mainStackTop(screen) - shellState.gap - root.implicitHeight

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: "#141414"
        border.width: 0
    }

    Loader {
        id: previewLoader
        anchors.fill: parent
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
