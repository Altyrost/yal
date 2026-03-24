import Quickshell
import QtQuick
import "../../"

BaseService {
    function search(query) {
        const q = (query || "").trim().toLowerCase();
        const apps = DesktopEntries.applications.values;

        if (q.length === 0)
            return apps;

        return apps.filter(app => {
            const name = (app.name || "").toLowerCase();
            const genericName = (app.genericName || "").toLowerCase();
            const exec = (app.command || []).join(" ").toLowerCase();
            const keywords = (app.keywords || []).join(" ").toLowerCase();
            const desktopId = (app.id || "").toLowerCase();

            return name.includes(q) || genericName.includes(q) || exec.includes(q) || keywords.includes(q) || desktopId.includes(q);
        });
    }
}
