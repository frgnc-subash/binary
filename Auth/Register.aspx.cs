using System;
using System.Web.UI;
using binary.Core.BLL;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Auth
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (AuthBLL.IsLoggedIn)
                {
                    Response.Redirect(GetPostAuthRedirect(), true);
                }
            }

            OnboardingChoice plan = OnboardingBLL.Current;
            if (plan != null)
            {
                pnlOnboarding.Visible = true;
                litOnboardingFlag.Text = FlagHelper.Render(plan.CourseFlagUrl, plan.CourseTitle, "flag-md");
                litOnboardingCourse.Text = Server.HtmlEncode(plan.CourseTitle);
                litOnboardingMeta.Text = Server.HtmlEncode("You speak " + plan.NativeLanguage +
                    (string.IsNullOrEmpty(plan.Reason) ? "" : (plan.Reason.Contains(",") ? " · Goals: " : " · Goal: ") + plan.Reason));
            }
        }

        private string GetPostAuthRedirect()
        {
            string returnUrl = Request.QueryString["ReturnUrl"];
            if (AuthBLL.IsSafeReturnUrl(returnUrl))
                return returnUrl;
            return AuthBLL.IsAdmin ? "~/Admin" : "~/Users/Profile.aspx";
        }

        // carries the current ReturnUrl (if any) across to the other auth page, so switching
        // between Sign In and Register doesn't lose track of where the guest was headed
        protected string BuildAuthCrossLink(string path)
        {
            string returnUrl = Request.QueryString["ReturnUrl"];
            string resolved = ResolveUrl(path);
            return AuthBLL.IsSafeReturnUrl(returnUrl)
                ? resolved + "?ReturnUrl=" + Server.UrlEncode(returnUrl)
                : resolved;
        }

        protected void RegisterBtn_Click(object sender, EventArgs e)
        {
            ErrorPanel.Visible = false;
            SuccessPanel.Visible = false;

            if (Page.IsValid)
            {
                if (!AgreeTerms.Checked)
                {
                    litRegisterError.Text = "Please agree to the Terms of Service to continue.";
                    ErrorPanel.Visible = true;
                    return;
                }

                string firstName = FirstName.Text.Trim();
                string lastName = LastName.Text.Trim();
                string email = EmailInput.Text.Trim();
                string password = PasswordInput.Text;

                int newUserId;
                try
                {
                    newUserId = new UserBLL().Register(firstName, lastName, email, password);
                }
                catch (ValidationException vex)
                {
                    litRegisterError.Text = Server.HtmlEncode(vex.Message);
                    ErrorPanel.Visible = true;
                    return;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Registration failed for {0}: {1}", email, ex);
                    litRegisterError.Text = "We couldn't create your account right now. Please try again in a moment.";
                    ErrorPanel.Visible = true;
                    return;
                }

                // account was created successfully at this point; auto-login is best-effort
                try
                {
                    AuthBLL.Login(email, password);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Auto-login after registration failed for {0}: {1}", email, ex);
                    Response.Redirect(BuildAuthCrossLink("~/Auth/Login.aspx"), false);
                    return;
                }

                litRegisterSuccess.Text = "Welcome to Binary! Your account has been created.";
                SuccessPanel.Visible = true;

                // save the onboarding answers and enroll them in the course they picked
                int onboardingCourseId = OnboardingBLL.ApplyToNewUser(newUserId);

                // a return url (e.g. the course they were trying to enroll in) wins; otherwise straight
                // into the course chosen during onboarding, or the dashboard
                string returnUrl = Request.QueryString["ReturnUrl"];
                if (!AuthBLL.IsSafeReturnUrl(returnUrl) && onboardingCourseId > 0)
                    Response.Redirect("~/Courses/Detail.aspx?id=" + onboardingCourseId + "&welcome=1", false);
                else
                    Response.Redirect(GetPostAuthRedirect(), false);
            }
        }
    }
}
