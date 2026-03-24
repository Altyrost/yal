pragma ComponentBehavior: Bound
import QtQuick

import "../../.."
import ".."

BaseWebSearchPlugin {
    id: plugin

    pluginId: "cpp"
    bang: "!cpp"
    displayName: "C++"
    searchEngineName: "C++"
    searchUrlPrefix: "https://en.cppreference.com/mwiki/index.php?search="
}
