import QtQuick
import Quickshell.Io
import ".."

BaseService {
    id: service

    // "any" searches files and directories, "dir" searches directories only,
    // and "file" searches files only.
    property string mode: "any"
    property int maxResults: 120
    property int minQueryLength: 2
    property string rootPath: "$HOME"
    property var extensionFilters: []

    property var results: []
    property var bufferedPaths: []
    property string activeQuery: ""
    property string lastRequestedQuery: ""
    property string dependencyError: ""
    property string fdBinary: ""
    property string fzfBinary: ""

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

    function typeFlags() {
        if (mode === "dir")
            return "--type d";
        if (mode === "file")
            return "--type f";

        return "";
    }

    function normalizeExtension(extension) {
        const normalized = (extension || "").trim().toLowerCase();
        if (!normalized.length)
            return "";

        return normalized.startsWith(".") ? normalized.substring(1) : normalized;
    }

    function mergeExtensions(extraExtensions) {
        const merged = [];
        const seen = {};
        const combined = (extensionFilters || []).concat(extraExtensions || []);

        for (var i = 0; i < combined.length; ++i) {
            const ext = normalizeExtension(combined[i]);
            if (!ext.length || seen[ext])
                continue;

            seen[ext] = true;
            merged.push(ext);
        }

        return merged;
    }

    function parseQuery(query) {
        const raw = (query || "").trim();
        const parts = raw.length ? raw.split(/\s+/) : [];
        const searchTerms = [];
        const inlineExtensions = [];

        for (var i = 0; i < parts.length; ++i) {
            const part = parts[i];
            const match = part.match(/^(?:ext|extension):(.+)$/i);
            if (!match) {
                searchTerms.push(part);
                continue;
            }

            const values = (match[1] || "").split(",");
            for (var j = 0; j < values.length; ++j) {
                const ext = normalizeExtension(values[j]);
                if (ext.length)
                    inlineExtensions.push(ext);
            }
        }

        return {
            searchText: searchTerms.join(" ").trim(),
            extensions: mergeExtensions(inlineExtensions)
        };
    }

    function extensionFlags(extensions) {
        if (mode === "dir" || !extensions || extensions.length === 0)
            return "";

        return extensions.map(ext => "-e " + shellQuote(ext)).join(" ");
    }

    function buildSearchCommand(query) {
        const parsed = parseQuery(query);
        const q = shellQuote(parsed.searchText);
        const limit = String(maxResults);
        const flags = typeFlags();
        const extFlags = extensionFlags(parsed.extensions);
        const matcher = parsed.searchText.length ? " | " + fzfBinary + " --filter " + q : "";

        return "" + fdBinary + " " + flags + " " + extFlags + " --hidden --exclude .git . \"" + rootPath + "\" " + matcher + " | head -n " + limit;
    }

    function executeSearch(query) {
        if (dependencyError.length) {
            return;
        }

        const q = (query || "").trim();
        const parsed = parseQuery(q);
        activeQuery = q;
        bufferedPaths = [];

        if (searcher.running)
            searcher.running = false;

        const hasExtensionFilter = parsed.extensions.length > 0;
        if ((parsed.searchText.length === 0 && !hasExtensionFilter) || (parsed.searchText.length > 0 && parsed.searchText.length < minQueryLength)) {
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
        executeSearch(q);
        return results;
    }

    property var dependencyResolver: Process {
        stdout: SplitParser {
            splitMarker: "\n"

            onRead: function (data) {
                const line = (data || "").trim();
                if (!line.length)
                    return;

                if (!service.fdBinary.length) {
                    service.fdBinary = line;
                    return;
                }

                if (!service.fzfBinary.length)
                    service.fzfBinary = line;
            }
        }

        onExited: function () {
            if (!service.fdBinary.length) {
                service.dependencyError = "Missing search tool: install `fd` or `fdfind`.";
                return;
            }

            if (!service.fzfBinary.length)
                service.dependencyError = "Missing search tool: install `fzf`.";
        }
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

        onExited: function () {
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

    Component.onCompleted: dependencyResolver.exec(["sh", "-lc", "(command -v fd || command -v fdfind) 2>/dev/null; command -v fzf 2>/dev/null"])
}
