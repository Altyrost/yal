pragma ComponentBehavior: Bound
import QtQuick

import "../.."
import "../../components"
import "../../services"

BasePlugin {
    id: plugin

    pluginId: "images"
    bang: "!i"
    displayName: "Images"

    property var imageService: FileSystemSearchService {
        mode: "file"
        extensionFilters: [
            "png",
            "jpg",
            "jpeg",
            "gif",
            "webp",
            "bmp",
            "svg",
            "avif",
            "heic",
            "heif",
            "tiff",
            "tif"
        ]
    }

    function openImage(imageItem) {
        if (!imageItem || !imageItem.path)
            return;

        Qt.openUrlExternally("file://" + encodeURI(imageItem.path));
        requestClose();
        requestClear();
    }

    function onQueryChanged(newQuery) {
        imageService.search(newQuery);
    }

    bottomView: Component {
        ResultListView {
            model: plugin.imageService.results

            onActivateRequested: function(item) {
                plugin.openImage(item);
            }

            delegate: ResultListDelegate {
                iconSource: modelData.icon || ""
                title: modelData.path || modelData.name || modelData.id

                onActivated: function(item) {
                    plugin.openImage(item);
                }
            }
        }
    }
}
