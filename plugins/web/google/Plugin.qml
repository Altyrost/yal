pragma ComponentBehavior: Bound
import QtQuick

import "../../.."
import ".."

BaseWebSearchPlugin {
    id: plugin

    pluginId: "google"
    bang: "!g"
    displayName: "Google"
    searchEngineName: "Google"
    searchUrlPrefix: "https://www.google.com/search?q="
}
