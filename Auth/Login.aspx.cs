using System;
using System.Web.UI;

namespace binary.Auth
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void LoginBtn_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // TODO: Authenticate user against database
                string email = EmailInput.Text.Trim();
                string password = PasswordInput.Text;

                // Placeholder: redirect on success
                // FormsAuthentication.SetAuthCookie(email, RememberMe.Checked);
                // Response.Redirect("~/");

                ErrorPanel.Visible = true;
            }
        }
    }
}
