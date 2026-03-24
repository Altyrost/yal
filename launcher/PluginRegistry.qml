import QtQuick
import "plugins/apps" as Apps
import "plugins/files" as Files

QtObject {
    readonly property list<QtObject> plugins: [
        Apps.Plugin {},
        Files.Plugin {}
    ]
}
