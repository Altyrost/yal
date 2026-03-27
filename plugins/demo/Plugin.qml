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
            implicitWidth: 720
            implicitHeight: plugin.showTop ? 140 : 0
            visible: plugin.showTop

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
            implicitWidth: plugin.showLeft ? 180 : 0
            implicitHeight: plugin.showLeft ? 120 : 0
            visible: plugin.showLeft

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
            implicitWidth: plugin.showRight ? 180 : 0
            implicitHeight: plugin.showRight ? 120 : 0
            visible: plugin.showRight

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
            implicitWidth: 720
            implicitHeight: plugin.showBottom ? 140 : 0
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
