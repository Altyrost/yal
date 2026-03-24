import QtQuick
import "plugins/apps" as Apps
import "plugins/code" as Code
import "plugins/files" as Files
import "plugins/images" as Images

QtObject {
    readonly property list<QtObject> plugins: [
        Apps.Plugin {},
        Code.Plugin {},
        Files.Plugin {},
        Images.Plugin {}
    ]
}
