using System;
using System.Web.UI;
using binary.Core.BLL;

namespace binary.Auth
{
    public partial class Logout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthBLL.Logout();
            Response.Redirect("~/Auth/Login.aspx", true);
        }
    }
}
