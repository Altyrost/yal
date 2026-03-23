import QtQuick

QtObject {
    required property string id
    required property string displayName
    property string query: ""

    property Component topComponent: null
    property Component leftComponent: null
    property Component rightComponent: null
    property Component bottomComponent: null

    function onActivated() {}
    function onQueryChanged(newQuery) {
        query = newQuery
    }
}