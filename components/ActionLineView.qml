pragma ComponentBehavior: Bound

import QtQuick

ResultListView {
    id: root

    property string actionText: ""
    property var itemData: ({})

    model: [root.itemData]

    delegate: ResultListDelegate {
        showIcon: false
        title: root.actionText

        onActivated: function (item) {
            root.activateRequested(item);
        }
    }
}
