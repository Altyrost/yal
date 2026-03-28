pragma ComponentBehavior: Bound
import QtQuick

import qs
import qs.components
import qs.services

BasePlugin {
    id: plugin

    property string searchMode: "any"
    property var searchExtensionFilters: []
    property int searchDebounceInterval: 70
    property string pendingSearchQuery: ""
    readonly property var searchService: fileSearchService
    readonly property string dependencyError: fileSearchService.dependencyError

    function activateSearchResult(item) {
    }

    function currentSearchItemData() {
        return resultsViewItem ? resultsViewItem.currentItemData() : null;
    }

    function onSearchCurrentItemChanged(item) {
    }

    function onSearchResultsChanged() {
    }

    function onQueryChanged(newQuery) {
        pendingSearchQuery = newQuery;
        searchDebounce.restart();
    }

    property Component dependencyErrorView: Component {
        ActionLineView {
            actionText: plugin.dependencyError
        }
    }

    property Component defaultResultsView: Component {
        ResultListView {
            id: resultsView
            model: plugin.searchService.results

            onActivateRequested: function (item) {
                plugin.activateSearchResult(item);
            }

            Component.onCompleted: {
                plugin.onSearchCurrentItemChanged(currentItemData());
            }

            Connections {
                target: resultsView.view

                function onCurrentIndexChanged() {
                    plugin.onSearchCurrentItemChanged(resultsView.currentItemData());
                }

                function onCountChanged() {
                    plugin.onSearchResultsChanged();
                    plugin.onSearchCurrentItemChanged(resultsView.currentItemData());
                }
            }

            delegate: ResultListDelegate {
                iconSource: modelData.icon || ""
                title: modelData.path || modelData.name || modelData.id

                onActivated: function (item) {
                    plugin.activateSearchResult(item);
                }
            }
        }
    }

    bottomView: plugin.dependencyError.length ? dependencyErrorView : defaultResultsView
    readonly property var resultsViewItem: bottomViewItem

    property var searchDebounce: Timer {
        interval: plugin.searchDebounceInterval
        repeat: false

        onTriggered: plugin.searchService.search(plugin.pendingSearchQuery)
    }

    property var fileSearchService: FileSystemSearchService {
        mode: plugin.searchMode
        extensionFilters: plugin.searchExtensionFilters
    }
}
