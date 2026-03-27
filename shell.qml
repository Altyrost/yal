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
        x: leftFrame.maxContentWidth + root.gap
        y: topFrame.maxContentHeight + root.gap
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
        x: leftFrame.maxContentWidth + root.gap + Math.round((inputBar.width - width) / 2)
        y: maxContentHeight - height
        z: 1
        maxContentWidth: inputBar.barWidth - (contentMargin * 2)
        maxContentHeight: 440
        defaultContentWidth: inputBar.barWidth - (contentMargin * 2)
        sourceComponent: root.currentPlugin ? root.currentPlugin.topView : null
        clipLoader: true
    }

    DirectionalSlot {
        id: leftFrame
        x: maxContentWidth - width
        y: topFrame.maxContentHeight + root.gap + inputBar.height + root.gap + Math.round((bottomFrame.maxContentHeight - height) / 2)
        z: 1
        maxContentWidth: 220
        maxContentHeight: bottomFrame.maxContentHeight
        sourceComponent: root.currentPlugin ? root.currentPlugin.leftView : null
    }

    DirectionalSlot {
        id: rightFrame
        x: leftFrame.maxContentWidth + root.gap + inputBar.barWidth + root.gap
        y: topFrame.maxContentHeight + root.gap + inputBar.height + root.gap + Math.round((bottomFrame.maxContentHeight - height) / 2)
        z: 1
        maxContentWidth: 220
        maxContentHeight: bottomFrame.maxContentHeight
        sourceComponent: root.currentPlugin ? root.currentPlugin.rightView : null
    }

    DirectionalSlot {
        id: bottomFrame
        x: leftFrame.maxContentWidth + root.gap + Math.round((inputBar.barWidth - width) / 2)
        y: topFrame.maxContentHeight + root.gap + inputBar.height + root.gap
        z: 1
        maxContentWidth: inputBar.barWidth - (contentMargin * 2)
        maxContentHeight: 284
        defaultContentWidth: inputBar.barWidth - (contentMargin * 2)
        sourceComponent: root.currentPlugin ? root.currentPlugin.bottomView : null
    }
}
