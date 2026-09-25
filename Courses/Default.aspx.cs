using System;
using System.Collections.Generic;
using System.Web.UI;
using binary.Core.BLL;

namespace binary.Courses
{
    public partial class CoursesHome : Page
    {
        private Dictionary<int, int> _lessonCounts = new Dictionary<int, int>();
        private readonly Dictionary<int, int> _progressByCourse = new Dictionary<int, int>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var courses = new CourseBLL().GetPublishedCourses();
                _lessonCounts = new LessonBLL().GetLessonCountsByCourse();

                // signed-in learners see their progress on the courses they're taking
                if (AuthBLL.IsLoggedIn && !AuthBLL.IsAdmin)
                {
                    foreach (var enrollment in new EnrollmentBLL().GetUserEnrollments(AuthBLL.CurrentUserId))
                        _progressByCourse[enrollment.CourseID] = enrollment.ProgressPercent;
                }
                rptCourses.DataSource = courses;
                rptCourses.DataBind();
                pnlNoCourses.Visible = courses.Count == 0;
            }
        }

        protected bool IsEnrolled(int courseId)
        {
            return _progressByCourse.ContainsKey(courseId);
        }

        protected string GetProgressHtml(int courseId)
        {
            int pct;
            if (!_progressByCourse.TryGetValue(courseId, out pct)) return "";
            return "<div class=\"course-card-progress\"><div class=\"progress\"><div class=\"progress-bar\" style=\"width:" + pct + "%\"></div></div>" +
                   "<span>" + (pct >= 100 ? "Completed" : pct + "% done") + "</span></div>";
        }

        protected int GetLessonCount(int courseId)
        {
            int count;
            return _lessonCounts.TryGetValue(courseId, out count) ? count : 0;
        }
    }
}
