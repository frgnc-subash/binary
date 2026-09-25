using System;
using System.Web.UI;
using binary.Core.BLL;
using binary.Models;

namespace binary.Admin
{
    // The admin's own account page, inside the admin panel (admin-only access is enforced by AdminMaster).
    public partial class AdminProfile : Page
    {
        private readonly UserBLL _userBll = new UserBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;

            string msg = Request.QueryString["msg"];
            if (msg == "saved") ShowSuccess("Profile updated.");
            else if (msg == "password") ShowSuccess("Password changed.");

            LoadProfile();
        }

        private void LoadProfile()
        {
            User user = _userBll.GetProfile(AuthBLL.CurrentUserId);

            txtFirstName.Text = user.FirstName;
            txtLastName.Text = user.LastName;
            txtEmail.Text = user.Email;

            litName.Text = Server.HtmlEncode(user.FullName);
            litEmail.Text = Server.HtmlEncode(user.Email);
            litMemberSince.Text = user.CreatedDate.ToString("MMMM yyyy");

            string initials = "";
            if (!string.IsNullOrWhiteSpace(user.FirstName)) initials += user.FirstName.Trim().Substring(0, 1);
            if (!string.IsNullOrWhiteSpace(user.LastName)) initials += user.LastName.Trim().Substring(0, 1);
            litInitials.Text = Server.HtmlEncode(initials.Length > 0 ? initials.ToUpperInvariant() : "A");

            bool hasAvatar = !string.IsNullOrWhiteSpace(user.ProfileImageUrl);
            imgAvatar.Visible = hasAvatar;
            litInitials.Visible = !hasAvatar;
            if (hasAvatar) imgAvatar.ImageUrl = ResolveUrl(user.ProfileImageUrl);
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                int userId = AuthBLL.CurrentUserId;
                if (fuAvatar.HasFile)
                    _userBll.SaveProfilePicture(userId, fuAvatar.PostedFile);

                _userBll.UpdateProfile(userId, txtFirstName.Text, txtLastName.Text);
                AuthBLL.EstablishSession(_userBll.GetProfile(userId));   // name/picture shown by AdminMaster
            }
            catch (ValidationException vex)
            {
                ShowError(vex.Message);
                return;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Admin profile update failed for user {0}: {1}", AuthBLL.CurrentUserId, ex);
                ShowError("Failed to update your profile. Please try again.");
                return;
            }

            // reload so the sidebar and header (rendered by AdminMaster before this handler ran) show the changes
            Response.Redirect("~/Admin/Profile.aspx?msg=saved");
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                _userBll.ChangePassword(AuthBLL.CurrentUserId, txtCurrentPassword.Text, txtNewPassword.Text);
            }
            catch (ValidationException vex)
            {
                ShowError(vex.Message);
                return;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Admin password change failed for user {0}: {1}", AuthBLL.CurrentUserId, ex);
                ShowError("Failed to change your password. Please try again.");
                return;
            }

            Response.Redirect("~/Admin/Profile.aspx?msg=password");
        }

        private void ShowSuccess(string message)
        {
            litSuccess.Text = Server.HtmlEncode(message);
            pnlSuccess.Visible = true;
        }

        private void ShowError(string message)
        {
            litError.Text = Server.HtmlEncode(message);
            pnlError.Visible = true;
        }
    }
}
