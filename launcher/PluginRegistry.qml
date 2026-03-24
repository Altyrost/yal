import QtQuick
import "plugins/apps" as Apps
import "plugins/code" as Code
import "plugins/files" as Files

QtObject {
    readonly property list<QtObject> plugins: [
        Apps.Plugin {},
        Code.Plugin {},
        Files.Plugin {}
    ]
}
