import QtQuick
import "plugins/apps" as Apps
import "plugins/code" as Code
import "plugins/files" as Files
import "plugins/images" as Images
import "plugins/tools/bangs" as Bangs
import "plugins/tools/calc" as Calc
import "plugins/web/google" as Google
import "plugins/web/youtube" as Youtube
import "plugins/web/wikipedia" as Wikipedia
import "plugins/web/cpp" as Cpp
import "plugins/web/qt" as QtDocs

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
        Google.Plugin {},
        Youtube.Plugin {},
        Wikipedia.Plugin {},
        Cpp.Plugin {},
        QtDocs.Plugin {}
    ]
}
