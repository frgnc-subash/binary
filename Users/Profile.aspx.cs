using System;
using System.Web.UI;
using binary.BLL;
using binary.Models;

namespace binary.Users
{
    public partial class Profile : Page
    {
        private readonly UserBLL _userBll = new UserBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            // enforce session authentication
            if (!AuthBLL.IsLoggedIn)
            {
                Response.Redirect("~/Auth/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl), true);
                return;
            }

            if (!IsPostBack)
            {
                LoadUserProfile();
            }
        }

        private void LoadUserProfile()
        {
            int userId = AuthBLL.CurrentUserId;
            try
            {
                User user = _userBll.GetProfile(userId);
                if (user != null)
                {
                    txtFirstName.Text = user.FirstName;
                    txtLastName.Text = user.LastName;
                    txtEmail.Text = user.Email;

                    litFullName.Text = Server.HtmlEncode(user.FullName);
                    litEmail.Text = Server.HtmlEncode(user.Email);
                    litRoleBadge.Text = Server.HtmlEncode(user.RoleName ?? "Member");

                    // calculate initials for avatar
                    string initials = "U";
                    if (!string.IsNullOrWhiteSpace(user.FirstName))
                    {
                        initials = user.FirstName.Substring(0, 1).ToUpperInvariant();
                        if (!string.IsNullOrWhiteSpace(user.LastName))
                        {
                            initials += user.LastName.Substring(0, 1).ToUpperInvariant();
                        }
                    }
                    litAvatar.Text = Server.HtmlEncode(initials);
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading profile: " + ex.Message);
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            ClearAlerts();
            if (Page.IsValid)
            {
                try
                {
                    int userId = AuthBLL.CurrentUserId;
                    _userBll.UpdateProfile(userId, txtFirstName.Text, txtLastName.Text);

                    // refresh session display name
                    User u = _userBll.GetProfile(userId);
                    AuthBLL.EstablishSession(u);

                    LoadUserProfile();
                    ShowSuccess("Profile updated successfully!");
                }
                catch (ValidationException vex)
                {
                    ShowError(vex.Message);
                }
                catch (Exception)
                {
                    ShowError("Failed to update profile. Please try again.");
                }
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            ClearAlerts();
            if (Page.IsValid)
            {
                try
                {
                    int userId = AuthBLL.CurrentUserId;
                    _userBll.ChangePassword(userId, txtCurrentPassword.Text, txtNewPassword.Text);

                    txtCurrentPassword.Text = string.Empty;
                    txtNewPassword.Text = string.Empty;
                    txtConfirmNewPassword.Text = string.Empty;

                    ShowSuccess("Password changed successfully!");
                }
                catch (ValidationException vex)
                {
                    ShowError(vex.Message);
                }
                catch (Exception)
                {
                    ShowError("Failed to change password. Please try again.");
                }
            }
        }

        private void ClearAlerts()
        {
            ProfileAlertPanel.Visible = false;
            ProfileErrorPanel.Visible = false;
        }

        private void ShowSuccess(string message)
        {
            litProfileAlert.Text = Server.HtmlEncode(message);
            ProfileAlertPanel.Visible = true;
        }

        private void ShowError(string message)
        {
            litProfileError.Text = Server.HtmlEncode(message);
            ProfileErrorPanel.Visible = true;
        }
    }
}
