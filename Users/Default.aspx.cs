using System;
using System.Web.UI;
using binary.Core.BLL;

namespace binary.Users
{
    public partial class UsersHome : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var topLearners = new UserBLL().GetLeaderboard(3);
                rptTopLearners.DataSource = topLearners;
                rptTopLearners.DataBind();
                pnlNoLearners.Visible = topLearners.Count == 0;
            }
        }
    }
}
