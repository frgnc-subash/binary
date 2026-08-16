using System;
using System.Web.UI;
using binary.BLL;
using binary.Models;

namespace binary.Pages
{
    public partial class Contact : Page
    {
        private readonly FeedbackBLL _feedbackBll = new FeedbackBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && AuthBLL.IsLoggedIn)
            {
                // auto-fill logged in user details
                try
                {
                    var userBll = new UserBLL();
                    User u = userBll.GetProfile(AuthBLL.CurrentUserId);
                    if (u != null)
                    {
                        FirstName.Text = u.FirstName;
                        LastName.Text = u.LastName;
                        Email.Text = u.Email;
                    }
                }
                catch { }
            }
        }

        protected void SubmitBtn_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string fullName = (FirstName.Text.Trim() + " " + LastName.Text.Trim()).Trim();
                    string email = Email.Text.Trim();
                    string subject = Subject.SelectedItem != null && !string.IsNullOrEmpty(Subject.SelectedValue)
                        ? Subject.SelectedItem.Text
                        : "General Inquiry";
                    string message = Message.Text.Trim();

                    int? userId = AuthBLL.IsLoggedIn ? (int?)AuthBLL.CurrentUserId : null;

                    _feedbackBll.SubmitFeedback(fullName, email, subject, message, userId);

                    SuccessPanel.Visible = true;
                    Message.Text = string.Empty;
                    Subject.SelectedIndex = 0;
                    if (!AuthBLL.IsLoggedIn)
                    {
                        FirstName.Text = string.Empty;
                        LastName.Text = string.Empty;
                        Email.Text = string.Empty;
                    }
                }
                catch (Exception)
                {
                    SuccessPanel.Visible = true;
                }
            }
        }
    }
}
