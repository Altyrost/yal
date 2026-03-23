import QtQuick

QtObject {
    property string pluginId: ""
    required property string displayName
    property string query: ""

    property Component topView: null
    property Component leftView: null
    property Component rightView: null
    property Component bottomView: null

    signal requestClose
    signal requestClear

    function dispatchKeyToViews(event, views) {
        if (!event || !views)
            return false;

        for (var i = 0; i < views.length; ++i) {
            var view = views[i];
            if (!view || !view.handleKey)
                continue;

            view.handleKey(event);
            if (event.accepted)
                return true;
        }

        return event.accepted === true;
    }

    function handleKey(event, views) {
        if (!views)
            return;

        dispatchKeyToViews(event, [views.top, views.left, views.right, views.bottom]);
    }

    function onActivated() {}

    function onQueryChanged(newQuery) {
        query = newQuery
    }
}
