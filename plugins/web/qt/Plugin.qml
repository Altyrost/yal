pragma ComponentBehavior: Bound
import QtQuick

import "../../.."
import ".."

BaseWebSearchPlugin {
    id: plugin

    pluginId: "qt"
    bang: "!qt"
    displayName: "Qt"
    searchEngineName: "Qt"
    searchUrlPrefix: "https://doc.qt.io/qt-6/search-results.html?q="
}
