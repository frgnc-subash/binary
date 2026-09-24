using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using binary.Core.BLL;
using binary.Models;

namespace binary.Courses
{
    public partial class Detail : System.Web.UI.Page
    {
        private int _courseId;
        private List<int> _completedLessonIds = new List<int>();

        // first lesson not yet completed; the page opens it so learners resume where they left off
        protected int OpenLessonId { get; private set; }

        // only after completing a lesson, so a plain visit doesn't jump the page down
        protected bool ScrollToOpenLesson { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            int courseId;
            if (!int.TryParse(Request.QueryString["id"], out courseId) || courseId <= 0)
            {
                Response.Redirect("~/Courses");
                return;
            }
            _courseId = courseId;
            hfCourseId.Value = courseId.ToString();

            Course course;
            try
            {
                course = new CourseBLL().GetCourseById(courseId);
            }
            catch (ValidationException)
            {
                Response.Redirect("~/Courses");
                return;
            }

            litTitle.Text = Server.HtmlEncode(course.Title);
            litDescription.Text = Server.HtmlEncode(course.Description);
            badgeLevel.InnerText = course.Level;
            badgeCategory.InnerText = course.CategoryName;

            BindPage();
        }

        private void BindPage()
        {
            var lessons = new LessonBLL().GetLessonsByCourse(_courseId);
            litLessonCount.Text = lessons.Count.ToString();

            if (!AuthBLL.IsLoggedIn)
            {
                pnlGuestCta.Visible = true;
                pnlEnrollCta.Visible = false;
                pnlEnrolled.Visible = false;
                string returnUrl = "?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery);
                lnkSignInEnroll.HRef = ResolveUrl("~/Auth/Login.aspx" + returnUrl);
                lnkRegisterEnroll.HRef = ResolveUrl("~/Auth/Register.aspx" + returnUrl);
                return;
            }

            int userId = AuthBLL.CurrentUserId;
            var enrollmentBll = new EnrollmentBLL();

            if (!enrollmentBll.IsUserEnrolled(userId, _courseId))
            {
                pnlGuestCta.Visible = false;
                pnlEnrollCta.Visible = true;
                pnlEnrolled.Visible = false;
                return;
            }

            pnlGuestCta.Visible = false;
            pnlEnrollCta.Visible = false;
            pnlEnrolled.Visible = true;

            Enrollment enrollment = enrollmentBll.GetEnrollment(userId, _courseId);
            _completedLessonIds = enrollmentBll.GetCompletedLessonIds(enrollment.EnrollmentID);

            Lesson nextLesson = lessons.FirstOrDefault(l => !_completedLessonIds.Contains(l.LessonID));
            OpenLessonId = nextLesson != null ? nextLesson.LessonID : 0;

            litProgressPercent.Text = enrollment.ProgressPercent.ToString();
            progressBarFill.Style["width"] = enrollment.ProgressPercent + "%";

            rptLessons.DataSource = lessons;
            rptLessons.DataBind();
        }

        protected void rptLessons_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var lesson = (Lesson)e.Item.DataItem;
            bool completed = _completedLessonIds.Contains(lesson.LessonID);

            e.Item.FindControl("litCompleted").Visible = completed;
            e.Item.FindControl("btnMarkComplete").Visible = !completed;
        }

        protected void btnEnroll_Click(object sender, EventArgs e)
        {
            try
            {
                new EnrollmentBLL().Enroll(AuthBLL.CurrentUserId, _courseId);
                litEnrollSuccess.Text = "You're enrolled! Start completing lessons to earn XP.";
                pnlEnrollSuccess.Visible = true;
                BindPage();
            }
            catch (ValidationException vex)
            {
                litEnrollError.Text = Server.HtmlEncode(vex.Message);
                pnlEnrollError.Visible = true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Enroll failed for user {0}, course {1}: {2}", AuthBLL.CurrentUserId, _courseId, ex);
                litEnrollError.Text = "Something went wrong. Please try again.";
                pnlEnrollError.Visible = true;
            }
        }

        protected void rptLessons_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "MarkComplete") return;

            int lessonId = Convert.ToInt32(e.CommandArgument);
            try
            {
                new EnrollmentBLL().MarkLessonComplete(AuthBLL.CurrentUserId, _courseId, lessonId);
                litEnrollSuccess.Text = string.Format("Lesson complete! +{0} XP earned.", EnrollmentBLL.LessonXpReward);
                pnlEnrollSuccess.Visible = true;
                ScrollToOpenLesson = true;
                BindPage();
            }
            catch (ValidationException vex)
            {
                litEnrollError.Text = Server.HtmlEncode(vex.Message);
                pnlEnrollError.Visible = true;
            }
            catch (Exception ex)
            {
                // most likely a duplicate submit racing the IsCompleted check in MarkLessonComplete;
                // treat as already-completed rather than surfacing a raw error
                System.Diagnostics.Trace.TraceError("MarkLessonComplete failed for user {0}, course {1}, lesson {2}: {3}", AuthBLL.CurrentUserId, _courseId, lessonId, ex);
                BindPage();
            }
        }
    }
}
