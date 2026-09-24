using System;
using System.Web.UI;
using binary.Core.BLL;
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
            SuccessPanel.Visible = false;
            ErrorPanel.Visible = false;

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
                catch (ValidationException vex)
                {
                    litContactError.Text = Server.HtmlEncode(vex.Message);
                    ErrorPanel.Visible = true;
                }
                catch (Exception ex)
                {
                    // previously this showed the success panel, so failed messages were silently lost
                    System.Diagnostics.Trace.TraceError("Contact form submit failed: {0}", ex);
                    litContactError.Text = "Something went wrong on our side. Please try again in a moment, or email us directly.";
                    ErrorPanel.Visible = true;
                }
            }
        }
    }
}
