pragma ComponentBehavior: Bound
import QtQuick

import qs.plugins.web

BaseWebSearchPlugin {
    id: plugin

    pluginId: "qt"
    bang: "!qt"
    displayName: "Qt"
    searchEngineName: "Qt"
    searchUrlPrefix: "https://doc.qt.io/qt-6/search-results.html?q="
}
