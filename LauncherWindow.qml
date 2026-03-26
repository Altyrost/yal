import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PanelWindow {
    id: root

    property var controller: LauncherController {}
    required property QtObject shellState

    visible: true
    aboveWindows: true
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    WlrLayershell.namespace: "yal-launcher"

    property real baseImplicitWidth: shellState.centerWidth
    property real baseImplicitHeight: shellState.centerHeight

    implicitWidth: baseImplicitWidth
    implicitHeight: baseImplicitHeight

    anchors.left: true
    anchors.top: true
    margins.left: shellState.centerLeft(screen)
    margins.top: shellState.centerTop(screen)

    readonly property var currentPlugin: controller.currentPlugin
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

    Rectangle {
        id: panel
        anchors.fill: parent
        radius: 14
        color: "#141414"
        border.width: 0
    }

    Item {
        id: contentRoot
        anchors.fill: parent
        anchors.margins: 16

        Rectangle {
            id: inputBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 48
            radius: 12
            color: "transparent"

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    id: modePill
                    Layout.preferredWidth: modeText.implicitWidth + 26
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
                                    top: root.shellState.topViewItem,
                                    left: root.shellState.leftViewItem,
                                    right: root.shellState.rightViewItem,
                                    bottom: root.shellState.bottomViewItem
                                });
                            }
                        }
                    }
                }
            }
        }
    }
}
