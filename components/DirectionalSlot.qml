import QtQuick

Item {
    id: root

    property Component sourceComponent: null
    property int fallbackWidth: 0
    property int fallbackHeight: 0
    property color backgroundColor: "#141414"
    property int cornerRadius: 14
    property bool clipLoader: false
    property int contentMargin: 4

    readonly property var item: contentLoader.item
    readonly property int contentWidth: Math.round(item && item.implicitWidth !== undefined && item.implicitWidth > 0 ? item.implicitWidth : fallbackWidth)
    readonly property int contentHeight: Math.round(item && item.implicitHeight !== undefined ? item.implicitHeight : fallbackHeight)

    width: implicitWidth
    height: implicitHeight
    implicitWidth: contentWidth
    implicitHeight: contentHeight

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 160
            easing.type: Easing.OutCubic
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 160
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.backgroundColor
        border.width: 0
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
        anchors.margins: root.contentMargin
        sourceComponent: root.sourceComponent
        active: sourceComponent !== null
        clip: root.clipLoader

        onItemChanged: {
            if (item)
                item.anchors.fill = contentLoader;
        }
    }
}
