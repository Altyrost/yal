pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

import "."
import "../.."
import "../../components"

BasePlugin {
    id: plugin

    pluginId: "apps"
    bang: "!a"
    displayName: "Apps"

    function launchApp(app) {
        if (!app)
            return;
        app.execute();
        requestClose();
        requestClear();
    }

    bottomView: ResultListView {
        model: appService.search(plugin.query)
        onActivateRequested: function (item) {
            plugin.launchApp(item);
        }

        delegate: ResultListDelegate {
            iconSource: Quickshell.iconPath(modelData.icon || "", true)
            title: modelData.name || modelData.id
            onActivated: function (item) {
                plugin.launchApp(item);
            }
        }

        Service {
            id: appService
        }
    }
}
