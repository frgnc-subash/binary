using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using binary.Core.BLL;
using binary.Models;

namespace binary.Controls
{
    // bell button + right-side notification drawer (Inbox / Archived) + toast pop-ups for the dashboards
    public partial class NotificationBell : UserControl
    {
        // unread notifications younger than this pop up as toasts on page load
        private static readonly TimeSpan ToastWindow = TimeSpan.FromMinutes(2);

        private static readonly Dictionary<string, string> Icons = new Dictionary<string, string>
        {
            { NotificationTypes.Info, "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"12\" cy=\"12\" r=\"9\"></circle><line x1=\"12\" y1=\"16\" x2=\"12\" y2=\"12\"></line><line x1=\"12\" y1=\"8\" x2=\"12.01\" y2=\"8\"></line></svg>" },
            { NotificationTypes.Success, "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"20 6 9 17 4 12\"></polyline></svg>" },
            { NotificationTypes.Xp, "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polygon points=\"13 2 3 14 12 14 11 22 21 10 12 10 13 2\"></polygon></svg>" },
            { NotificationTypes.Warning, "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><rect x=\"4\" y=\"11\" width=\"16\" height=\"10\" rx=\"2\"></rect><path d=\"M8 11V7a4 4 0 0 1 8 0v4\"></path></svg>" },
            { NotificationTypes.Admin, "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M12 2 4 5v6c0 5 3.5 9 8 11 4.5-2 8-6 8-11V5z\"></path></svg>" },
            { NotificationTypes.Award, "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"12\" cy=\"8\" r=\"6\"></circle><path d=\"M8.5 13.5 7 22l5-3 5 3-1.5-8.5\"></path></svg>" },
        };

        private const string ReadIcon = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"20 6 9 17 4 12\"></polyline></svg>";
        private const string ArchiveIcon = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><rect x=\"2\" y=\"3\" width=\"20\" height=\"5\" rx=\"1\"></rect><path d=\"M4 8v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8\"></path><line x1=\"10\" y1=\"12\" x2=\"14\" y2=\"12\"></line></svg>";
        private const string UnarchiveIcon = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"22 12 16 12 14 15 10 15 8 12 2 12\"></polyline><path d=\"M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11Z\"></path></svg>";

        protected int UnreadCount { get; private set; }
        protected int InboxCount { get; private set; }
        protected int ArchivedCount { get; private set; }

        // PreRender (not Load) so notifications raised by this request's event handlers,
        // e.g. submitting a quiz, are already in the drawer when the page renders
        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            if (!AuthBLL.IsLoggedIn)
            {
                Visible = false;
                return;
            }

            List<Notification> inbox;
            List<Notification> archived;
            try
            {
                var bll = new NotificationBLL();
                inbox = bll.GetInbox(AuthBLL.CurrentUserId);
                archived = bll.GetArchived(AuthBLL.CurrentUserId);
                UnreadCount = bll.GetUnreadCount(AuthBLL.CurrentUserId);
            }
            catch (Exception ex)
            {
                // e.g. the Notifications table/columns haven't been created yet; keep the dashboard usable
                System.Diagnostics.Trace.TraceError("Loading notifications failed: {0}", ex);
                inbox = new List<Notification>();
                archived = new List<Notification>();
                UnreadCount = 0;
            }

            InboxCount = inbox.Count;
            ArchivedCount = archived.Count;

            rptInbox.DataSource = inbox;
            rptInbox.DataBind();
            rptArchived.DataSource = archived;
            rptArchived.DataBind();

            phUnreadDot.Visible = UnreadCount > 0;
            litUnreadLabel.Text = UnreadCount > 0 ? UnreadCount + " unread" : "You're all caught up";
        }

        // One renderer for both lists, so an item looks identical after the drawer's script moves it
        // between Inbox and Archived. Every action button is rendered; CSS shows only the ones that apply.
        protected string RenderItem(object dataItem, bool inInbox)
        {
            var n = (Notification)dataItem;
            string typeKey = n.Type != null && Icons.ContainsKey(n.Type) ? n.Type : NotificationTypes.Info;
            bool fresh = inInbox && !n.IsRead && DateTime.UtcNow - n.CreatedDate <= ToastWindow;

            var html = new StringBuilder();
            html.Append("<div class=\"notif-item").Append(n.IsRead ? "" : " notif-item-unread")
                .Append("\" data-id=\"").Append(n.NotificationID)
                .Append("\" data-fresh=\"").Append(fresh ? "1" : "0").Append("\">");

            if (string.IsNullOrEmpty(n.LinkUrl))
                html.Append("<div class=\"notif-link\">");
            else
                html.Append("<a class=\"notif-link\" href=\"").Append(HttpUtility.HtmlAttributeEncode(ResolveUrl(n.LinkUrl))).Append("\">");

            html.Append("<span class=\"notif-icon notif-icon-").Append(typeKey).Append("\">").Append(Icons[typeKey]).Append("</span>")
                .Append("<span class=\"notif-body\">")
                .Append("<span class=\"notif-title\">").Append(HttpUtility.HtmlEncode(n.Title)).Append("</span>")
                .Append("<span class=\"notif-message\">").Append(HttpUtility.HtmlEncode(n.Message)).Append("</span>")
                .Append("<span class=\"notif-time\">").Append(GetRelativeTime(n.CreatedDate)).Append("</span>")
                .Append("</span>")
                .Append(string.IsNullOrEmpty(n.LinkUrl) ? "</div>" : "</a>");

            html.Append("<div class=\"notif-actions\">")
                .Append(ActionButton("markread", "notif-action-read", "Mark as read", ReadIcon))
                .Append(ActionButton("archive", "notif-action-archive", "Archive", ArchiveIcon))
                .Append(ActionButton("unarchive", "notif-action-unarchive", "Move to inbox", UnarchiveIcon))
                .Append("</div></div>");

            return html.ToString();
        }

        private static string ActionButton(string action, string cssClass, string label, string icon)
        {
            return "<button type=\"button\" class=\"notif-action " + cssClass + "\" data-action=\"" + action +
                   "\" title=\"" + label + "\" aria-label=\"" + label + "\">" + icon + "</button>";
        }

        private static string GetRelativeTime(DateTime createdUtc)
        {
            TimeSpan ago = DateTime.UtcNow - createdUtc;

            if (ago.TotalMinutes < 1) return "Just now";
            if (ago.TotalHours < 1) return (int)ago.TotalMinutes + "m ago";
            if (ago.TotalDays < 1) return (int)ago.TotalHours + "h ago";
            if (ago.TotalDays < 7) return (int)ago.TotalDays + "d ago";
            return createdUtc.ToString("MMM d, yyyy");
        }
    }
}
