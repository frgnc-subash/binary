using System;
using System.Collections.Generic;
using System.Web.UI;
using binary.Core.BLL;

namespace binary.Courses
{
    public partial class CoursesHome : Page
    {
        private Dictionary<int, int> _lessonCounts = new Dictionary<int, int>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var courses = new CourseBLL().GetPublishedCourses();
                _lessonCounts = new LessonBLL().GetLessonCountsByCourse();
                rptCourses.DataSource = courses;
                rptCourses.DataBind();
                pnlNoCourses.Visible = courses.Count == 0;
            }
        }

        protected int GetLessonCount(int courseId)
        {
            int count;
            return _lessonCounts.TryGetValue(courseId, out count) ? count : 0;
        }
    }
}
