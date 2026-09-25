using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using binary.Core.BLL;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Auth
{
    // "Get Started" onboarding: welcome, what to learn, what you speak, why - then registration.
    public partial class GetStarted : Page
    {
        private Dictionary<int, int> _lessonCounts = new Dictionary<int, int>();

        // which step the page opens on (the course step again after a server-side validation error)
        protected int InitialStep { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (AuthBLL.IsLoggedIn)
            {
                Response.Redirect(AuthBLL.IsAdmin ? "~/Admin/Default.aspx" : "~/Users/Profile.aspx", true);
                return;
            }

            // bound on every request so the options (and restored selections) render after a postback too
            var courses = new CourseBLL().GetPublishedCourses();
            _lessonCounts = new LessonBLL().GetLessonCountsByCourse();
            rptCourses.DataSource = courses;
            rptCourses.DataBind();
            pnlNoCourses.Visible = courses.Count == 0;

            rptNative.DataSource = OnboardingBLL.NativeLanguages;
            rptNative.DataBind();
            rptReasons.DataSource = OnboardingBLL.Reasons;
            rptReasons.DataBind();
        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {
            string[] courses = Request.Form.GetValues("onbCourse");
            string[] natives = Request.Form.GetValues("onbNative");
            string[] reasons = Request.Form.GetValues("onbReason");

            // nothing published to enroll in: go straight to the account form
            if (courses == null && pnlNoCourses.Visible)
            {
                Response.Redirect("~/Auth/Register.aspx", true);
                return;
            }

            try
            {
                OnboardingBLL.Save(courses, natives, reasons);
            }
            catch (ValidationException vex)
            {
                litError.Text = Server.HtmlEncode(vex.Message);
                pnlError.Visible = true;
                InitialStep = natives == null && courses != null ? 2 : 1;
                return;
            }

            Response.Redirect("~/Auth/Register.aspx", true);
        }

        protected int GetLessonCount(int courseId)
        {
            int count;
            return _lessonCounts.TryGetValue(courseId, out count) ? count : 0;
        }

        // keeps a checkbox ticked after a postback (these are plain inputs, not server controls)
        protected string IsChecked(string field, object value)
        {
            string[] posted = Request.Form.GetValues(field);
            return posted != null && Array.IndexOf(posted, Convert.ToString(value)) >= 0 ? "checked" : "";
        }

        // flag if we have one, otherwise an icon, otherwise a short code badge ("EN")
        protected string RenderOptionBadge(object dataItem)
        {
            var option = (OnboardingOption)dataItem;
            if (!string.IsNullOrEmpty(option.FlagUrl))
            {
                string extra = option.Key == "ne" ? " flag-contain" : "";   // Nepal's flag isn't rectangular
                return "<img class=\"flag flag-md" + extra + "\" src=\"" + HttpUtility.HtmlAttributeEncode(ResolveUrl(option.FlagUrl)) + "\" alt=\"\" />";
            }
            if (!string.IsNullOrEmpty(option.IconName))
                return "<span class=\"onb-option-icon\">" + Icons.Svg(option.IconName) + "</span>";
            return "<span class=\"flag flag-md flag-fallback\">" + HttpUtility.HtmlEncode(option.Code) + "</span>";
        }
    }
}
