// Dashboard UI helpers shared by the admin panel and the learner dashboard:
// theme toggle, collapsible sidebar, confirmation dialog and toast messages.
// Plain JavaScript, no libraries. Loaded at the end of Site.Master.
var BinaryUI = (function () {
    var THEME_KEY = 'binary-theme';
    var SIDEBAR_KEY = 'binary-sidebar';
    var root = document.documentElement;

    function store(key, value) {
        try { localStorage.setItem(key, value); } catch (e) { /* private mode: setting just won't stick */ }
    }

    // dialogs and toasts live inside the dashboard shell so they pick up its (dark) theme
    function host() {
        return document.querySelector('.admin-shell') || document.body;
    }

    /* ---------- theme ---------- */

    function syncThemeButtons() {
        var dark = root.getAttribute('data-theme') === 'dark';
        var buttons = document.querySelectorAll('.theme-toggle');
        for (var i = 0; i < buttons.length; i++) {
            var label = dark ? 'Switch to light theme' : 'Switch to dark theme';
            buttons[i].setAttribute('aria-label', label);
            buttons[i].title = label;
            buttons[i].setAttribute('aria-pressed', dark ? 'true' : 'false');
        }
    }

    function toggleTheme() {
        var dark = root.getAttribute('data-theme') !== 'dark';
        if (dark) root.setAttribute('data-theme', 'dark');
        else root.removeAttribute('data-theme');
        store(THEME_KEY, dark ? 'dark' : 'light');
        syncThemeButtons();
    }

    /* ---------- sidebar ---------- */

    function syncSidebar() {
        var collapsed = root.classList.contains('sidebar-collapsed');
        var toggle = document.querySelector('.sidebar-toggle');
        if (toggle) {
            var label = collapsed ? 'Expand sidebar' : 'Collapse sidebar';
            toggle.setAttribute('aria-label', label);
            toggle.title = label;
            toggle.setAttribute('aria-expanded', collapsed ? 'false' : 'true');
        }
        // with only icons showing, the link text moves into a tooltip
        var items = document.querySelectorAll('.admin-nav-item');
        for (var i = 0; i < items.length; i++) {
            var text = items[i].textContent.replace(/\s+/g, ' ').trim();
            if (collapsed) {
                items[i].setAttribute('title', text);
                items[i].setAttribute('aria-label', text);
            } else if (items[i].getAttribute('title') === text) {
                items[i].removeAttribute('title');
                items[i].removeAttribute('aria-label');
            }
        }
    }

    function toggleSidebar() {
        var collapsed = root.classList.toggle('sidebar-collapsed');
        store(SIDEBAR_KEY, collapsed ? 'collapsed' : 'expanded');
        syncSidebar();
    }

    /* ---------- confirmation dialog ---------- */

    var dialog = null;
    var pending = null;
    var lastFocus = null;

    function buildDialog() {
        dialog = document.createElement('div');
        dialog.className = 'confirm-overlay';
        dialog.hidden = true;
        dialog.innerHTML =
            '<div class="confirm-box" role="alertdialog" aria-modal="true" aria-labelledby="confirmTitle" aria-describedby="confirmText">' +
                '<div class="confirm-icon" aria-hidden="true">' +
                    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>' +
                '</div>' +
                '<h3 id="confirmTitle"></h3>' +
                '<p id="confirmText"></p>' +
                '<div class="confirm-actions">' +
                    '<button type="button" class="btn btn-outline" data-action="cancel">Cancel</button>' +
                    '<button type="button" class="btn" data-action="ok"></button>' +
                '</div>' +
            '</div>';
        host().appendChild(dialog);

        dialog.addEventListener('click', function (e) {
            var action = e.target.closest ? e.target.closest('[data-action]') : null;
            if (e.target === dialog || (action && action.getAttribute('data-action') === 'cancel')) closeDialog(false);
            else if (action && action.getAttribute('data-action') === 'ok') closeDialog(true);
        });

        dialog.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') { e.preventDefault(); closeDialog(false); return; }
            if (e.key !== 'Tab') return;
            // keep focus on the two buttons while the dialog is open
            var buttons = dialog.querySelectorAll('button');
            var first = buttons[0], last = buttons[buttons.length - 1];
            if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
            else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
        });
    }

    function closeDialog(ok) {
        dialog.classList.remove('is-open');
        dialog.hidden = true;
        var target = pending;
        pending = null;
        if (ok && target) {
            // run the original button or link again, this time letting it through
            target.__binaryConfirmed = true;
            target.click();
        } else if (lastFocus && lastFocus.focus) {
            lastFocus.focus();
        }
    }

    // Usage: OnClientClick="return BinaryUI.confirm(this, { title: 'Delete this course?', text: '...', ok: 'Delete course' });"
    // The first click opens the dialog and cancels the postback; confirming clicks the element again.
    function confirm(el, options) {
        if (el && el.__binaryConfirmed) {
            el.__binaryConfirmed = false;
            return true;
        }
        options = options || {};
        if (!dialog) buildDialog();

        var danger = options.danger !== false;
        dialog.querySelector('#confirmTitle').textContent = options.title || 'Are you sure?';
        dialog.querySelector('#confirmText').textContent = options.text || '';
        dialog.querySelector('#confirmText').hidden = !options.text;
        dialog.querySelector('.confirm-box').classList.toggle('is-danger', danger);
        var okButton = dialog.querySelector('[data-action="ok"]');
        okButton.textContent = options.ok || (danger ? 'Delete' : 'Continue');
        okButton.className = 'btn ' + (danger ? 'btn-danger' : 'btn-primary');

        pending = el;
        lastFocus = document.activeElement;
        dialog.hidden = false;
        // next frame so the open transition runs
        requestAnimationFrame(function () { dialog.classList.add('is-open'); });
        dialog.querySelector('[data-action="cancel"]').focus();
        return false;
    }

    /* ---------- toasts ---------- */

    var toastStack = null;

    var TOAST_ICONS = {
        success: '<polyline points="20 6 9 17 4 12"/>',
        error: '<circle cx="12" cy="12" r="9"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>',
        info: '<circle cx="12" cy="12" r="9"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>'
    };

    function toast(message, type) {
        type = TOAST_ICONS[type] ? type : 'info';
        if (!toastStack) {
            toastStack = document.createElement('div');
            toastStack.className = 'toast-stack';
            toastStack.setAttribute('role', 'status');
            toastStack.setAttribute('aria-live', 'polite');
            host().appendChild(toastStack);
        }

        var item = document.createElement('div');
        item.className = 'toast toast-' + type;
        item.innerHTML =
            '<svg class="toast-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.25" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + TOAST_ICONS[type] + '</svg>' +
            '<span class="toast-text"></span>' +
            '<button type="button" class="toast-close" aria-label="Dismiss">' +
                '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>' +
            '</button>';
        item.querySelector('.toast-text').textContent = message;
        toastStack.appendChild(item);
        requestAnimationFrame(function () { item.classList.add('is-visible'); });

        var timer = setTimeout(dismiss, type === 'error' ? 7000 : 4000);
        item.addEventListener('mouseenter', function () { clearTimeout(timer); });
        item.addEventListener('mouseleave', function () { timer = setTimeout(dismiss, 2000); });
        item.querySelector('.toast-close').addEventListener('click', dismiss);

        function dismiss() {
            clearTimeout(timer);
            item.classList.remove('is-visible');
            setTimeout(function () { if (item.parentNode) item.parentNode.removeChild(item); }, 200);
        }
    }

    // Server-rendered success messages in the dashboards become toasts. Errors stay inline next to
    // the form they belong to, and are scrolled into view so they aren't missed.
    function promoteAlerts() {
        var shell = document.querySelector('.admin-shell');
        if (!shell) return;

        var successes = shell.querySelectorAll('.auth-alert-success');
        for (var i = 0; i < successes.length; i++) {
            var text = successes[i].textContent.replace(/\s+/g, ' ').trim();
            if (!text) continue;
            toast(text, 'success');
            successes[i].hidden = true;
        }

        var error = shell.querySelector('.auth-alert-error');
        if (error && error.textContent.trim() && error.offsetParent !== null) {
            error.setAttribute('role', 'alert');
            error.scrollIntoView({ block: 'center' });
        }

        // drop ?msg=... so a refresh doesn't show the same toast again
        if (window.history && history.replaceState && /[?&]msg=/.test(location.search)) {
            var query = location.search.replace(/^\?/, '').split('&').filter(function (p) { return p && p.indexOf('msg=') !== 0; }).join('&');
            history.replaceState(null, '', location.pathname + (query ? '?' + query : '') + location.hash);
        }
    }

    function init() {
        syncThemeButtons();
        syncSidebar();
        promoteAlerts();
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();

    return { toggleTheme: toggleTheme, toggleSidebar: toggleSidebar, confirm: confirm, toast: toast };
})();
