import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

QtObject {
    id: plugin

    property string id: "apps"
    property string displayName: "Apps"
    property string query: ""
    property var listViewRef: null

    property Component topView: null
    property Component leftView: null
    property Component rightView: null

    signal requestClose()
    signal requestClear()

    property var filteredApps: {
        const q = query.trim().toLowerCase()

        const apps = DesktopEntries.applications.values

        if (q.length === 0) {
            return apps
        }

        return apps.filter(app => {
            const name = (app.name || "").toLowerCase()
            const genericName = (app.genericName || "").toLowerCase()
            const exec = (app.command || []).join(" ").toLowerCase()
            const keywords = (app.keywords || []).join(" ").toLowerCase()
            const desktopId = (app.id || "").toLowerCase()

            return name.includes(q)
                || genericName.includes(q)
                || exec.includes(q)
                || keywords.includes(q)
                || desktopId.includes(q)
        })
    }

    function handleKey(event) {
        switch (event.key) {
            case Qt.Key_Return:
            case Qt.Key_Enter:
                enterPressed()
                event.accepted = true
                break

            case Qt.Key_Up:
                upPressed()
                event.accepted = true
                break

            case Qt.Key_Down:
                downPressed()
                event.accepted = true
                break
        }
    }

    function enterPressed() {
        if (filteredApps.length > 0)
            launchApp(filteredApps[0])
    }

    function upPressed() { 
        listViewRef.currentIndex = Math.max(0, listViewRef.currentIndex - 1)
    }

    function downPressed() { 
        listViewRef.currentIndex = Math.min(listViewRef.count - 1, listViewRef.currentIndex + 1)
    }

    function launchApp(app) {
        if (!app)
            return

        app.execute()
        requestClose()
        requestClear()
    }

    property Component bottomView: Component {
        Rectangle {
            color: "transparent"

            ListView {
                id: listView
                anchors.fill: parent
                clip: true
                spacing: 6
                model: plugin.filteredApps
                focus: true
                currentIndex: count > 0 ? 0 : -1

                onCountChanged: currentIndex = count > 0 ? 0 : -1

                delegate: ItemDelegate {
                    id: delegate
                    required property var modelData
                    required property int index

                    width: listView.width
                    height: 42
                    highlighted: ListView.isCurrentItem

                    background: Rectangle {
                        anchors.fill: parent
                        radius: 10
                        color: delegate.highlighted ? "#2a2a2a" : "transparent"
                    }

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        spacing: 12

                        IconImage {
                            width: 22
                            height: 22
                            source: Quickshell.iconPath(modelData.icon || "", true)
                        }

                        Text {
                            text: modelData.name || modelData.id
                            color: delegate.highlighted ? "white" : "#ddd7cf"
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                    }

                    onClicked: {
                        listView.currentIndex = index
                        plugin.launchApp(modelData)
                    }

                    HoverHandler {
                        onHoveredChanged: {
                            if (hovered)
                                listView.currentIndex = index
                        }
                    }
                }
            }

            Component.onCompleted: plugin.listViewRef = listView
            Component.onDestruction: {
                if (plugin.listViewRef === listView)
                    plugin.listViewRef = null
            }
        }
    }

    function onActivated() {}

    function onQueryChanged(newQuery) {
        query = newQuery
    }
}