using System;
using System.Linq;
using System.Web.UI;
using binary.Core.BLL;
using binary.Core.Helpers;

namespace binary.Admin
{
    public partial class AdminHome : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // admin authorization is enforced centrally by AdminMaster (runs earlier, in Init)
            if (!IsPostBack)
            {
                var allUsers = new UserBLL().GetAllUsers();
                litTotalUsers.Text = allUsers.Count.ToString();
                litActiveCourses.Text = new CourseBLL().GetPublishedCourses().Count.ToString();
                litLessonsCompleted.Text = new EnrollmentBLL().CountAllCompletedLessons().ToString();

                DateTime weekStart = DateTime.UtcNow.Date.AddDays(-6);
                litNewThisWeek.Text = allUsers.Count(u => u.CreatedDate.Date >= weekStart).ToString();

                var signupChart = DisplayHelper.BuildDailyChart(day => allUsers.Count(u => u.CreatedDate.Date == day));
                rptSignupChart.DataSource = signupChart;
                rptSignupChart.DataBind();

                // GetAllUsers is already ordered by CreatedDate DESC
                rptRecentUsers.DataSource = allUsers.Take(5);
                rptRecentUsers.DataBind();
                pnlRecentUsers.Visible = allUsers.Count > 0;
                pnlNoRecentUsers.Visible = allUsers.Count == 0;
            }
        }
    }
}
