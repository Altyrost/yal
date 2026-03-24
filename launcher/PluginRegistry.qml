import QtQuick
import "plugins/apps" as Apps

QtObject {
    readonly property list<QtObject> plugins: [
        Apps.Plugin {}
    ]
}
