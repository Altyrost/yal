pragma ComponentBehavior: Bound
import QtQuick

import "../.."

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

    topView: Component {
        Item {
            visible: plugin.showTop
            implicitHeight: visible ? 140 : 0
            implicitWidth: visible ? 140 : 0

            Text {
                anchors.centerIn: parent
                text: "Top"
                color: "#ddd7cf"
                font.pixelSize: 28
            }
        }
    }

    leftView: Component {
        Item {
            visible: plugin.showLeft
            implicitHeight: visible ? 140 : 0
            implicitWidth: visible ? 140 : 0

            Text {
                anchors.centerIn: parent
                text: "Left"
                color: "#ddd7cf"
                font.pixelSize: 24
            }
        }
    }

    rightView: Component {
        Item {
            visible: plugin.showRight
            implicitHeight: visible ? 140 : 0
            implicitWidth: visible ? 140 : 0

            Text {
                anchors.centerIn: parent
                text: "Right"
                color: "#ddd7cf"
                font.pixelSize: 24
            }
        }
    }

    bottomView: Component {
        Item {
            implicitHeight: visible ? 140 : 0
            implicitWidth: visible ? 140 : 0
            visible: plugin.showBottom

            Text {
                anchors.centerIn: parent
                text: "Bottom"
                color: "#ddd7cf"
                font.pixelSize: 28
            }
        }
    }
}
