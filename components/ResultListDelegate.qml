import QtQuick
import QtQuick.Controls
import Quickshell.Widgets

ItemDelegate {
    id: root

    required property var modelData
    required property int index

    property real delegateHeight: 42
    property bool showIcon: true
    property url iconSource: ""
    property string title: (modelData && (modelData.name || modelData.id)) ? (modelData.name || modelData.id) : ""

    property color normalTextColor: "#ddd7cf"
    property color highlightedTextColor: "white"
    property color highlightColor: "#2a2a2a"

    property int contentLeftMargin: 12
    property int contentSpacing: 12
    property bool followHover: true

    signal activated(var item)

    function selectItem() {
        if (ListView.view)
            ListView.view.currentIndex = root.index;
    }

    width: ListView.view ? ListView.view.width : 0
    height: delegateHeight
    highlighted: ListView.isCurrentItem
    hoverEnabled: true
    focusPolicy: Qt.NoFocus

    background: Rectangle {
        anchors.fill: parent
        color: root.highlighted ? root.highlightColor : "transparent"
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.contentLeftMargin
        spacing: root.contentSpacing

        IconImage {
            visible: root.showIcon
            width: 22
            height: 22
            source: root.iconSource
        }

        Text {
            text: root.title
            color: root.highlighted ? root.highlightedTextColor : root.normalTextColor
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton

        onTapped: {
            root.selectItem();
            root.activated(root.modelData);
        }
    }

    HoverHandler {
        enabled: root.followHover

        onHoveredChanged: {
            if (hovered)
                root.selectItem();
        }
    }
}
