import Quickshell
import QtQuick
import "../components"

BasePlugin {
    id: plugin

    pluginId: "apps"
    displayName: "Apps"

    property var filteredApps: {
        const q = query.trim().toLowerCase();

        const apps = DesktopEntries.applications.values;

        if (q.length === 0) {
            return apps;
        }

        return apps.filter(app => {
            const name = (app.name || "").toLowerCase();
            const genericName = (app.genericName || "").toLowerCase();
            const exec = (app.command || []).join(" ").toLowerCase();
            const keywords = (app.keywords || []).join(" ").toLowerCase();
            const desktopId = (app.id || "").toLowerCase();

            return name.includes(q) || genericName.includes(q) || exec.includes(q) || keywords.includes(q) || desktopId.includes(q);
        });
    }

    function launchApp(app) {
        if (!app)
            return;
        app.execute();
        requestClose();
        requestClear();
    }

    bottomView: Component {
        ResultListView {
            model: plugin.filteredApps
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
        }
    }
}
