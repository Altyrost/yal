pragma ComponentBehavior: Bound
import QtQuick

import qs
import qs.components

BasePlugin {
    id: plugin

    required property string searchEngineName
    required property string searchUrlPrefix

    function trimmedQuery() {
        return (plugin.query || "").trim();
    }

    function searchLabel() {
        const text = trimmedQuery();
        return text.length ? "Search \"" + text + "\" on " + searchEngineName : "Search on " + searchEngineName;
    }

    function searchItem() {
        return {
            id: plugin.pluginId + "-search",
            query: trimmedQuery()
        };
    }

    function openSearch(item) {
        const terms = item && item.query ? item.query : "";
        Qt.openUrlExternally(searchUrlPrefix + encodeURIComponent(terms));
        requestClose();
        requestClear();
    }

    bottomView: Component {
        ActionLineView {
            actionText: plugin.searchLabel()
            itemData: plugin.searchItem()

            onActivateRequested: function (item) {
                plugin.openSearch(item);
            }
        }
    }
}
