using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using binary.Core.BLL;
using binary.Core.DAL;

namespace binary.Admin
{
    public partial class AdminReports : Page
    {
        private class ActivityItem
        {
            public string Icon { get; set; }
            public string Text { get; set; }
            public DateTime Date { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // admin authorization is enforced centrally by AdminMaster (runs earlier, in Init)
            if (!IsPostBack)
            {
                BindCatalogueHealth();
                BindTopCourses();
                BindQuizStats();
                BindActivity();
            }
        }

        private void BindCatalogueHealth()
        {
            var allCourses = new CourseBLL().GetAllCourses();
            int total = allCourses.Count;
            int published = allCourses.Count(c => c.IsPublished);
            int draft = total - published;

            litTotalCourses.Text = total.ToString();
            litPublishedCount.Text = published.ToString();
            litDraftCount.Text = draft.ToString();

            double publishedPct = total > 0 ? published * 100.0 / total : 0;
            double draftPct = total > 0 ? draft * 100.0 / total : 0;
            segPublished.Style["width"] = publishedPct.ToString("0.##") + "%";
            segDraft.Style["width"] = draftPct.ToString("0.##") + "%";
        }

        private void BindTopCourses()
        {
            var stats = new EnrollmentBLL().GetEnrollmentCountsByCourse();
            litTotalEnrollments.Text = stats.Sum(s => s.EnrollmentCount).ToString();

            rptTopCourses.DataSource = stats.Take(5);
            rptTopCourses.DataBind();
        }

        private void BindQuizStats()
        {
            QuizAttemptsSummary summary = new QuizBLL().GetAttemptsSummary();
            litQuizAttempts.Text = summary.Count.ToString();
            litAvgScore.Text = Math.Round(summary.AvgPercent).ToString() + "%";
        }

        private void BindActivity()
        {
            var items = new List<ActivityItem>();

            const string signupIcon = "<svg class=\"admin-icon\" style=\"width:14px;height:14px;\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.75\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2\"></path><circle cx=\"8.5\" cy=\"7\" r=\"4\"></circle><line x1=\"19\" y1=\"8\" x2=\"19\" y2=\"14\"></line><line x1=\"16\" y1=\"11\" x2=\"22\" y2=\"11\"></line></svg>";
            const string enrollIcon = "<svg class=\"admin-icon\" style=\"width:14px;height:14px;\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.75\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z\"></path><path d=\"M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z\"></path></svg>";
            const string quizIcon = "<svg class=\"admin-icon\" style=\"width:14px;height:14px;\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.75\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"m3 7 2 2 4-4\"></path><path d=\"m3 15 2 2 4-4\"></path><line x1=\"11\" y1=\"8\" x2=\"21\" y2=\"8\"></line><line x1=\"11\" y1=\"16\" x2=\"21\" y2=\"16\"></line></svg>";

            foreach (var u in new UserBLL().GetAllUsers().Take(5))
            {
                items.Add(new ActivityItem
                {
                    Icon = signupIcon,
                    Text = u.FullName + " joined the platform",
                    Date = u.CreatedDate
                });
            }

            foreach (var en in new EnrollmentBLL().GetRecentEnrollments(8))
            {
                items.Add(new ActivityItem
                {
                    Icon = enrollIcon,
                    Text = en.UserName + " enrolled in " + en.CourseTitle,
                    Date = en.EnrolledDate
                });
            }

            foreach (var at in new QuizBLL().GetRecentAttempts(8))
            {
                items.Add(new ActivityItem
                {
                    Icon = quizIcon,
                    Text = at.UserName + " scored " + at.Score + "/" + at.MaxScore + " on " + at.QuizTitle,
                    Date = at.AttemptDate
                });
            }

            var merged = items.OrderByDescending(a => a.Date).Take(12).ToList();
            rptActivity.DataSource = merged;
            rptActivity.DataBind();
            pnlNoActivity.Visible = merged.Count == 0;
        }
    }
}
