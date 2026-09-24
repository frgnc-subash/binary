using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using binary.Core.BLL;
using binary.Models;

namespace binary.Admin
{
    public partial class AdminFeedback : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // admin authorization is enforced centrally by AdminMaster (runs earlier, in Init)
            BindFeedback();
        }

        private void BindFeedback()
        {
            var feedback = new FeedbackBLL().GetAllFeedback();
            rptFeedback.DataSource = feedback;
            rptFeedback.DataBind();
            pnlFeedbackList.Visible = feedback.Count > 0;
            pnlNoFeedback.Visible = feedback.Count == 0;
        }

        protected void rptFeedback_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteFeedback") return;

            int feedbackId = Convert.ToInt32(e.CommandArgument);
            try
            {
                new FeedbackBLL().DeleteFeedback(feedbackId);
                BindFeedback();
            }
            catch (ValidationException vex)
            {
                litFeedbackError.Text = Server.HtmlEncode(vex.Message);
                pnlFeedbackError.Visible = true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Delete feedback {0} failed: {1}", feedbackId, ex);
                litFeedbackError.Text = "Something went wrong. Please try again.";
                pnlFeedbackError.Visible = true;
            }
        }

        protected string Truncate(string text, int maxLength)
        {
            if (string.IsNullOrEmpty(text) || text.Length <= maxLength) return text;
            return text.Substring(0, maxLength).TrimEnd() + "…";
        }
    }
}
