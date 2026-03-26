pragma ComponentBehavior: Bound
import QtQuick

import "../.."
import "../../components"

BasePlugin {
    id: plugin

    pluginId: "bangs"
    bang: "!?"
    displayName: "Bangs"

    required property var availablePlugins
    signal requestSwitchPlugin(string pluginId)

    function normalizedQuery() {
        return (plugin.query || "").trim().toLowerCase();
    }

    function bangEntries() {
        const filter = normalizedQuery();
        return availablePlugins.filter(candidate => {
            if (!candidate || candidate.pluginId === plugin.pluginId || !candidate.bang)
                return false;

            if (!filter.length)
                return true;

            const haystack = (candidate.bang + " " + candidate.displayName + " " + candidate.pluginId).toLowerCase();
            return haystack.indexOf(filter) >= 0;
        }).map(candidate => {
            return {
                id: candidate.pluginId,
                pluginId: candidate.pluginId,
                bang: candidate.bang,
                name: candidate.displayName,
                title: candidate.bang + "  " + candidate.displayName
            };
        });
    }

    function activateBang(item) {
        if (!item || !item.pluginId)
            return;

        requestSwitchPlugin(item.pluginId);
    }

    bottomView: Component {
        ResultListView {
            model: plugin.bangEntries()

            onActivateRequested: function (item) {
                plugin.activateBang(item);
            }

            delegate: ResultListDelegate {
                showIcon: false
                title: modelData.title || (modelData.bang + "  " + modelData.name)

                onActivated: function (item) {
                    plugin.activateBang(item);
                }
            }
        }
    }
}
