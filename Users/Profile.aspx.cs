using System;
using System.Collections.Generic;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using binary.Core.BLL;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Users
{
    public partial class Profile : Page
    {
        private readonly UserBLL _userBll = new UserBLL();

        protected string ActiveTab
        {
            get { return string.IsNullOrEmpty(hfActiveTab.Value) ? "tab-dash" : hfActiveTab.Value; }
        }

        protected string GetTabPaneClass(string tabId)
        {
            return tabId == ActiveTab ? "tab-pane active" : "tab-pane";
        }

        protected string GetNavBtnClass(string tabId)
        {
            return tabId == ActiveTab ? "learner-nav-btn active" : "learner-nav-btn";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // enforce session authentication
            if (!AuthBLL.IsLoggedIn)
            {
                Response.Redirect("~/Auth/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl), true);
                return;
            }

            if (!IsPostBack)
            {
                ApplyRequestedTab();
                LoadUserProfile();
                LoadEnrollments();
                LoadPracticeList();
            }
        }

        // lets other pages deep-link straight to a tab, e.g. ~/Users/Profile.aspx?tab=profile
        // instead of always landing on the dashboard overview
        private static readonly Dictionary<string, string> TabQueryStringMap = new Dictionary<string, string>
        {
            { "dash", "tab-dash" },
            { "practice", "tab-practice" },
            { "profile", "tab-profile" },
            { "security", "tab-security" },
            { "exp", "tab-exp" },
            { "badges", "tab-exp" },   // old name, kept so earlier links still work
        };

        private void ApplyRequestedTab()
        {
            string tabId;
            if (!string.IsNullOrEmpty(Request.QueryString["tab"]) &&
                TabQueryStringMap.TryGetValue(Request.QueryString["tab"], out tabId))
            {
                hfActiveTab.Value = tabId;
            }
        }

        private void LoadEnrollments()
        {
            int userId = AuthBLL.CurrentUserId;
            try
            {
                var enrollments = new EnrollmentBLL().GetUserEnrollments(userId);

                litActiveCoursesCount.Text = enrollments.Count.ToString();
                rptEnrollments.DataSource = enrollments;
                rptEnrollments.DataBind();
                pnlNoEnrollments.Visible = enrollments.Count == 0;

                User user = _userBll.GetProfile(userId);
                litTotalXp.Text = user.TotalXP.ToString();
                litRank.Text = _userBll.GetRank(userId).ToString();

                int completedCount = 0;
                var enrollmentBll = new EnrollmentBLL();
                foreach (var en in enrollments)
                {
                    completedCount += enrollmentBll.GetCompletedLessonIds(en.EnrollmentID).Count;
                }
                litCompletedLessonsCount.Text = completedCount.ToString();
                BindTitle(user.TotalXP);
                litStreak.Text = enrollmentBll.GetCurrentStreak(userId).ToString();

                var activityCounts = enrollmentBll.GetWeeklyActivity(userId);
                var activityChart = DisplayHelper.BuildDailyChart(day =>
                {
                    int count;
                    activityCounts.TryGetValue(day, out count);
                    return count;
                });
                rptActivityChart.DataSource = activityChart;
                rptActivityChart.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Failed to load enrollments for user {0}: {1}", userId, ex);
                ShowError("Unable to load your courses right now. Please try again later.");
            }
        }

        private class TitleCardVM
        {
            public string Emoji { get; set; }
            public string Name { get; set; }
            public string RangeText { get; set; }
            public string Description { get; set; }
            public string StateClass { get; set; }
            public string BadgeClass { get; set; }
            public string BadgeText { get; set; }
        }

        // the title shows in the sidebar card, the Profile tab, and the Exp Earned tab
        private void BindTitle(int xp)
        {
            LearnerTitle current = LearnerTitles.For(xp);
            LearnerTitle next = LearnerTitles.Next(xp);

            litLearnerLevel.Text = Server.HtmlEncode(current.Display);
            litProfileTitle.Text = Server.HtmlEncode(current.Display);
            litProfileTitleHint.Text = Server.HtmlEncode(next != null
                ? xp.ToString("N0") + " XP · " + (next.MinXp - xp).ToString("N0") + " XP to " + next.Display
                : xp.ToString("N0") + " XP · highest title reached");

            litExpTitleEmoji.Text = Server.HtmlEncode(current.Emoji);
            litExpTitleName.Text = Server.HtmlEncode(current.Name);
            litExpTotal.Text = xp.ToString("N0");

            double progress = 100;
            if (next != null)
            {
                progress = (xp - current.MinXp) * 100.0 / (next.MinXp - current.MinXp);
                litExpToNext.Text = Server.HtmlEncode((next.MinXp - xp).ToString("N0") + " XP to " + next.Display);
            }
            else
            {
                litExpToNext.Text = "Highest title reached";
            }
            expProgressBar.Style["width"] = Math.Max(0, Math.Min(100, progress)).ToString("0.#", System.Globalization.CultureInfo.InvariantCulture) + "%";

            var cards = new List<TitleCardVM>();
            for (int i = 0; i < LearnerTitles.All.Count; i++)
            {
                LearnerTitle t = LearnerTitles.All[i];
                LearnerTitle following = i + 1 < LearnerTitles.All.Count ? LearnerTitles.All[i + 1] : null;
                bool isCurrent = t.MinXp == current.MinXp;
                bool isUnlocked = t.MinXp <= xp;

                cards.Add(new TitleCardVM
                {
                    Emoji = t.Emoji,
                    Name = Server.HtmlEncode(t.Name),
                    Description = Server.HtmlEncode(t.Description),
                    RangeText = following != null
                        ? t.MinXp.ToString("N0") + " – " + (following.MinXp - 1).ToString("N0") + " XP"
                        : t.MinXp.ToString("N0") + "+ XP",
                    StateClass = isCurrent ? "exp-tier-current" : (isUnlocked ? "exp-tier-unlocked" : "exp-tier-locked"),
                    BadgeClass = isCurrent ? "badge-primary" : (isUnlocked ? "badge-success" : "badge-muted"),
                    BadgeText = isCurrent ? "Current title" : (isUnlocked ? "Unlocked" : (t.MinXp - xp).ToString("N0") + " XP to go")
                });
            }
            rptTitles.DataSource = cards;
            rptTitles.DataBind();
        }

        private void LoadUserProfile()
        {
            int userId = AuthBLL.CurrentUserId;
            try
            {
                User user = _userBll.GetProfile(userId);
                if (user != null)
                {
                    txtFirstName.Text = user.FirstName;
                    txtLastName.Text = user.LastName;
                    txtEmail.Text = user.Email;

                    litFullName.Text = Server.HtmlEncode(user.FullName);

                    // calculate initials for avatar
                    string initials = "U";
                    if (!string.IsNullOrWhiteSpace(user.FirstName))
                    {
                        initials = user.FirstName.Substring(0, 1).ToUpperInvariant();
                        if (!string.IsNullOrWhiteSpace(user.LastName))
                        {
                            initials += user.LastName.Substring(0, 1).ToUpperInvariant();
                        }
                    }
                    litAvatar.Text = Server.HtmlEncode(initials);
                    litHeaderAvatar.Text = Server.HtmlEncode(initials);
                    litAvatarPreview.Text = Server.HtmlEncode(initials);

                    bool hasAvatar = !string.IsNullOrWhiteSpace(user.ProfileImageUrl);
                    imgAvatarSidebar.Visible = hasAvatar;
                    imgAvatarHeader.Visible = hasAvatar;
                    imgAvatarPreview.Visible = hasAvatar;
                    litAvatar.Visible = !hasAvatar;
                    litHeaderAvatar.Visible = !hasAvatar;
                    litAvatarPreview.Visible = !hasAvatar;

                    if (hasAvatar)
                    {
                        string avatarUrl = ResolveUrl(user.ProfileImageUrl);
                        imgAvatarSidebar.ImageUrl = avatarUrl;
                        imgAvatarHeader.ImageUrl = avatarUrl;
                        imgAvatarPreview.ImageUrl = avatarUrl;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Failed to load profile for user {0}: {1}", userId, ex);
                ShowError("Unable to load your profile right now. Please try again later.");
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            ClearAlerts();
            if (Page.IsValid)
            {
                try
                {
                    int userId = AuthBLL.CurrentUserId;

                    if (fuAvatar.HasFile)
                    {
                        string error;
                        if (!AvatarHelper.IsValidImage(fuAvatar.PostedFile, out error))
                        {
                            ShowError(error);
                            return;
                        }

                        string oldImageUrl = _userBll.GetProfile(userId).ProfileImageUrl;

                        string folderPath = Server.MapPath(AvatarHelper.AvatarFolderVirtualPath);
                        if (!Directory.Exists(folderPath))
                            Directory.CreateDirectory(folderPath);

                        string fileName = AvatarHelper.BuildFileName(userId, fuAvatar.FileName);
                        fuAvatar.SaveAs(Path.Combine(folderPath, fileName));

                        _userBll.UpdateProfilePicture(userId, AvatarHelper.AvatarFolderVirtualPath + fileName);

                        if (!string.IsNullOrWhiteSpace(oldImageUrl))
                        {
                            try
                            {
                                string oldPhysicalPath = Server.MapPath(oldImageUrl);
                                if (File.Exists(oldPhysicalPath)) File.Delete(oldPhysicalPath);
                            }
                            catch (Exception ex)
                            {
                                System.Diagnostics.Trace.TraceError("Failed to delete old avatar for user {0}: {1}", userId, ex);
                            }
                        }
                    }

                    _userBll.UpdateProfile(userId, txtFirstName.Text, txtLastName.Text);

                    // refresh session display name / avatar
                    User u = _userBll.GetProfile(userId);
                    AuthBLL.EstablishSession(u);

                    LoadUserProfile();
                    ShowSuccess("Profile updated successfully!");
                }
                catch (ValidationException vex)
                {
                    ShowError(vex.Message);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Update profile failed for user {0}: {1}", AuthBLL.CurrentUserId, ex);
                    ShowError("Failed to update profile. Please try again.");
                }
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            ClearAlerts();
            if (Page.IsValid)
            {
                try
                {
                    int userId = AuthBLL.CurrentUserId;
                    _userBll.ChangePassword(userId, txtCurrentPassword.Text, txtNewPassword.Text);

                    txtCurrentPassword.Text = string.Empty;
                    txtNewPassword.Text = string.Empty;
                    txtConfirmNewPassword.Text = string.Empty;

                    ShowSuccess("Password changed successfully!");
                }
                catch (ValidationException vex)
                {
                    ShowError(vex.Message);
                }
                catch (Exception)
                {
                    ShowError("Failed to change password. Please try again.");
                }
            }
        }

        private void LoadPracticeList()
        {
            int userId = AuthBLL.CurrentUserId;
            try
            {
                var quizBll = new QuizBLL();

                var quizzes = quizBll.GetQuizzesForEnrolledCourses(userId);
                rptQuizzes.DataSource = quizzes;
                rptQuizzes.DataBind();
                pnlNoQuizzes.Visible = quizzes.Count == 0;

                var attempts = quizBll.GetUserAttempts(userId);
                rptAttempts.DataSource = attempts;
                rptAttempts.DataBind();
                pnlNoAttempts.Visible = attempts.Count == 0;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Failed to load practice list for user {0}: {1}", userId, ex);
                ShowError("Unable to load practice quizzes right now. Please try again later.");
            }

            pnlQuizList.Visible = true;
            pnlQuizPlay.Visible = false;
            pnlQuizResult.Visible = false;
        }

        private void StartQuiz(int quizId)
        {
            Quiz quiz = new QuizBLL().GetQuizWithQuestions(AuthBLL.CurrentUserId, quizId);

            hfPlayQuizId.Value = quiz.QuizID.ToString();
            litPlayQuizTitle.Text = Server.HtmlEncode(quiz.Title);
            rptQuestions.DataSource = quiz.Questions;
            rptQuestions.DataBind();

            pnlQuizList.Visible = false;
            pnlQuizPlay.Visible = true;
            pnlQuizResult.Visible = false;
        }

        protected void rptQuizzes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "StartQuiz") return;
            hfActiveTab.Value = "tab-practice";

            try
            {
                StartQuiz(Convert.ToInt32(e.CommandArgument));
            }
            catch (ValidationException vex)
            {
                ShowError(vex.Message);
                LoadPracticeList();
            }
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            hfActiveTab.Value = "tab-practice";
            try
            {
                int quizId = int.Parse(hfPlayQuizId.Value);
                var answers = new Dictionary<int, int>();

                foreach (RepeaterItem item in rptQuestions.Items)
                {
                    var hfQuestionId = (HiddenField)item.FindControl("hfQuestionId");
                    var rbl = (RadioButtonList)item.FindControl("rblOptions");
                    if (hfQuestionId == null || rbl == null) continue;

                    if (rbl.SelectedIndex >= 0)
                    {
                        answers[int.Parse(hfQuestionId.Value)] = int.Parse(rbl.SelectedValue);
                    }
                }

                QuizResult result = new QuizBLL().SubmitAttempt(AuthBLL.CurrentUserId, quizId, answers);
                ShowQuizResult(result);
                // XP (and possibly the title) just changed; refresh the sidebar, KPIs and Exp Earned tab
                LoadEnrollments();
            }
            catch (ValidationException vex)
            {
                ShowError(vex.Message);
                LoadPracticeList();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Quiz submit failed for user {0}: {1}", AuthBLL.CurrentUserId, ex);
                ShowError("Something went wrong submitting your quiz. Please try again.");
                LoadPracticeList();
            }
        }

        private void ShowQuizResult(QuizResult result)
        {
            litResultScore.Text = result.Score + " / " + result.MaxScore;
            litResultXp.Text = result.XpAwarded.ToString();

            if (result.Percent >= 80)
            {
                litResultEmoji.Text = "🌟";
                litResultMessage.Text = "Excellent work!";
            }
            else if (result.Percent >= 50)
            {
                litResultEmoji.Text = "👍";
                litResultMessage.Text = "Good effort — keep practicing!";
            }
            else
            {
                litResultEmoji.Text = "💪";
                litResultMessage.Text = "Keep at it, you'll get there!";
            }

            pnlQuizList.Visible = false;
            pnlQuizPlay.Visible = false;
            pnlQuizResult.Visible = true;
        }

        protected string GetScoreBadge(int score, int maxScore)
        {
            int pct = maxScore > 0 ? (int)Math.Round(score * 100.0 / maxScore) : 0;
            if (pct >= 80) return "<span class=\"badge badge-success\">" + pct + "%</span>";
            if (pct >= 50) return "<span class=\"badge badge-primary\">" + pct + "%</span>";
            return "<span class=\"badge badge-muted\">" + pct + "%</span>";
        }

        protected void lnkCancelQuiz_Click(object sender, EventArgs e)
        {
            hfActiveTab.Value = "tab-practice";
            LoadPracticeList();
        }

        protected void lnkRetryQuiz_Click(object sender, EventArgs e)
        {
            hfActiveTab.Value = "tab-practice";
            try
            {
                StartQuiz(int.Parse(hfPlayQuizId.Value));
            }
            catch (ValidationException vex)
            {
                ShowError(vex.Message);
                LoadPracticeList();
            }
        }

        protected void lnkBackToList_Click(object sender, EventArgs e)
        {
            hfActiveTab.Value = "tab-practice";
            LoadPracticeList();
        }

        private void ClearAlerts()
        {
            ProfileAlertPanel.Visible = false;
            ProfileErrorPanel.Visible = false;
        }

        private void ShowSuccess(string message)
        {
            litProfileAlert.Text = Server.HtmlEncode(message);
            ProfileAlertPanel.Visible = true;
        }

        private void ShowError(string message)
        {
            litProfileError.Text = Server.HtmlEncode(message);
            ProfileErrorPanel.Visible = true;
        }
    }
}
