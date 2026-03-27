import Quickshell
import Quickshell.Wayland
import QtQuick
import "components"

PanelWindow {
    id: root

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

    implicitWidth: leftFrame.maxContentWidth + root.gap + inputBar.width + root.gap + rightFrame.maxContentWidth
    implicitHeight: topFrame.maxContentHeight + root.gap + inputBar.height + root.gap + bottomFrame.maxContentHeight

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

        anchors.centerIn: parent

        barWidth: 720
        barHeight: 48
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

        z: 1
        animateWidth: false
        animateHeight: true

        maxContentHeight: 220
        defaultContentWidth: inputBar.barWidth - (contentMargin * 2)
        sourceComponent: root.currentPlugin ? root.currentPlugin.topView : null
        clipLoader: true
    }

    DirectionalSlot {
        id: leftFrame

        anchors.right: inputBar.left
        anchors.top: topFrame.top
        anchors.bottom: bottomFrame.bottom

        z: 1
        animateWidth: true
        animateHeight: false
        maxContentWidth: 220
        defaultContentHeight: bottomFrame.maxContentHeight
        sourceComponent: root.currentPlugin ? root.currentPlugin.leftView : null
    }

    DirectionalSlot {
        id: rightFrame

        anchors.left: inputBar.right
        anchors.top: topFrame.top
        anchors.bottom: bottomFrame.bottom

        z: 1
        animateWidth: true
        animateHeight: false
        maxContentWidth: 220
        maxContentHeight: bottomFrame.maxContentHeight
        defaultContentHeight: bottomFrame.maxContentHeight
        sourceComponent: root.currentPlugin ? root.currentPlugin.rightView : null
    }

    DirectionalSlot {
        id: bottomFrame

        anchors.top: inputBar.bottom
        anchors.left: inputBar.left
        anchors.right: inputBar.right

        z: 1
        animateWidth: false
        animateHeight: true
        maxContentWidth: inputBar.barWidth - (contentMargin * 2)
        maxContentHeight: 220
        defaultContentWidth: inputBar.barWidth - (contentMargin * 2)
        sourceComponent: root.currentPlugin ? root.currentPlugin.bottomView : null
    }
}
