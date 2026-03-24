pragma ComponentBehavior: Bound
import QtQuick

import "."
import "../.."
import "../../components"

BasePlugin {
    id: plugin

    pluginId: "files"
    bang: "!f"
    displayName: "File"
    property var fileService: Service {}

    function openFile(fileItem) {
        if (!fileItem || !fileItem.path)
            return;

        Qt.openUrlExternally("file://" + encodeURI(fileItem.path));
        requestClose();
        requestClear();
    }

    function onQueryChanged(newQuery) {
        fileService.search(newQuery);
    }

    bottomView: Component {
        ResultListView {
            model: plugin.fileService.results

            onActivateRequested: function (item) {
                plugin.openFile(item);
            }

            delegate: ResultListDelegate {
                iconSource: modelData.icon || ""
                title: modelData.path || modelData.name || modelData.id

                onActivated: function (item) {
                    plugin.openFile(item);
                }
            }
        }
    }
}
