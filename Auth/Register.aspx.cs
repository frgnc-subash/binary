using System;
using System.Web.UI;

namespace binary.Auth
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void RegisterBtn_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (!AgreeTerms.Checked)
                {
                    // Show a terms error if needed
                    return;
                }

                // TODO: Hash password, save user to database
                // string hashedPassword = BCrypt.Net.BCrypt.HashPassword(PasswordInput.Text);
                // UserRepository.Create(FirstName.Text, LastName.Text, EmailInput.Text, hashedPassword);

                SuccessPanel.Visible = true;
                FirstName.Text = string.Empty;
                LastName.Text = string.Empty;
                EmailInput.Text = string.Empty;
                PasswordInput.Text = string.Empty;
                ConfirmPassword.Text = string.Empty;
            }
        }
    }
}
