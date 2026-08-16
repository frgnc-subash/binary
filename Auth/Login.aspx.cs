using System;
using System.Web.UI;
using binary.BLL;
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
                    Response.Redirect(AuthBLL.IsAdmin ? "~/Admin" : "~/");
                }
            }
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

                    // redirect to return url or default
                    string returnUrl = Request.QueryString["ReturnUrl"];
                    if (!string.IsNullOrEmpty(returnUrl) && !returnUrl.Contains("://") && !returnUrl.StartsWith("//"))
                    {
                        Response.Redirect(returnUrl);
                    }
                    else if (AuthBLL.IsAdmin)
                    {
                        Response.Redirect("~/Admin");
                    }
                    else
                    {
                        Response.Redirect("~/");
                    }
                }
                catch (ValidationException vex)
                {
                    litErrorMessage.Text = Server.HtmlEncode(vex.Message);
                    ErrorPanel.Visible = true;
                }
                catch (Exception)
                {
                    litErrorMessage.Text = "A system error occurred. Please try again later.";
                    ErrorPanel.Visible = true;
                }
            }
        }
    }
}
