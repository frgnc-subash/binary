using System;
using System.Web.UI;
using binary.BLL;
using binary.Models;

namespace binary.Auth
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (AuthBLL.IsLoggedIn)
                {
                    Response.Redirect("~/", true);
                }
            }
        }

        protected void RegisterBtn_Click(object sender, EventArgs e)
        {
            ErrorPanel.Visible = false;
            SuccessPanel.Visible = false;

            if (Page.IsValid)
            {
                if (!AgreeTerms.Checked)
                {
                    litRegisterError.Text = "Please agree to the Terms of Service to continue.";
                    ErrorPanel.Visible = true;
                    return;
                }

                string firstName = FirstName.Text.Trim();
                string lastName = LastName.Text.Trim();
                string email = EmailInput.Text.Trim();
                string password = PasswordInput.Text;

                try
                {
                    var userBll = new UserBLL();
                    userBll.Register(firstName, lastName, email, password);

                    // auto-login newly registered user
                    AuthBLL.Login(email, password);

                    litRegisterSuccess.Text = "Welcome to Binary! Your account has been created.";
                    SuccessPanel.Visible = true;

                    // redirect to homepage
                    Response.Redirect("~/", false);
                }
                catch (ValidationException vex)
                {
                    litRegisterError.Text = Server.HtmlEncode(vex.Message);
                    ErrorPanel.Visible = true;
                }
                catch (Exception)
                {
                    litRegisterError.Text = "An error occurred during registration. Please try again.";
                    ErrorPanel.Visible = true;
                }
            }
        }
    }
}
