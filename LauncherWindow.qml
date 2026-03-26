import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PanelWindow {
    id: root

    visible: true
    aboveWindows: true
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    implicitWidth: 720
    implicitHeight: 460

    anchors.left: true
    anchors.top: true
    margins.left: screen ? Math.max(0, Math.round((screen.width - implicitWidth) / 2)) : 0
    margins.top: screen ? Math.max(0, Math.round((screen.height - implicitHeight) / 2)) : 0

    property var registry: PluginRegistry {
        parent: root
    }

    property var plugins: registry.plugins
    property int currentPluginIndex: 0
    property var currentPlugin: plugins.length > 0 ? plugins[currentPluginIndex] : null
    property string query: ""
    property bool suppressInputTextChange: false

    function closeLauncher() {
        Qt.quit();
    }

    function findPluginIndexById(pluginId) {
        for (var i = 0; i < plugins.length; ++i) {
            if (plugins[i] && plugins[i].pluginId === pluginId)
                return i;
        }

        return -1;
    }

    function switchToPluginById(pluginId) {
        const index = findPluginIndexById(pluginId);
        if (index < 0)
            return false;

        activatePlugin(index);
        return true;
    }

    function findPluginIndexByBang(bang) {
        const normalizedBang = (bang || "").trim().toLowerCase();
        if (!normalizedBang.length)
            return -1;

        for (var i = 0; i < plugins.length; ++i) {
            const plugin = plugins[i];
            if (!plugin || !plugin.bang)
                continue;

            if (plugin.bang.toLowerCase() === normalizedBang)
                return i;
        }

        return -1;
    }

    function consumeModeCommand(textValue) {
        const inputText = textValue || "";
        const match = inputText.match(/^\s*(!.*?)\s+(.*)$/i);
        if (!match)
            return false;

        const bang = (match[1] || "").toLowerCase();
        const remaining = (match[2] || "").trim();
        const targetPluginIndex = findPluginIndexByBang(bang);
        if (targetPluginIndex < 0)
            return false;

        activatePlugin(targetPluginIndex);

        suppressInputTextChange = true;
        input.text = remaining;
        suppressInputTextChange = false;

        query = remaining;
        syncPluginQuery();
        return true;
    }

    Connections {
        target: root.currentPlugin

        function onRequestClose() {
            root.closeLauncher();
        }

        function onRequestClear() {
        }
    }

    function syncPluginQuery() {
        if (!currentPlugin)
            return;
        currentPlugin.query = query;
        if (currentPlugin.onQueryChanged)
            currentPlugin.onQueryChanged(query);
    }

    function activatePlugin(index) {
        if (index < 0 || index >= plugins.length)
            return;
        currentPluginIndex = index;

        if (currentPlugin && currentPlugin.onActivated)
            currentPlugin.onActivated();

        syncPluginQuery();
    }

    Component.onCompleted: {
        if (currentPlugin && currentPlugin.onActivated)
            currentPlugin.onActivated();

        syncPluginQuery();
        input.forceActiveFocus();
    }

    onCurrentPluginChanged: {
        if (currentPlugin && currentPlugin.onActivated)
            currentPlugin.onActivated();

        syncPluginQuery();
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

        Loader {
            id: topSlot
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            sourceComponent: root.currentPlugin ? root.currentPlugin.topView : null

            visible: item !== null
            active: sourceComponent !== null
        }

        Rectangle {
            id: inputBar
            anchors.top: topSlot.visible ? topSlot.bottom : parent.top
            anchors.topMargin: topSlot.visible ? 10 : 0
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

                            if (root.consumeModeCommand(text))
                                return;

                            root.query = text;
                            root.syncPluginQuery();
                        }

                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Escape) {
                                Qt.quit();
                                event.accepted = true;
                            }

                            if (root.currentPlugin && root.currentPlugin.handleKey) {
                                root.currentPlugin.handleKey(event, {
                                    top: topSlot.item,
                                    left: leftSlot.item,
                                    right: rightSlot.item,
                                    bottom: bottomSlot.item
                                });
                            }
                        }
                    }
                }
            }
        }

        Loader {
            id: leftSlot
            anchors.top: inputBar.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            sourceComponent: root.currentPlugin ? root.currentPlugin.leftView : null

            visible: item !== null
            active: sourceComponent !== null
        }

        Loader {
            id: rightSlot
            anchors.top: inputBar.bottom
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            sourceComponent: root.currentPlugin ? root.currentPlugin.rightView : null

            visible: item !== null
            active: sourceComponent !== null
        }

        Loader {
            id: bottomSlot
            anchors.top: inputBar.bottom
            anchors.topMargin: 10
            anchors.left: leftSlot.visible ? leftSlot.right : parent.left
            anchors.leftMargin: leftSlot.visible ? 10 : 0
            anchors.right: rightSlot.visible ? rightSlot.left : parent.right
            anchors.rightMargin: rightSlot.visible ? 10 : 0
            anchors.bottom: parent.bottom
            sourceComponent: root.currentPlugin ? root.currentPlugin.bottomView : null

            visible: item !== null
            active: sourceComponent !== null
        }
    }
}
