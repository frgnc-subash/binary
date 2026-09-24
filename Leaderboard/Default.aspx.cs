using System;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using binary.Core.BLL;
using binary.Models;

namespace binary.Leaderboard
{
    public partial class LeaderboardHome : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var leaders = new UserBLL().GetLeaderboard(50);
                rptLeaderboard.DataSource = leaders;
                rptLeaderboard.DataBind();
                pnlEmpty.Visible = leaders.Count == 0;
            }
        }

        protected void rptLeaderboard_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var user = (User)e.Item.DataItem;
            if (AuthBLL.IsLoggedIn && user.UserID == AuthBLL.CurrentUserId)
            {
                ((Literal)e.Item.FindControl("litYou")).Visible = true;
                var row = (HtmlTableRow)e.Item.FindControl("trRow");
                row.Attributes["class"] += " is-you";
            }
        }
    }
}
