using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using binary.Core.BLL;
using binary.Core.Helpers;
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
            litCourseFlag.Text = FlagHelper.Render(course.FlagImageUrl, course.Title, "flag-lg");
            litDescription.Text = Server.HtmlEncode(course.Description);
            badgeLevel.InnerText = course.Level;
            badgeCategory.InnerText = course.CategoryName;

            BindPage();

            // first stop after the Get Started onboarding + registration
            if (!IsPostBack && Request.QueryString["welcome"] == "1" && _mode == AccessMode.Enrolled)
            {
                litEnrollSuccess.Text = Server.HtmlEncode("Welcome to Binary! You're enrolled in " + course.Title +
                    ". Your first lesson is open below - complete it to earn your first XP.");
                pnlEnrollSuccess.Visible = true;
            }
        }

        private enum AccessMode { Guest, NotEnrolled, Enrolled, AdminPreview }

        private AccessMode _mode;

        protected string LockedMessage
        {
            get
            {
                return _mode == AccessMode.Guest
                    ? "Sign in and enroll to unlock this lesson and its video."
                    : "Enroll in this course to unlock this lesson and its video.";
            }
        }

        // The syllabus is shown to everyone so visitors can see what a course contains; lesson
        // content and videos are only rendered for enrolled learners and admins (preview).
        private void BindPage()
        {
            var lessons = new LessonBLL().GetLessonsByCourse(_courseId);
            litLessonCount.Text = lessons.Count.ToString();

            pnlGuestCta.Visible = false;
            pnlEnrollCta.Visible = false;
            pnlEnrolled.Visible = false;
            pnlAdminPreview.Visible = false;
            _completedLessonIds = new List<int>();
            OpenLessonId = 0;

            if (!AuthBLL.IsLoggedIn)
            {
                _mode = AccessMode.Guest;
                pnlGuestCta.Visible = true;
                string returnUrl = "?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery);
                lnkSignInEnroll.HRef = ResolveUrl("~/Auth/Login.aspx" + returnUrl);
                lnkRegisterEnroll.HRef = ResolveUrl("~/Auth/Register.aspx" + returnUrl);
            }
            else
            {
                int userId = AuthBLL.CurrentUserId;
                var enrollmentBll = new EnrollmentBLL();
                Enrollment enrollment = enrollmentBll.GetEnrollment(userId, _courseId);

                if (enrollment != null)
                {
                    _mode = AccessMode.Enrolled;
                    pnlEnrolled.Visible = true;
                    _completedLessonIds = enrollmentBll.GetCompletedLessonIds(enrollment.EnrollmentID);

                    Lesson nextLesson = lessons.FirstOrDefault(l => !_completedLessonIds.Contains(l.LessonID));
                    OpenLessonId = nextLesson != null ? nextLesson.LessonID : 0;

                    litProgressPercent.Text = enrollment.ProgressPercent.ToString();
                    progressBarFill.Style["width"] = enrollment.ProgressPercent + "%";
                }
                else
                {
                    _mode = AuthBLL.IsAdmin ? AccessMode.AdminPreview : AccessMode.NotEnrolled;
                    pnlEnrollCta.Visible = _mode == AccessMode.NotEnrolled;
                    pnlAdminPreview.Visible = _mode == AccessMode.AdminPreview;
                }
            }

            litSyllabusHint.Text = _mode == AccessMode.Enrolled || _mode == AccessMode.AdminPreview
                ? "Click any lesson to expand & study"
                : "Preview — enroll to unlock lessons and videos";

            pnlSyllabus.Visible = lessons.Count > 0;
            rptLessons.DataSource = lessons;
            rptLessons.DataBind();
        }

        protected string GetLessonKindLabel(object videoUrl)
        {
            return VideoHelper.GetEmbed(videoUrl as string) != null
                ? Icons.Svg("video", "ui-icon ui-icon-before") + "Video lesson"
                : "Interactive lesson";
        }

        // Only a placeholder with data attributes; the page script builds the actual player when
        // the lesson is opened. Every value is attribute-encoded.
        protected string RenderVideoPlaceholder(object videoUrl, object title)
        {
            VideoEmbed embed = VideoHelper.GetEmbed(videoUrl as string);
            if (embed == null) return string.Empty;

            string html = "<div class=\"lesson-video\" data-kind=\"" + embed.Kind + "\"" +
                          " data-src=\"" + HttpUtility.HtmlAttributeEncode(embed.Source) + "\"" +
                          " data-title=\"" + HttpUtility.HtmlAttributeEncode(title as string ?? "") + "\"";
            if (embed.Kind == "youtube")
                html += " data-thumb=\"https://i.ytimg.com/vi/" + embed.YouTubeId + "/hqdefault.jpg\"";
            return html + "></div>";
        }

        protected void rptLessons_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var lesson = (Lesson)e.Item.DataItem;
            bool unlocked = _mode == AccessMode.Enrolled || _mode == AccessMode.AdminPreview;
            bool completed = _mode == AccessMode.Enrolled && _completedLessonIds.Contains(lesson.LessonID);

            e.Item.FindControl("phLessonUnlocked").Visible = unlocked;
            e.Item.FindControl("phLessonLocked").Visible = !unlocked;
            e.Item.FindControl("litLocked").Visible = !unlocked;
            e.Item.FindControl("litCompleted").Visible = completed;
            // only enrolled learners track progress; the admin preview is read-only
            e.Item.FindControl("btnMarkComplete").Visible = _mode == AccessMode.Enrolled && !completed;
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
