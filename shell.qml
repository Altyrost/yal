import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.components

PanelWindow {
    id: root

    anchors {
        left: true
        bottom: true
        right: true
        top: true
    }

    property var controller: LauncherController {}
    property int gap: 0
    readonly property var topViewItem: topFrame.item
    readonly property var leftViewItem: leftFrame.item
    readonly property var rightViewItem: rightFrame.item
    readonly property var bottomViewItem: bottomFrame.item

    visible: true
    aboveWindows: true
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    WlrLayershell.namespace: "yal-launcher"
    mask: Region {
        item: inputBar

        Region {
            item: topFrame
        }

        Region {
            item: leftFrame
        }

        Region {
            item: rightFrame
        }

        Region {
            item: bottomFrame
        }
    }

    readonly property var currentPlugin: controller.currentPlugin

    function closeLauncher() {
        Qt.quit();
    }

    Connections {
        target: root.currentPlugin

        function onRequestClose() {
            root.closeLauncher();
        }

        function onRequestClear() {
        }
    }

    LauncherBar {
        id: inputBar

        FontMetrics {
            id: fm
        }

        anchors.top: parent.top
        anchors.topMargin: parent.height / 10 * 4
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 2 - inputBar.width / 2

        barWidth: fm.averageCharacterWidth * 60
        barHeight: fm.capitalHeight + 40
        z: 1
        controller: root.controller
        currentPlugin: root.currentPlugin
        topViewItem: root.topViewItem
        leftViewItem: root.leftViewItem
        rightViewItem: root.rightViewItem
        bottomViewItem: root.bottomViewItem
    }

    DirectionalSlot {
        id: topFrame

        anchors.bottom: inputBar.top
        anchors.left: inputBar.left
        anchors.right: inputBar.right

        maximumHeight: inputBar.y

        z: 1
        animateWidth: false
        animateHeight: true

        sourceComponent: root.currentPlugin ? root.currentPlugin.topView : null
        clipLoader: true
    }

    DirectionalSlot {
        id: leftFrame

        anchors.right: inputBar.left
        anchors.top: topFrame.top
        anchors.bottom: bottomFrame.bottom

        maximumWidth: inputBar.x

        z: 1
        animateWidth: true
        animateHeight: false
        sourceComponent: root.currentPlugin ? root.currentPlugin.leftView : null
    }

    DirectionalSlot {
        id: rightFrame

        anchors.left: inputBar.right
        anchors.top: topFrame.top
        anchors.bottom: bottomFrame.bottom

        maximumWidth: parent.width - (inputBar.x + inputBar.width)

        z: 1
        animateWidth: true
        animateHeight: false
        sourceComponent: root.currentPlugin ? root.currentPlugin.rightView : null
    }

    DirectionalSlot {
        id: bottomFrame

        anchors.top: inputBar.bottom
        anchors.left: inputBar.left
        anchors.right: inputBar.right

        maximumHeight: parent.height - (inputBar.y + inputBar.height)

        z: 1
        animateWidth: false
        animateHeight: true
        sourceComponent: root.currentPlugin ? root.currentPlugin.bottomView : null
    }
}
