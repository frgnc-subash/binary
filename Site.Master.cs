using System;
using System.Web.UI;
using binary.BLL;

namespace binary
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SiteStylesheet.Href = ResolveUrl("~/Content/Site.css") + "?v=" + DateTime.UtcNow.Ticks;

            // session-based dynamic navigation
            bool loggedIn = AuthBLL.IsLoggedIn;
            bool isAdmin = AuthBLL.IsAdmin;

            phGuestActions.Visible = !loggedIn;
            phUserActions.Visible = loggedIn;
            phMemberLinks.Visible = loggedIn;
            phAdminNav.Visible = isAdmin;

            if (loggedIn)
            {
                string name = AuthBLL.CurrentUserName;
                litUserName.Text = Server.HtmlEncode(name);

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
            }
        }
    }
}
