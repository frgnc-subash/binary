using System;
using System.Web.UI;
using binary.BLL;

namespace binary.Admin
{
    public partial class AdminHome : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // enforce admin authorization
            if (!AuthBLL.IsLoggedIn)
            {
                Response.Redirect("~/Auth/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl), true);
                return;
            }

            if (!AuthBLL.IsAdmin)
            {
                // redirect non-admin users to homepage
                Response.Redirect("~/", true);
                return;
            }
        }
    }
}
