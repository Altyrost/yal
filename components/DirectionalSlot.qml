import QtQuick

Item {
    id: root

    property int maximumWidth: 100
    property int maximumHeight: 100

    property Component sourceComponent: null
    property color backgroundColor: "#141414"
    property bool clipLoader: false
    property int contentMargin: 4
    property bool animateWidth: false
    property bool animateHeight: false
    property int animationDuration: 240

    readonly property alias item: contentLoader.item

    width: {
        if (!item) {
            return 0;
        }
        if (item.visible === false) {
            return 0;
        }
        if (item.fillWidth) {
            return maximumWidth;
        }
        return Math.min(maximumWidth, (item.implicitWidth ? 1 : 0) * (item.implicitWidth + contentMargin * 2));
    }

    height: {
        if (!item) {
            return 0;
        }
        if (item.visible === false) {
            return 0;
        }
        if (item.fillHeight) {
            return maximumHeight;
        }
        return Math.min(maximumHeight, (item.implicitHeight ? 1 : 0) * (item.implicitHeight + contentMargin * 2));
    }

    Behavior on width {
        enabled: root.animateWidth
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.OutCubic
        }
    }

    Behavior on height {
        enabled: root.animateHeight
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        anchors.fill: parent
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
    }
}
