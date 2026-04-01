pragma ComponentBehavior: Bound
import QtQuick

import qs.plugins.web

BaseWebSearchPlugin {
    id: plugin

    pluginId: "youtube"
    bang: "!yt"
    displayName: "YouTube"
    searchEngineName: "YouTube"
    searchUrlPrefix: "https://www.youtube.com/results?search_query="
}
