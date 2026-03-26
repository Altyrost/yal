import QtQuick

QtObject {
    id: root

    signal requestInputTextUpdate(string text)

    property var registry: PluginRegistry {
        controller: root
    }
    readonly property var plugins: registry.plugins
    property int currentPluginIndex: 0
    readonly property var currentPlugin: plugins.length > 0 ? plugins[currentPluginIndex] : null
    property string query: ""

    function findPluginIndexById(pluginId) {
        for (var i = 0; i < plugins.length; ++i) {
            if (plugins[i] && plugins[i].pluginId === pluginId)
                return i;
        }

        return -1;
    }

    function switchToPluginById(pluginId, nextQuery) {
        const index = findPluginIndexById(pluginId);
        if (index < 0)
            return false;

        activatePlugin(index, nextQuery);
        return true;
    }

    function findPluginIndexByBang(bang) {
        const normalizedBang = (bang || "").trim().toLowerCase();
        if (!normalizedBang.length)
            return -1;

        for (var i = 0; i < plugins.length; ++i) {
            const plugin = plugins[i];
            if (!plugin || !plugin.bang)
                continue;

            if (plugin.bang.toLowerCase() === normalizedBang)
                return i;
        }

        return -1;
    }

    function consumeModeCommand(textValue) {
        const inputText = textValue || "";
        const match = inputText.match(/^\s*(!.*?)\s+(.*)$/i);
        if (!match)
            return false;

        const bang = (match[1] || "").toLowerCase();
        const remaining = (match[2] || "").trim();
        const targetPluginIndex = findPluginIndexByBang(bang);
        if (targetPluginIndex < 0)
            return false;

        activatePlugin(targetPluginIndex, remaining);
        return true;
    }

    function setQuery(newQuery) {
        query = newQuery || "";
        syncPluginQuery();
    }

    function syncPluginQuery() {
        if (!currentPlugin)
            return;

        currentPlugin.query = query;
        if (currentPlugin.onQueryChanged)
            currentPlugin.onQueryChanged(query);
    }

    function activatePlugin(index, nextQuery) {
        if (index < 0 || index >= plugins.length)
            return false;

        currentPluginIndex = index;

        if (typeof nextQuery === "string") {
            query = nextQuery;
            requestInputTextUpdate(query);
        }

        if (currentPlugin && currentPlugin.onActivated)
            currentPlugin.onActivated();

        syncPluginQuery();
        return true;
    }

    Component.onCompleted: {
        if (currentPlugin && currentPlugin.onActivated)
            currentPlugin.onActivated();

        syncPluginQuery();
    }
}
