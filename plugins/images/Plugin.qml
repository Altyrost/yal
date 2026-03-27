pragma ComponentBehavior: Bound
import QtQuick

import "../../components"
import "../file_search"

BaseFileSearchPlugin {
    id: plugin

    pluginId: "images"
    bang: "!i"
    displayName: "Images"
    searchMode: "file"
    searchExtensionFilters: ["png", "jpg", "jpeg", "gif", "webp", "bmp", "svg", "avif", "heic", "heif", "tiff", "tif"]
    property var previewItem: null

    function imageSource(imageItem) {
        if (!imageItem || !imageItem.path)
            return "";

        return "file://" + encodeURI(imageItem.path);
    }

    function openImage(imageItem) {
        if (!imageItem || !imageItem.path)
            return;

        Qt.openUrlExternally("file://" + encodeURI(imageItem.path));
        requestClose();
        requestClear();
    }

    topView: Component {
        DirectionnalItem {
            fillWidth: true
            fillHeight: true
            visible: plugin.previewItem !== null && !plugin.dependencyError.length
            clip: true

            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                cache: false
                smooth: true
                source: plugin.imageSource(plugin.previewItem)
            }
        }
    }

    function activateSearchResult(item) {
        plugin.openImage(item);
    }

    function onSearchCurrentItemChanged(item) {
        plugin.previewItem = item;
    }

    function onSearchResultsChanged() {
        if (plugin.dependencyError.length)
            plugin.previewItem = null;
    }
}
