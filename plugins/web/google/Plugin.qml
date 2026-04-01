pragma ComponentBehavior: Bound
import QtQuick

import qs.plugins.web

BaseWebSearchPlugin {
    id: plugin

    pluginId: "google"
    bang: "!g"
    displayName: "Google"
    searchEngineName: "Google"
    searchUrlPrefix: "https://www.google.com/search?q="
}
