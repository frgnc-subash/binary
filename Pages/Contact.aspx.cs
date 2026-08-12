using System;
using System.Web.UI;

namespace binary.Pages
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void SubmitBtn_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // TODO: Send email / save to database
                SuccessPanel.Visible = true;
                FirstName.Text = string.Empty;
                LastName.Text = string.Empty;
                Email.Text = string.Empty;
                Message.Text = string.Empty;
                Subject.SelectedIndex = 0;
            }
        }
    }
}
