pragma ComponentBehavior: Bound
import QtQuick

import qs.plugins.file_search

BaseFileSearchPlugin {
    id: plugin

    pluginId: "files"
    bang: "!f"
    displayName: "File"
    searchMode: "any"

    function openFile(fileItem) {
        if (!fileItem || !fileItem.path)
            return;

        Qt.openUrlExternally("file://" + encodeURI(fileItem.path));
        requestClose();
        requestClear();
    }

    function activateSearchResult(item) {
        plugin.openFile(item);
    }
}
