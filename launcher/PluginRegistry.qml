import QtQuick
import "plugins"

QtObject {
    readonly property list<QtObject> plugins: [
        AppsPlugin {}
    ]
}