pragma ComponentBehavior: Bound
import QtQuick

import qs.plugins.web

BaseWebSearchPlugin {
    id: plugin

    pluginId: "cpp"
    bang: "!cpp"
    displayName: "C++"
    searchEngineName: "C++"
    searchUrlPrefix: "https://en.cppreference.com/mwiki/index.php?search="
}
