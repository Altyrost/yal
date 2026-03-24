pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

import "../../.."
import "../../../components"

BasePlugin {
    id: plugin

    pluginId: "calc"
    bang: "!="
    displayName: "Calc"
    readonly property string expressionText: trimmedQuery()
    readonly property var evaluation: evaluateExpression(expressionText)

    function trimmedQuery() {
        return (plugin.query || "").trim();
    }

    function normalizedExpression(query) {
        return (query || "")
            .replace(/,/g, ".")
            .replace(/×/g, "*")
            .replace(/÷/g, "/")
            .replace(/\bpi\b/gi, "Math.PI")
            .replace(/\be\b/g, "Math.E")
            .replace(/\babs\b/gi, "Math.abs")
            .replace(/\bsqrt\b/gi, "Math.sqrt")
            .replace(/\bsin\b/gi, "Math.sin")
            .replace(/\bcos\b/gi, "Math.cos")
            .replace(/\btan\b/gi, "Math.tan")
            .replace(/\bpow\b/gi, "Math.pow")
            .replace(/\blog\b/gi, "Math.log")
            .replace(/\bexp\b/gi, "Math.exp")
            .replace(/\bfloor\b/gi, "Math.floor")
            .replace(/\bceil\b/gi, "Math.ceil")
            .replace(/\bround\b/gi, "Math.round")
            .replace(/\bmin\b/gi, "Math.min")
            .replace(/\bmax\b/gi, "Math.max");
    }

    function isAllowedExpression(expression) {
        return /^[0-9\s+\-*/%().,]*([A-Za-z_][A-Za-z0-9_\.(),\s+\-*/%]*)?$/.test(expression)
            && !/[=;:{}\[\]\\'"`?]/.test(expression)
            && expression.indexOf("Math.Math") === -1;
    }

    function evaluateExpression(query) {
        const trimmed = (query || "").trim();
        const expression = normalizedExpression(trimmed);

        if (!trimmed.length) {
            return {
                text: "Type an expression",
                value: null,
                isValid: false
            };
        }

        if (!isAllowedExpression(expression)) {
            return {
                text: "Invalid expression",
                value: null,
                isValid: false
            };
        }

        try {
            const result = Function("\"use strict\"; return (" + expression + ");")();
            if (typeof result !== "number" || !isFinite(result))
                throw new Error("Invalid expression");

            return {
                text: trimmed + " = " + result,
                value: result,
                isValid: true
            };
        } catch (error) {
            return {
                text: "Invalid expression",
                value: null,
                isValid: false
            };
        }
    }

    function resultItem() {
        return {
            id: "calc-result",
            value: evaluation.value,
            isValid: evaluation.isValid
        };
    }

    function activateResult(item) {
        if (!item || !item.isValid)
            return;

        Quickshell.clipboardText = String(item.value);
        requestClose();
        requestClear();
    }

    bottomView: Component {
        ActionLineView {
            actionText: plugin.evaluation.text
            itemData: plugin.resultItem()

            onActivateRequested: function(item) {
                plugin.activateResult(item);
            }
        }
    }
}
