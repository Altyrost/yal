pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io

import "."
import "../.."
import "../../components"

BasePlugin {
    id: plugin

    pluginId: "code"
    bang: "!c"
    displayName: "Code"
    property var codeService: Service {}

    function openInCode(item) {
        if (!item || !item.path)
            return;

        codeOpener.command = ["code", item.path];
        codeOpener.startDetached();
        requestClose();
        requestClear();
    }

    function onQueryChanged(newQuery) {
        codeService.search(newQuery);
    }

    bottomView: Component {
        ResultListView {
            model: plugin.codeService.results

            onActivateRequested: function (item) {
                plugin.openInCode(item);
            }

            delegate: ResultListDelegate {
                iconSource: modelData.icon || ""
                title: modelData.path || modelData.name || modelData.id

                onActivated: function (item) {
                    plugin.openInCode(item);
                }
            }
        }
    }

    property var codeOpener: Process {}
}
