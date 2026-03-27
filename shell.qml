import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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

    implicitWidth: leftFrame.maxContentWidth + root.gap + inputBar.width + root.gap + rightFrame.maxContentWidth
    implicitHeight: topFrame.maxContentHeight + root.gap + inputBar.height + root.gap + bottomFrame.maxContentHeight

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
    property bool suppressInputTextChange: false

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
        id: inputBar
        x: leftFrame.maxContentWidth + root.gap
        y: topFrame.maxContentHeight + root.gap
        width: 720
        height: 48
        radius: 12
        color: "#141414"
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
        x: leftFrame.maxContentWidth + root.gap + Math.round((inputBar.width - width) / 2)
        y: maxContentHeight - height
        z: 1
        maxContentWidth: inputBar.width
        maxContentHeight: 440
        defaultContentWidth: inputBar.width
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
        x: leftFrame.maxContentWidth + root.gap + inputBar.width + root.gap
        y: topFrame.maxContentHeight + root.gap + inputBar.height + root.gap + Math.round((bottomFrame.maxContentHeight - height) / 2)
        z: 1
        maxContentWidth: 220
        maxContentHeight: bottomFrame.maxContentHeight
        sourceComponent: root.currentPlugin ? root.currentPlugin.rightView : null
    }

    DirectionalSlot {
        id: bottomFrame
        x: leftFrame.maxContentWidth + root.gap + Math.round((inputBar.width - width) / 2)
        y: topFrame.maxContentHeight + root.gap + inputBar.height + root.gap
        z: 1
        maxContentWidth: inputBar.width
        maxContentHeight: 284
        defaultContentWidth: inputBar.width
        sourceComponent: root.currentPlugin ? root.currentPlugin.bottomView : null
    }
}
