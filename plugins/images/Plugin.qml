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

    function onQueryChanged(newQuery) {
        imageService.search(newQuery);
    }

    topView: Component {
        Item {
            implicitHeight: plugin.previewItem ? 440 : 0
            visible: implicitHeight > 0
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

    bottomView: Component {
        ResultListView {
            id: resultsView
            model: plugin.imageService.results

            function syncPreview() {
                plugin.previewItem = currentItemData();
            }

            onActivateRequested: function(item) {
                plugin.openImage(item);
            }

            Component.onCompleted: {
                syncPreview();
            }

            Connections {
                target: resultsView.view

                function onCurrentIndexChanged() {
                    resultsView.syncPreview();
                }

                function onCountChanged() {
                    resultsView.syncPreview();
                }
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
