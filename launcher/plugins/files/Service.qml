import QtQuick
import Quickshell.Io
import "../../"

BaseService {
    id: service

    property int maxResults: 120
    property int minQueryLength: 2

    property var results: []
    property var bufferedPaths: []
    property string pendingQuery: ""
    property string activeQuery: ""
    property string lastRequestedQuery: ""

    function shellQuote(value) {
        const raw = value || "";
        return "'" + raw.replace(/'/g, "'\"'\"'") + "'";
    }

    function basename(path) {
        const normalized = path || "";
        const slash = normalized.lastIndexOf("/");
        return slash >= 0 ? normalized.substring(slash + 1) : normalized;
    }

    function toItem(path) {
        return {
            name: basename(path),
            id: path,
            path: path,
            icon: null
        };
    }

    function buildSearchCommand(query) {
        const q = shellQuote(query);
        const limit = String(maxResults);

        return "" + "fd --hidden --exclude .git . \"$HOME\" " + "| fzf --filter " + q + " " + "| head -n " + limit;
    }

    function executeSearch(query) {
        const q = (query || "").trim();
        activeQuery = q;
        bufferedPaths = [];

        if (searcher.running)
            searcher.running = false;

        if (q.length === 0 || q.length < minQueryLength) {
            results = [];
            return;
        }

        searcher.exec(["sh", "-lc", buildSearchCommand(q)]);
    }

    function search(query) {
        const q = (query || "").trim().toLowerCase();
        if (q === lastRequestedQuery)
            return results;

        lastRequestedQuery = q;
        pendingQuery = q;
        debounce.restart();
        return results;
    }

    property var debounce: Timer {
        interval: 70
        repeat: false

        onTriggered: service.executeSearch(service.pendingQuery)
    }

    property var searcher: Process {
        stdout: SplitParser {
            splitMarker: "\n"

            onRead: function (data) {
                const path = (data || "").trim();
                if (path.length === 0)
                    return;

                if (service.bufferedPaths.length >= service.maxResults)
                    return;

                service.bufferedPaths.push(path);
            }
        }

        onExited: function (exitCode, exitStatus) {
            if (service.activeQuery !== service.lastRequestedQuery)
                return;

            const uniquePaths = [];
            const seen = {};
            for (var i = 0; i < service.bufferedPaths.length; ++i) {
                const path = service.bufferedPaths[i];
                if (seen[path])
                    continue;

                seen[path] = true;
                uniquePaths.push(path);
            }

            service.results = uniquePaths.map(path => service.toItem(path));
        }
    }
}
