import QtQuick
import "plugins/apps" as Apps
import "plugins/code" as Code
import "plugins/files" as Files
import "plugins/images" as Images
import "plugins/tools/calc" as Calc
import "plugins/web/google" as Google
import "plugins/web/youtube" as Youtube
import "plugins/web/wikipedia" as Wikipedia
import "plugins/web/cpp" as Cpp
import "plugins/web/qt" as QtDocs

QtObject {
    readonly property list<QtObject> plugins: [
        Apps.Plugin {},
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
