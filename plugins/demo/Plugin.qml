pragma ComponentBehavior: Bound
import QtQuick

import qs
import qs.components

BasePlugin {
    id: plugin

    pluginId: "demo"
    bang: "!d"
    displayName: "Demo"

    property bool showTop: false
    property bool showLeft: false
    property bool showRight: false
    property bool showBottom: false

    function onActivated() {
        showTop = false;
        showLeft = false;
        showRight = false;
        showBottom = false;
    }

    function handleKey(event, views) {
        if (!event)
            return;

        switch (event.key) {
        case Qt.Key_Up:
            showTop = !showTop;
            event.accepted = true;
            return;
        case Qt.Key_Left:
            showLeft = !showLeft;
            event.accepted = true;
            return;
        case Qt.Key_Right:
            showRight = !showRight;
            event.accepted = true;
            return;
        case Qt.Key_Down:
            showBottom = !showBottom;
            event.accepted = true;
            return;
        }

        plugin.dispatchKeyToViews(event, [views.top, views.left, views.right, views.bottom]);
    }

    topView: DirectionnalItem {
        visible: plugin.showTop
        fillWidth: true
        fillHeight: true
        Text {
            anchors.centerIn: parent
            text: "Top"
            color: "#ddd7cf"
            font.pixelSize: 28
        }
    }

    leftView: DirectionnalItem {
        visible: plugin.showLeft
        fillWidth: true
        fillHeight: true
        Text {
            anchors.centerIn: parent
            text: "Left"
            color: "#ddd7cf"
            font.pixelSize: 24
        }
    }

    rightView: DirectionnalItem {
        fillWidth: true
        fillHeight: true
        visible: plugin.showRight
        Text {
            anchors.centerIn: parent
            text: "Right"
            color: "#ddd7cf"
            font.pixelSize: 24
        }
    }

    bottomView: DirectionnalItem {
        fillWidth: true
        fillHeight: true
        visible: plugin.showBottom
        Text {
            anchors.centerIn: parent
            text: "Bottom"
            color: "#ddd7cf"
            font.pixelSize: 28
        }
    }
}
