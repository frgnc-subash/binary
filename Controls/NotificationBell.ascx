<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NotificationBell.ascx.cs" Inherits="binary.Controls.NotificationBell" EnableViewState="false" %>

<button type="button" class="admin-icon-btn notif-bell" id="notifBellBtn" onclick="binaryNotifications.open()" title="Notifications" aria-label="Notifications" aria-haspopup="dialog" aria-controls="notifDrawer" aria-expanded="false">
    <svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"></path><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"></path></svg>
    <asp:PlaceHolder ID="phUnreadDot" runat="server" Visible="false"><span class="admin-notification-dot" id="notifDot"></span></asp:PlaceHolder>
</button>

<div class="notif-backdrop" id="notifBackdrop" onclick="binaryNotifications.close()"></div>

<aside class="notif-drawer" id="notifDrawer" role="dialog" aria-modal="true" aria-labelledby="notifDrawerTitle" aria-hidden="true" tabindex="-1"
       data-unread="<%= UnreadCount %>" data-endpoint="<%= ResolveUrl("~/Handlers/Notifications.ashx") %>">
    <header class="notif-drawer-header">
        <div>
            <h3 id="notifDrawerTitle">Notifications</h3>
            <p class="notif-drawer-sub" id="notifUnreadLabel"><asp:Literal ID="litUnreadLabel" runat="server" /></p>
        </div>
        <div class="notif-header-actions">
            <button type="button" class="notif-mark-all" id="notifMarkAllBtn" onclick="binaryNotifications.markAllRead()" <%= UnreadCount > 0 ? "" : "hidden" %>>Mark all read</button>
            <button type="button" class="notif-close" onclick="binaryNotifications.close()" aria-label="Close notifications">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
        </div>
    </header>

    <div class="notif-tabs" role="tablist">
        <button type="button" class="notif-tab is-active" id="notifTabInbox" role="tab" aria-selected="true" aria-controls="notifInboxPanel" onclick="binaryNotifications.showTab('inbox')">
            Inbox <span class="notif-tab-count" id="notifInboxCount" <%= UnreadCount > 0 ? "" : "hidden" %>><%= UnreadCount %></span>
        </button>
        <button type="button" class="notif-tab" id="notifTabArchived" role="tab" aria-selected="false" aria-controls="notifArchivedPanel" onclick="binaryNotifications.showTab('archived')">
            Archived
        </button>
    </div>

    <div class="notif-list" id="notifInboxPanel" role="tabpanel" aria-labelledby="notifTabInbox">
        <div id="notifInboxList">
            <asp:Repeater ID="rptInbox" runat="server">
                <ItemTemplate><%# RenderItem(Container.DataItem, true) %></ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="notif-empty" id="notifInboxEmpty" <%= InboxCount > 0 ? "hidden" : "" %>>
            <div class="notif-empty-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"></path><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"></path></svg>
            </div>
            <h4>Your inbox is clear</h4>
            <p>Enrollments, quiz results, and new titles will show up here.</p>
        </div>
    </div>

    <div class="notif-list" id="notifArchivedPanel" role="tabpanel" aria-labelledby="notifTabArchived" hidden>
        <div id="notifArchivedList">
            <asp:Repeater ID="rptArchived" runat="server">
                <ItemTemplate><%# RenderItem(Container.DataItem, false) %></ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="notif-empty" id="notifArchivedEmpty" <%= ArchivedCount > 0 ? "hidden" : "" %>>
            <div class="notif-empty-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="20" height="5" rx="1"></rect><path d="M4 8v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8"></path><line x1="10" y1="12" x2="14" y2="12"></line></svg>
            </div>
            <h4>Nothing archived</h4>
            <p>Archive notifications to tidy your inbox. They'll be kept here.</p>
        </div>
    </div>
</aside>

<div class="notif-toast-stack" id="notifToastStack" aria-live="polite"></div>

<script>
    var binaryNotifications = (function () {
        var drawer = document.getElementById('notifDrawer');
        var backdrop = document.getElementById('notifBackdrop');
        var toastStack = document.getElementById('notifToastStack');
        var bell = document.getElementById('notifBellBtn');
        var inboxList = document.getElementById('notifInboxList');
        var archivedList = document.getElementById('notifArchivedList');
        var endpoint = drawer.getAttribute('data-endpoint');
        var unread = parseInt(drawer.getAttribute('data-unread'), 10) || 0;
        var lastFocus = null;

        // position:fixed breaks inside transformed/filtered ancestors, so render these at the body root
        document.body.appendChild(backdrop);
        document.body.appendChild(drawer);
        document.body.appendChild(toastStack);

        // keepalive lets "mark as read" finish even when the click also navigates away
        function post(action, id, keepalive) {
            var body = new FormData();
            body.append('action', action);
            if (id) body.append('id', id);
            return fetch(endpoint, {
                method: 'POST',
                credentials: 'same-origin',
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                body: body,
                keepalive: !!keepalive
            }).then(function (res) {
                if (!res.ok) throw new Error('HTTP ' + res.status);
            });
        }

        function refreshState() {
            document.getElementById('notifUnreadLabel').textContent =
                unread > 0 ? unread + ' unread' : "You're all caught up";

            var countPill = document.getElementById('notifInboxCount');
            countPill.textContent = unread;
            countPill.hidden = unread === 0;
            document.getElementById('notifMarkAllBtn').hidden = unread === 0;

            var dot = document.getElementById('notifDot');
            if (dot && unread === 0) dot.parentNode.removeChild(dot);

            document.getElementById('notifInboxEmpty').hidden = !!inboxList.querySelector('.notif-item');
            document.getElementById('notifArchivedEmpty').hidden = !!archivedList.querySelector('.notif-item');
        }

        function setRead(item) {
            if (!item.classList.contains('notif-item-unread')) return false;
            item.classList.remove('notif-item-unread');
            unread = Math.max(0, unread - 1);
            return true;
        }

        function markRead(item, keepalive) {
            if (!setRead(item)) return;
            refreshState();
            post('markread', item.getAttribute('data-id'), keepalive).catch(function () { });
        }

        function moveItem(item, toArchive) {
            var from = toArchive ? inboxList : archivedList;
            var to = toArchive ? archivedList : inboxList;
            var wasUnread = toArchive && setRead(item);   // archiving marks it read server-side too
            to.insertBefore(item, to.firstChild);
            refreshState();

            post(toArchive ? 'archive' : 'unarchive', item.getAttribute('data-id')).catch(function () {
                // put it back so the UI never claims a change the server didn't make
                from.insertBefore(item, from.firstChild);
                if (wasUnread) { item.classList.add('notif-item-unread'); unread++; }
                refreshState();
            });
        }

        function markAllRead() {
            var items = inboxList.querySelectorAll('.notif-item-unread');
            for (var i = 0; i < items.length; i++) items[i].classList.remove('notif-item-unread');
            unread = 0;
            refreshState();
            post('markallread').catch(function () { });
        }

        drawer.addEventListener('click', function (e) {
            var action = e.target.closest('.notif-action');
            if (action) {
                e.preventDefault();
                var item = action.closest('.notif-item');
                var name = action.getAttribute('data-action');
                if (name === 'markread') markRead(item);
                else if (name === 'archive') moveItem(item, true);
                else if (name === 'unarchive') moveItem(item, false);
                return;
            }
            // opening a notification counts as reading it
            var link = e.target.closest('a.notif-link');
            if (link) markRead(link.closest('.notif-item'), true);
        });

        function showTab(name) {
            var archived = name === 'archived';
            document.getElementById('notifInboxPanel').hidden = archived;
            document.getElementById('notifArchivedPanel').hidden = !archived;
            var inboxTab = document.getElementById('notifTabInbox');
            var archivedTab = document.getElementById('notifTabArchived');
            inboxTab.classList.toggle('is-active', !archived);
            archivedTab.classList.toggle('is-active', archived);
            inboxTab.setAttribute('aria-selected', archived ? 'false' : 'true');
            archivedTab.setAttribute('aria-selected', archived ? 'true' : 'false');
        }

        function open() {
            lastFocus = document.activeElement;
            document.body.classList.add('notif-open');
            backdrop.classList.add('is-open');
            drawer.classList.add('is-open');
            drawer.setAttribute('aria-hidden', 'false');
            bell.setAttribute('aria-expanded', 'true');
            drawer.focus();
            clearToasts();
        }

        function close() {
            document.body.classList.remove('notif-open');
            backdrop.classList.remove('is-open');
            drawer.classList.remove('is-open');
            drawer.setAttribute('aria-hidden', 'true');
            bell.setAttribute('aria-expanded', 'false');
            if (lastFocus && lastFocus.focus) lastFocus.focus();
        }

        function readToasted() {
            try { return JSON.parse(sessionStorage.getItem('bnToastedIds') || '[]'); } catch (e) { return []; }
        }

        // pops recent unread notifications (e.g. a new title you just earned) in from the right, once each
        function showToasts() {
            var toasted = readToasted();
            var fresh = inboxList.querySelectorAll('.notif-item[data-fresh="1"]');
            var shown = 0;

            for (var i = 0; i < fresh.length && shown < 3; i++) {
                var id = fresh[i].getAttribute('data-id');
                if (toasted.indexOf(id) !== -1) continue;
                toasted.push(id);
                spawnToast(fresh[i], shown);
                shown++;
            }

            try { sessionStorage.setItem('bnToastedIds', JSON.stringify(toasted.slice(-50))); } catch (e) { }
        }

        function spawnToast(item, index) {
            var toast = document.createElement('button');
            toast.type = 'button';
            toast.className = 'notif-toast';
            toast.style.animationDelay = (index * 120) + 'ms';
            toast.innerHTML = item.querySelector('.notif-icon').outerHTML +
                '<span class="notif-body">' +
                item.querySelector('.notif-title').outerHTML +
                item.querySelector('.notif-message').outerHTML +
                '</span>';
            toast.onclick = open;
            toastStack.appendChild(toast);
            setTimeout(function () { dismissToast(toast); }, 6000 + index * 120);
        }

        function dismissToast(toast) {
            if (!toast.parentNode) return;
            toast.classList.add('is-leaving');
            setTimeout(function () { if (toast.parentNode) toast.parentNode.removeChild(toast); }, 260);
        }

        function clearToasts() {
            var toasts = toastStack.querySelectorAll('.notif-toast');
            for (var i = 0; i < toasts.length; i++) dismissToast(toasts[i]);
        }

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && drawer.classList.contains('is-open')) close();
        });

        showToasts();

        return { open: open, close: close, showTab: showTab, markAllRead: markAllRead };
    })();
</script>
