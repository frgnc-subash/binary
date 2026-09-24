using System;
using System.Linq;
using System.Web.UI;
using binary.Core.BLL;

namespace binary.Pages
{
    public partial class About : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;

            // call to action matches who's looking
            if (AuthBLL.IsLoggedIn)
            {
                string dashboard = AuthBLL.IsAdmin ? "~/Admin/Default.aspx" : "~/Users/Profile.aspx";
                lnkHeroSecondary.HRef = dashboard;
                lnkHeroSecondary.InnerText = "Go to your dashboard";
                lnkCtaBottom.HRef = "~/Courses";
                lnkCtaBottom.InnerText = "Browse courses";
            }

            BindStats();
        }

        // live counts from the database, so the page never claims numbers the platform doesn't have
        private void BindStats()
        {
            try
            {
                var courses = new CourseBLL().GetPublishedCourses();
                var lessonCounts = new LessonBLL().GetLessonCountsByCourse();
                int lessons = courses.Sum(c => lessonCounts.ContainsKey(c.CourseID) ? lessonCounts[c.CourseID] : 0);

                litStatCourses.Text = courses.Count.ToString("N0");
                litStatLessons.Text = lessons.ToString("N0");
                litStatFamilies.Text = new CategoryBLL().GetAllCategories().Count.ToString("N0");
                litStatLearners.Text = new UserBLL().GetAllUsers().Count(u => u.IsActive && !string.Equals(u.RoleName, "Admin", StringComparison.OrdinalIgnoreCase)).ToString("N0");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("About page stats failed: {0}", ex);
                litStatCourses.Text = litStatLessons.Text = litStatFamilies.Text = litStatLearners.Text = "—";
            }
        }
    }
}
