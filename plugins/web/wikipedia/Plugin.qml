pragma ComponentBehavior: Bound
import QtQuick

import qs.plugins.web

BaseWebSearchPlugin {
    id: plugin

    pluginId: "wikipedia"
    bang: "!w"
    displayName: "Wikipedia"
    searchEngineName: "Wikipedia"
    searchUrlPrefix: "https://en.wikipedia.org/w/index.php?search="
}
