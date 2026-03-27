pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io

import "../file_search"

BaseFileSearchPlugin {
    id: plugin

    pluginId: "code"
    bang: "!c"
    displayName: "Code"
    searchMode: "dir"

    function openInCode(item) {
        if (!item || !item.path)
            return;

        codeOpener.command = ["code", item.path];
        codeOpener.startDetached();
        requestClose();
        requestClear();
    }

    function activateSearchResult(item) {
        plugin.openInCode(item);
    }

    property var codeOpener: Process {}
}
