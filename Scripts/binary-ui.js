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

    var switchTimer = null;

    function applyTheme(dark, animate) {
        if ((root.getAttribute('data-theme') === 'dark') === dark) { syncThemeButtons(); return; }
        if (animate) {
            // fade colours for a moment; removed again so normal hovers keep their own timing
            root.classList.add('theme-switching');
            clearTimeout(switchTimer);
            switchTimer = setTimeout(function () { root.classList.remove('theme-switching'); }, 300);
        }
        if (dark) root.setAttribute('data-theme', 'dark');
        else root.removeAttribute('data-theme');
        syncThemeButtons();
    }

    function savedThemeIsDark() {
        try { return localStorage.getItem(THEME_KEY) === 'dark'; } catch (e) { return root.getAttribute('data-theme') === 'dark'; }
    }

    function toggleTheme() {
        var dark = root.getAttribute('data-theme') !== 'dark';
        store(THEME_KEY, dark ? 'dark' : 'light');
        applyTheme(dark, true);
    }

    // another tab switched the theme: follow it
    window.addEventListener('storage', function (e) {
        if (e.key === THEME_KEY) applyTheme(e.newValue === 'dark', true);
        if (e.key === SIDEBAR_KEY) {
            root.classList.toggle('sidebar-collapsed', e.newValue === 'collapsed');
            syncSidebar();
        }
    });

    // pages restored by the Back button come from memory with the theme they were left in
    window.addEventListener('pageshow', function (e) {
        if (e.persisted) applyTheme(savedThemeIsDark(), false);
    });

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

    /* ---------- filterable lists ---------- */

    // Instant search / filter / sort / paging for a server-rendered table, with no postback.
    // The state lives in the address bar (?q=...&cat=...&page=2), so a reload, the back button or
    // a redirect after Save/Delete shows exactly the filters on screen, never an older search.
    //
    // Markup contract (all inside the element with data-list="name"):
    //   [data-filter-key="q"]        search box, matched against each row's data-search
    //   [data-filter-key="cat"]      a select, matched against each row's data-f-cat
    //   [data-sort-key="sort"]       a select with values like "xp:desc"; rows carry data-s-xp
    //   tr[data-row]                 the rows
    //   [data-list-body]             hidden when nothing matches ([data-list-empty] is shown instead)
    //   [data-list-summary] + [data-list-summary-text] + [data-list-clear]
    //   [data-list-page-info], [data-list-prev], [data-list-next]
    // Elsewhere on the page, data-list-set="name:cat=3" makes any button set a filter (click again to clear).
    function setUrlParams(values, defaults) {
        var params = new URLSearchParams(location.search);
        for (var key in values) {
            if (values[key] && values[key] !== defaults[key]) params.set(key, values[key]);
            else params.delete(key);
        }
        params.delete('msg');
        var query = params.toString();
        var url = location.pathname + (query ? '?' + query : '') + location.hash;
        if (url === location.pathname + location.search + location.hash) return;
        history.replaceState(null, '', url);
        // WebForms posts back to the URL the page was loaded with; keep that in step too, so the
        // redirect after Publish / Delete / Rename comes back to these filters, not the first ones
        if (document.forms[0]) document.forms[0].action = url;
    }

    function initList(box) {
        var name = box.getAttribute('data-list');
        var pageSize = parseInt(box.getAttribute('data-page-size'), 10) || 10;
        var noun = box.getAttribute('data-noun') || 'item';
        var nouns = box.getAttribute('data-noun-plural') || noun + 's';
        var controls = box.querySelectorAll('[data-filter-key], [data-sort-key]');
        var rows = Array.prototype.slice.call(box.querySelectorAll('tr[data-row]'));
        var tbody = rows.length ? rows[0].parentNode : null;
        var page = 1;
        var defaults = { page: '1' };

        function keyOf(el) { return el.getAttribute('data-filter-key') || el.getAttribute('data-sort-key'); }

        for (var i = 0; i < controls.length; i++) {
            var c = controls[i];
            // the first option of a sort select is the default order; everything else defaults to "any"
            defaults[keyOf(c)] = c.hasAttribute('data-sort-key') && c.options && c.options.length ? c.options[0].value : '';
            c.setAttribute('autocomplete', 'off');
        }

        function read() {
            var state = {};
            for (var i = 0; i < controls.length; i++) state[keyOf(controls[i])] = controls[i].value.trim();
            return state;
        }

        function sortRows(sortValue) {
            if (!sortValue || !tbody) return;
            var parts = sortValue.split(':'), field = 'data-s-' + parts[0], desc = parts[1] === 'desc';
            rows.sort(function (a, b) {
                var x = a.getAttribute(field) || '', y = b.getAttribute(field) || '';
                var nx = parseFloat(x), ny = parseFloat(y);
                var cmp = (!isNaN(nx) && !isNaN(ny)) ? nx - ny : x.localeCompare(y, undefined, { sensitivity: 'base' });
                return desc ? -cmp : cmp;
            });
            for (var i = 0; i < rows.length; i++) tbody.appendChild(rows[i]);
        }

        function apply(keepPage) {
            var state = read();
            if (!keepPage) page = 1;

            var sortKey = null;
            for (var i = 0; i < controls.length; i++) if (controls[i].hasAttribute('data-sort-key')) sortKey = keyOf(controls[i]);
            if (sortKey) sortRows(state[sortKey]);

            var q = (state.q || '').toLowerCase();
            var matches = rows.filter(function (row) {
                if (q && (row.getAttribute('data-search') || '').indexOf(q) === -1) return false;
                for (var key in state) {
                    if (key === 'q' || key === sortKey || !state[key]) continue;
                    if (row.getAttribute('data-f-' + key) !== state[key]) return false;
                }
                return true;
            });

            var pages = Math.max(1, Math.ceil(matches.length / pageSize));
            page = Math.min(Math.max(1, page), pages);
            var first = (page - 1) * pageSize;
            for (var r = 0; r < rows.length; r++) rows[r].hidden = true;
            for (var m = first; m < Math.min(first + pageSize, matches.length); m++) matches[m].hidden = false;

            var filtered = false;
            for (var k in state) if (k !== sortKey && state[k]) filtered = true;

            var body = box.querySelector('[data-list-body]');
            var empty = box.querySelector('[data-list-empty]');
            if (body) body.hidden = matches.length === 0;
            if (empty) empty.hidden = matches.length > 0;

            var info = box.querySelector('[data-list-page-info]');
            if (info) info.textContent = 'Page ' + page + ' of ' + pages + ' (' + matches.length + ' ' + (matches.length === 1 ? noun : nouns) + ')';
            var prev = box.querySelector('[data-list-prev]'), next = box.querySelector('[data-list-next]');
            if (prev) prev.disabled = page <= 1;
            if (next) next.disabled = page >= pages;

            var summary = box.querySelector('[data-list-summary]');
            if (summary) {
                summary.hidden = !filtered;
                var text = summary.querySelector('[data-list-summary-text]');
                if (text) text.textContent = matches.length + ' of ' + rows.length + ' ' + (rows.length === 1 ? noun : nouns) + ' match';
            }

            var setters = document.querySelectorAll('[data-list-set^="' + name + ':"]');
            for (var s = 0; s < setters.length; s++) {
                var pair = setters[s].getAttribute('data-list-set').split(':')[1].split('=');
                var on = state[pair[0]] === pair[1];
                (setters[s].closest('[data-list-set-scope]') || setters[s]).classList.toggle('is-active', on);
                setters[s].setAttribute('aria-pressed', on ? 'true' : 'false');
            }

            state.page = String(page);
            setUrlParams(state, defaults);
        }

        // start from the address bar, not from whatever the browser restored into the fields
        var params = new URLSearchParams(location.search);
        for (var j = 0; j < controls.length; j++) {
            var key = keyOf(controls[j]);
            var value = params.get(key) || defaults[key];
            controls[j].value = value;
            if (controls[j].value !== value) controls[j].value = defaults[key];   // stale option
        }
        page = parseInt(params.get('page'), 10) || 1;

        var timer = null;
        box.addEventListener('input', function (e) {
            if (!e.target.hasAttribute('data-filter-key') || e.target.tagName === 'SELECT') return;
            clearTimeout(timer);
            timer = setTimeout(function () { apply(false); }, 120);
        });
        box.addEventListener('change', function (e) {
            if (e.target.tagName === 'SELECT' && (e.target.hasAttribute('data-filter-key') || e.target.hasAttribute('data-sort-key'))) apply(false);
        });
        box.addEventListener('keydown', function (e) {
            // Enter in the search box would submit the whole WebForms page
            if (e.key === 'Enter' && e.target.hasAttribute('data-filter-key')) e.preventDefault();
        });
        box.addEventListener('click', function (e) {
            var btn = e.target.closest ? e.target.closest('[data-list-prev], [data-list-next], [data-list-clear]') : null;
            if (!btn) return;
            e.preventDefault();
            if (btn.hasAttribute('data-list-clear')) {
                for (var i = 0; i < controls.length; i++) {
                    if (controls[i].hasAttribute('data-filter-key')) controls[i].value = '';
                }
                apply(false);
                return;
            }
            page += btn.hasAttribute('data-list-next') ? 1 : -1;
            apply(true);
            box.scrollIntoView({ block: 'start', behavior: 'smooth' });
        });

        document.addEventListener('click', function (e) {
            var setter = e.target.closest ? e.target.closest('[data-list-set^="' + name + ':"]') : null;
            if (!setter) return;
            e.preventDefault();
            var pair = setter.getAttribute('data-list-set').split(':')[1].split('=');
            var control = box.querySelector('[data-filter-key="' + pair[0] + '"]');
            if (!control) return;
            control.value = control.value === pair[1] ? '' : pair[1];
            apply(false);
        });

        apply(true);
    }

    function initLists() {
        var lists = document.querySelectorAll('[data-list]');
        for (var i = 0; i < lists.length; i++) initList(lists[i]);
    }

    function init() {
        syncThemeButtons();
        syncSidebar();
        promoteAlerts();
        initLists();
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();

    return { toggleTheme: toggleTheme, toggleSidebar: toggleSidebar, confirm: confirm, toast: toast };
})();
