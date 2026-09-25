using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using binary.Core.BLL;

namespace binary.MasterPages
{
    public partial class AdminMaster : MasterPage
    {
        public string AdminName { get; private set; } = "Admin";
        public string AdminEmail { get; private set; } = "";
        public string AdminInitials { get; private set; } = "AD";
        public string AdminAvatarUrl { get; private set; } = "";
        public string CurrentPath { get; private set; } = "";

        protected void Page_Init(object sender, EventArgs e)
        {
            // centralized authorization for the entire admin section
            if (!AuthBLL.IsLoggedIn)
            {
                Response.Redirect("~/Auth/Login.aspx?ReturnUrl=" + HttpUtility.UrlEncode(Request.RawUrl), true);
                return;
            }

            if (!AuthBLL.IsAdmin)
            {
                Response.Redirect("~/", true);
                return;
            }

            AdminName = AuthBLL.CurrentUserName;
            AdminEmail = AuthBLL.CurrentUserEmail;
            AdminAvatarUrl = AuthBLL.CurrentUserAvatarUrl;
            // the page's .aspx file, not the URL: FriendlyUrls serves every page at both /Admin/Users
            // and /Admin/Users.aspx, and a URL match highlighted the sidebar on only one of them
            CurrentPath = Page.AppRelativeVirtualPath ?? "";

            if (!string.IsNullOrWhiteSpace(AdminName))
            {
                string[] parts = AdminName.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                if (parts.Length == 1)
                {
                    AdminInitials = parts[0].Substring(0, 1).ToUpperInvariant();
                }
                else if (parts.Length >= 2)
                {
                    AdminInitials = (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpperInvariant();
                }
            }
        }

        // pages that live under another sidebar entry (a lesson's quiz is part of Courses & Lessons)
        private static readonly Dictionary<string, string> SectionOf = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            { "~/Admin/LessonQuiz.aspx", "~/Admin/Courses.aspx" },
        };

        public string GetActiveClass(string relativeUrl)
        {
            string section;
            string path = SectionOf.TryGetValue(CurrentPath, out section) ? section : CurrentPath;
            return path.Equals(relativeUrl, StringComparison.OrdinalIgnoreCase) ? "active" : "";
        }

        // renders the admin's uploaded profile picture, falling back to initials
        public string GetAvatarHtml()
        {
            if (string.IsNullOrEmpty(AdminAvatarUrl))
                return HttpUtility.HtmlEncode(AdminInitials);

            return "<img class=\"avatar-img\" src=\"" + HttpUtility.HtmlEncode(ResolveUrl(AdminAvatarUrl)) + "\" alt=\"\" />";
        }
    }
}
