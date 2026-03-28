import QtQuick
import qs.plugins.apps as Apps
import qs.plugins.code as Code
import qs.plugins.files as Files
import qs.plugins.images as Images
import qs.plugins.bangs as Bangs
import qs.plugins.calc as Calc
import qs.plugins.demo as Demo
import qs.plugins.web.google as Google
import qs.plugins.web.youtube as Youtube
import qs.plugins.web.wikipedia as Wikipedia
import qs.plugins.web.cpp as Cpp
import qs.plugins.web.qt as QtDocs

QtObject {
    id: root
    required property var controller

    readonly property list<QtObject> plugins: [
        Apps.Plugin {},
        Bangs.Plugin {
            id: bangPlugin
            availablePlugins: root.plugins
            onRequestSwitchPlugin: function (pluginId) {
                root.controller.switchToPluginById(pluginId);
            }
        },
        Code.Plugin {},
        Files.Plugin {},
        Images.Plugin {},
        Calc.Plugin {},
        Demo.Plugin {},
        Google.Plugin {},
        Youtube.Plugin {},
        Wikipedia.Plugin {},
        Cpp.Plugin {},
        QtDocs.Plugin {}
    ]
}
