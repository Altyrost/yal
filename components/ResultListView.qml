import QtQuick

Rectangle {
    id: root
    color: "transparent"

    property alias model: listView.model
    property alias delegate: listView.delegate
    property alias view: listView
    property bool autoSelectFirst: true
    signal activateRequested(var item)

    function currentItemData() {
        if (!model || listView.currentIndex < 0 || listView.currentIndex >= listView.count)
            return null;

        if (typeof model.get === "function")
            return model.get(listView.currentIndex);

        return model[listView.currentIndex];
    }

    function handleKey(event) {
        if (!event)
            return;

        switch (event.key) {
        case Qt.Key_Up:
            if (listView.count <= 0)
                return;

            listView.currentIndex = Math.max(0, listView.currentIndex - 1);
            event.accepted = true;
            break;
        case Qt.Key_Down:
            if (listView.count <= 0)
                return;

            listView.currentIndex = Math.min(listView.count - 1, listView.currentIndex + 1);
            event.accepted = true;
            break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
            var item = currentItemData();
            if (!item)
                return;

            activateRequested(item);
            event.accepted = true;
            break;
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        spacing: 6
        focus: true
        currentIndex: root.autoSelectFirst && count > 0 ? 0 : -1

        onCountChanged: {
            if (root.autoSelectFirst)
                currentIndex = count > 0 ? 0 : -1;
        }

        onCurrentIndexChanged: {
            if (currentIndex >= 0)
                positionViewAtIndex(currentIndex, ListView.Contain);
        }
    }
}
