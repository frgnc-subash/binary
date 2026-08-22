using System;
using System.Web.UI;
using binary.Core.BLL;
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
                }
                catch (ValidationException vex)
                {
                    litRegisterError.Text = Server.HtmlEncode(vex.Message);
                    ErrorPanel.Visible = true;
                    return;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Registration failed for {0}: {1}", email, ex);
                    litRegisterError.Text = "An error occurred during registration. Please try again.";
                    ErrorPanel.Visible = true;
                    return;
                }

                // account was created successfully at this point; auto-login is best-effort
                try
                {
                    AuthBLL.Login(email, password);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Auto-login after registration failed for {0}: {1}", email, ex);
                    Response.Redirect("~/Auth/Login.aspx", false);
                    return;
                }

                litRegisterSuccess.Text = "Welcome to Binary! Your account has been created.";
                SuccessPanel.Visible = true;

                // redirect to homepage
                Response.Redirect("~/", false);
            }
        }
    }
}
