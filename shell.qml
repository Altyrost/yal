import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"

PanelWindow {
    id: root

    property var controller: LauncherController {}
    property int centerWidth: 720
    property int centerHeight: 48
    property int defaultContentHeight: 284
    property int defaultSideWidth: 220
    property int defaultTopHeight: 440
    property int gap: 6
    property var topViewItem: null
    property var leftViewItem: null
    property var rightViewItem: null
    property var bottomViewItem: null

    visible: true
    aboveWindows: true
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    WlrLayershell.namespace: "yal-launcher"
    mask: Region {
        item: inputBar

        Region {
            item: shellBackground
        }

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

    implicitWidth: layout.outerWidth
    implicitHeight: layout.outerHeight

    anchors.left: true
    anchors.top: true
    margins.left: layout.outerLeft(screen)
    margins.top: layout.outerTop(screen)

    readonly property var currentPlugin: controller.currentPlugin
    readonly property string longestPluginDisplayName: {
        const plugins = root.controller && root.controller.plugins ? root.controller.plugins : [];
        let longestName = "Mode";

        for (let index = 0; index < plugins.length; ++index) {
            const plugin = plugins[index];
            const candidate = plugin && plugin.displayName ? plugin.displayName : "";
            if (candidate.length > longestName.length)
                longestName = candidate;
        }

        return longestName;
    }
    readonly property int shellLeftEdge: leftFrame.width > 0 ? Math.min(inputBar.x, leftFrame.x) : inputBar.x
    readonly property int shellRightEdge: Math.max(inputBar.x + inputBar.width, topFrame.x + topFrame.width, bottomFrame.x + bottomFrame.width, rightFrame.width > 0 ? rightFrame.x + rightFrame.width : inputBar.x + inputBar.width)
    readonly property int shellTopEdge: topFrame.height > 0 ? Math.min(inputBar.y, topFrame.y) : inputBar.y
    readonly property int shellBottomEdge: Math.max(inputBar.y + inputBar.height, bottomFrame.height > 0 ? bottomFrame.y + bottomFrame.height : inputBar.y + inputBar.height, leftFrame.height > 0 ? leftFrame.y + leftFrame.height : inputBar.y + inputBar.height, rightFrame.height > 0 ? rightFrame.y + rightFrame.height : inputBar.y + inputBar.height)
    property bool suppressInputTextChange: false

    function closeLauncher() {
        Qt.quit();
    }

    QtObject {
        id: layout

        readonly property int outerWidth: root.defaultSideWidth + root.gap + root.centerWidth + root.gap + root.defaultSideWidth
        readonly property int outerHeight: root.defaultTopHeight + root.gap + root.centerHeight + root.gap + root.defaultContentHeight
        readonly property int centerX: root.defaultSideWidth + root.gap
        readonly property int centerY: root.defaultTopHeight + root.gap
        readonly property int contentY: centerY + root.centerHeight + root.gap

        function centerLeft(currentScreen) {
            return currentScreen ? Math.max(0, Math.round((currentScreen.width - root.centerWidth) / 2)) : 0;
        }

        function mainStackTop(currentScreen) {
            const stackHeight = root.centerHeight + root.gap + root.defaultContentHeight;
            return currentScreen ? Math.max(0, Math.round((currentScreen.height - stackHeight) / 2)) : 0;
        }

        function outerLeft(currentScreen) {
            return centerLeft(currentScreen) - root.defaultSideWidth - root.gap;
        }

        function outerTop(currentScreen) {
            return mainStackTop(currentScreen) - root.defaultTopHeight - root.gap;
        }
    }

    Connections {
        target: root.currentPlugin

        function onRequestClose() {
            root.closeLauncher();
        }

        function onRequestClear() {
        }
    }

    Connections {
        target: root.controller

        function onRequestInputTextUpdate(text) {
            root.suppressInputTextChange = true;
            input.text = text;
            root.suppressInputTextChange = false;
        }
    }

    Component.onCompleted: {
        input.forceActiveFocus();
    }

    TextMetrics {
        id: longestModeMetrics
        font.pixelSize: modeText.font.pixelSize
        text: root.longestPluginDisplayName
    }

    Rectangle {
        id: panel
        anchors.fill: parent
        color: "transparent"
        border.width: 0
    }

    Rectangle {
        id: shellBackground
        x: root.shellLeftEdge
        y: root.shellTopEdge
        width: root.shellRightEdge - root.shellLeftEdge
        height: root.shellBottomEdge - root.shellTopEdge
        radius: 16
        color: "#141414"
        border.width: 0
        visible: width > 0 && height > 0
        z: 0
    }

    Rectangle {
        id: inputBar
        x: layout.centerX
        y: layout.centerY
        width: root.centerWidth
        height: root.centerHeight
        radius: 12
        color: "black"
        z: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 4
            spacing: 0

            Rectangle {
                id: modePill
                Layout.preferredWidth: Math.ceil(longestModeMetrics.width) + 26
                Layout.fillHeight: true
                color: "#2a2a2a"
                topLeftRadius: 12
                bottomLeftRadius: 12
                topRightRadius: 0
                bottomRightRadius: 0

                Text {
                    id: modeText
                    anchors.centerIn: parent
                    text: root.currentPlugin ? root.currentPlugin.displayName : "Mode"
                    color: "#e0a126"
                    font.pixelSize: 13
                }
            }

            Rectangle {
                id: searchBox
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#202020"
                topLeftRadius: 0
                bottomLeftRadius: 0
                topRightRadius: 12
                bottomRightRadius: 12

                TextField {
                    id: input
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    placeholderText: "Search"
                    color: "#ddd7cf"
                    selectedTextColor: "#141414"
                    selectionColor: "#7a828f"
                    background: Item {}

                    onTextChanged: {
                        if (root.suppressInputTextChange)
                            return;

                        if (root.controller.consumeModeCommand(text))
                            return;

                        root.controller.setQuery(text);
                    }

                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            Qt.quit();
                            event.accepted = true;
                        }

                        if (root.currentPlugin && root.currentPlugin.handleKey) {
                            root.currentPlugin.handleKey(event, {
                                top: root.topViewItem,
                                left: root.leftViewItem,
                                right: root.rightViewItem,
                                bottom: root.bottomViewItem
                            });
                        }
                    }
                }
            }
        }
    }

    DirectionalSlot {
        id: topFrame
        x: layout.centerX + Math.round((root.centerWidth - width) / 2)
        y: root.defaultTopHeight - height
        z: 1
        fallbackWidth: root.centerWidth
        fallbackHeight: 0
        sourceComponent: root.currentPlugin ? root.currentPlugin.topView : null
        clipLoader: true

        onItemChanged: {
            root.topViewItem = item;
        }
    }

    DirectionalSlot {
        id: leftFrame
        x: root.defaultSideWidth - width
        y: layout.contentY + Math.round((root.defaultContentHeight - height) / 2)
        z: 1
        fallbackHeight: 0
        sourceComponent: root.currentPlugin ? root.currentPlugin.leftView : null

        onItemChanged: {
            root.leftViewItem = item;
        }
    }

    DirectionalSlot {
        id: rightFrame
        x: layout.centerX + root.centerWidth + root.gap
        y: layout.contentY + Math.round((root.defaultContentHeight - height) / 2)
        z: 1
        fallbackHeight: 0
        sourceComponent: root.currentPlugin ? root.currentPlugin.rightView : null

        onItemChanged: {
            root.rightViewItem = item;
        }
    }

    DirectionalSlot {
        id: bottomFrame
        x: layout.centerX + Math.round((root.centerWidth - width) / 2)
        y: layout.contentY
        z: 1
        fallbackWidth: root.centerWidth
        fallbackHeight: 0
        sourceComponent: root.currentPlugin ? root.currentPlugin.bottomView : null

        onItemChanged: {
            root.bottomViewItem = item;
        }
    }
}
