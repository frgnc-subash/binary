using System;
using System.Web.UI;
using binary.Core.BLL;
using binary.Models;

namespace binary.Auth
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // redirect if already logged in
                if (AuthBLL.IsLoggedIn)
                {
                    Response.Redirect(GetPostAuthRedirect());
                }
            }
        }

        private string GetPostAuthRedirect()
        {
            string returnUrl = Request.QueryString["ReturnUrl"];
            if (AuthBLL.IsSafeReturnUrl(returnUrl))
                return returnUrl;
            return AuthBLL.IsAdmin ? "~/Admin" : "~/Users/Profile.aspx";
        }

        // carries the current ReturnUrl (if any) across to the other auth page, so switching
        // between Sign In and Register doesn't lose track of where the guest was headed
        protected string BuildAuthCrossLink(string path)
        {
            string returnUrl = Request.QueryString["ReturnUrl"];
            string resolved = ResolveUrl(path);
            return AuthBLL.IsSafeReturnUrl(returnUrl)
                ? resolved + "?ReturnUrl=" + Server.UrlEncode(returnUrl)
                : resolved;
        }

        protected void LoginBtn_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string email = EmailInput.Text.Trim();
                string password = PasswordInput.Text;

                try
                {
                    AuthBLL.Login(email, password);

                    Response.Redirect(GetPostAuthRedirect());
                }
                catch (ValidationException vex)
                {
                    litErrorMessage.Text = Server.HtmlEncode(vex.Message);
                    ErrorPanel.Visible = true;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Login failed for {0}: {1}", email, ex);
                    litErrorMessage.Text = "We couldn't sign you in right now. Please try again in a moment.";
                    ErrorPanel.Visible = true;
                }
            }
        }
    }
}
