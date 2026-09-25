using System;
using System.IO;
using System.Web.UI;
using binary.Core.BLL;

namespace binary.MasterPages
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // version by the file's last edit, so browsers cache it between pages but still pick up changes
            long cssVersion = File.GetLastWriteTimeUtc(Server.MapPath("~/Content/Site.css")).Ticks;
            SiteStylesheet.Href = ResolveUrl("~/Content/Site.css") + "?v=" + cssVersion;

            // session-based dynamic navigation
            bool loggedIn = AuthBLL.IsLoggedIn;
            bool isAdmin = AuthBLL.IsAdmin;

            phGuestActions.Visible = !loggedIn;
            phUserActions.Visible = loggedIn;
            phFooterGuestLinks.Visible = !loggedIn;
            phFooterMemberLinks.Visible = loggedIn;
            phAdminFooterNav.Visible = isAdmin;

            // footer call to action: sign up for visitors, straight back into learning for members
            if (isAdmin)
            {
                lnkFooterCta.HRef = "~/Admin/Default.aspx";
                lnkFooterCta.InnerText = "Open admin panel";
                // admins' dashboard and profile live in the admin panel, not the learner hub
                lnkFooterDashboard.HRef = "~/Admin/Default.aspx";
                lnkFooterProfile.HRef = "~/Admin/Profile.aspx";
            }
            else if (loggedIn)
            {
                lnkFooterCta.HRef = "~/Users/Profile.aspx";
                lnkFooterCta.InnerText = "Continue learning";
            }

            bool isPublicPage = IsPublicPage();
            phSiteFooter.Visible = isPublicPage;
            phSiteNavbar.Visible = isPublicPage;

            if (loggedIn)
            {
                string name = AuthBLL.CurrentUserName;
                // the avatar is the way back to your dashboard, so it goes to the right one per role;
                // it's avatar-only, so the name lives in the tooltip / screen-reader label
                lnkUserPill.HRef = isAdmin ? "~/Admin/Default.aspx" : "~/Users/Profile.aspx";
                lnkUserPill.Title = name + " — go to your dashboard";
                lnkUserPill.Attributes["aria-label"] = name + " — go to your dashboard";

                // calculate initials for user avatar
                string initials = "U";
                if (!string.IsNullOrWhiteSpace(name))
                {
                    string[] parts = name.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    if (parts.Length == 1)
                    {
                        initials = parts[0].Substring(0, 1).ToUpperInvariant();
                    }
                    else if (parts.Length >= 2)
                    {
                        initials = (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpperInvariant();
                    }
                }
                litAvatarInitials.Text = Server.HtmlEncode(initials);

                string avatarUrl = AuthBLL.CurrentUserAvatarUrl;
                if (!string.IsNullOrEmpty(avatarUrl))
                {
                    imgAvatarNav.ImageUrl = ResolveUrl(avatarUrl);
                    imgAvatarNav.Visible = true;
                    litAvatarInitials.Visible = false;
                }
            }
        }

        // The only pages that get the site navbar + footer: public pages (or whole folders,
        // ending in "/"). Everything else, i.e. the admin panel, learner dashboard and any
        // dashboard added later, renders without them by default.
        private static readonly string[] PublicPagePaths =
        {
            "~/Default.aspx",
            "~/Courses/",
            "~/Leaderboard/",
            "~/Pages/",
            "~/Auth/",
            "~/Users/Default.aspx",
        };

        // Matched against the page's .aspx file, not the request URL. FriendlyUrls serves
        // ~/Users/Profile.aspx at /Users/Profile and ~/Admin/Default.aspx at /Admin, so any
        // URL-based check misses those routes.
        // Public pages that still render full-screen without navbar/footer (they have their own header).
        private static readonly string[] FocusPagePaths =
        {
            "~/Auth/GetStarted.aspx",
        };

        // Navbar highlight for the page being viewed: a path ending in "/" covers the whole folder
        // (so a course's Detail page still highlights Courses). Matched against the .aspx file,
        // like IsPublicPage, because FriendlyUrls serves pages without the extension.
        protected string NavState(string path)
        {
            string pagePath = Page.AppRelativeVirtualPath ?? "";
            bool current = path.EndsWith("/")
                ? pagePath.StartsWith(path, StringComparison.OrdinalIgnoreCase)
                : pagePath.Equals(path, StringComparison.OrdinalIgnoreCase);
            return current ? "class=\"active\" aria-current=\"page\"" : "";
        }

        private bool IsPublicPage()
        {
            string pagePath = Page.AppRelativeVirtualPath ?? "";
            foreach (string path in FocusPagePaths)
            {
                if (pagePath.Equals(path, StringComparison.OrdinalIgnoreCase)) return false;
            }
            foreach (string path in PublicPagePaths)
            {
                bool matches = path.EndsWith("/")
                    ? pagePath.StartsWith(path, StringComparison.OrdinalIgnoreCase)
                    : pagePath.Equals(path, StringComparison.OrdinalIgnoreCase);
                if (matches) return true;
            }
            return false;
        }
    }
}
