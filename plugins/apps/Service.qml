import Quickshell
import QtQuick

import qs

BaseService {
    function search(query) {
        const q = (query || "").trim().toLowerCase();
        const apps = DesktopEntries.applications.values;

        if (q.length === 0)
            return apps;

        return apps.filter(app => {
            const name = (app.name || "").toLowerCase();
            return name.includes(q);
        });
    }
}
