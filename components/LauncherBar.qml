import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    required property var controller
    required property var currentPlugin
    property var topViewItem: null
    property var leftViewItem: null
    property var rightViewItem: null
    property var bottomViewItem: null
    property int barWidth: 720
    property int barHeight: 48
    property bool suppressInputTextChange: false

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

    width: barWidth
    height: barHeight
    color: "#141414"

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

    RowLayout {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 0

        Rectangle {
            id: modePill
            Layout.preferredWidth: Math.ceil(longestModeMetrics.width) + 26
            Layout.fillHeight: true
            color: "#2a2a2a"

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
