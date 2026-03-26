import Quickshell
import QtQuick

ShellRoot {
    QtObject {
        id: appState

        property var controller: LauncherController {}
        property int centerWidth: 720
        property int centerHeight: 80
        property int contentHeight: 360
        property int sideWidth: 220
        property int topHeight: 220
        property int gap: 10

        property var topViewItem: null
        property var leftViewItem: null
        property var rightViewItem: null
        property var bottomViewItem: null

        function centerLeft(screen) {
            return screen ? Math.max(0, Math.round((screen.width - centerWidth) / 2)) : 0;
        }

        function centerTop(screen) {
            return screen ? Math.max(0, Math.round((screen.height - centerHeight) / 2)) : 0;
        }
    }

    LauncherWindow {
        controller: appState.controller
        shellState: appState
    }

    LauncherTopWindow {
        controller: appState.controller
        shellState: appState
    }

    LauncherLeftWindow {
        controller: appState.controller
        shellState: appState
    }

    LauncherRightWindow {
        controller: appState.controller
        shellState: appState
    }

    LauncherBottomWindow {
        controller: appState.controller
        shellState: appState
    }
}
