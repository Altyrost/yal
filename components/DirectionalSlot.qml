import QtQuick

Item {
    id: root

    property Component sourceComponent: null
    property int maxContentWidth: 0
    property int maxContentHeight: 0
    property int defaultContentWidth: 0
    property int defaultContentHeight: 0
    property color backgroundColor: "#141414"
    property int cornerRadius: 14
    property bool clipLoader: false
    property int contentMargin: 4

    readonly property var item: contentLoader.item
    readonly property int measuredWidth: Math.round(item && item.implicitWidth !== undefined && item.implicitWidth > 0 ? item.implicitWidth : defaultContentWidth)
    readonly property int measuredHeight: Math.round(item && item.implicitHeight !== undefined ? item.implicitHeight : defaultContentHeight)
    readonly property int innerWidth: maxContentWidth > 0 ? Math.min(measuredWidth, maxContentWidth) : measuredWidth
    readonly property int innerHeight: maxContentHeight > 0 ? Math.min(measuredHeight, maxContentHeight) : measuredHeight
    readonly property bool hasContent: innerWidth > 0 || innerHeight > 0
    readonly property int contentWidth: hasContent ? innerWidth + (contentMargin * 2) : 0
    readonly property int contentHeight: hasContent ? innerHeight + (contentMargin * 2) : 0

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
