pragma ComponentBehavior: Bound
import QtQuick

import "../../.."
import ".."

BaseWebSearchPlugin {
    id: plugin

    pluginId: "youtube"
    bang: "!yt"
    displayName: "YouTube"
    searchEngineName: "YouTube"
    searchUrlPrefix: "https://www.youtube.com/results?search_query="
}
