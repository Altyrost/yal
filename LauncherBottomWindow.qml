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

    implicitWidth: Math.round(contentLoader.item && contentLoader.item.implicitWidth !== undefined && contentLoader.item.implicitWidth > 0 ? contentLoader.item.implicitWidth : shellState.centerWidth)
    implicitHeight: Math.round(contentLoader.item && contentLoader.item.implicitHeight !== undefined ? contentLoader.item.implicitHeight : shellState.defaultContentHeight)

    anchors.left: true
    anchors.top: true
    margins.left: shellState.centerLeft(screen) + Math.round((shellState.centerWidth - root.implicitWidth) / 2)
    margins.top: shellState.mainStackTop(screen) + shellState.centerHeight + shellState.gap

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: "#141414"
        border.width: 0
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
        sourceComponent: root.currentPlugin ? root.currentPlugin.bottomView : null
        active: sourceComponent !== null

        onItemChanged: {
            root.shellState.bottomViewItem = item;
            if (item)
                item.anchors.fill = contentLoader;
        }
    }
}
