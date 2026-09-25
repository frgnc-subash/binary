using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using binary.Core.BLL;
using binary.Models;

namespace binary.Admin
{
    public partial class AdminLanguages : Page
    {
        private static readonly Dictionary<string, string> ActionMessages = new Dictionary<string, string>
        {
            { "language-saved", "Language family saved successfully." },
            { "language-deleted", "Language family deleted." },
        };

        private static string WithMsg(string url, string msg)
        {
            string baseUrl = url;
            int qIndex = url.IndexOf('?');
            if (qIndex >= 0)
            {
                string path = url.Substring(0, qIndex);
                var kept = url.Substring(qIndex + 1).Split('&')
                    .Where(p => p.Length > 0 && !p.StartsWith("msg=", StringComparison.OrdinalIgnoreCase))
                    .ToList();
                baseUrl = kept.Count > 0 ? path + "?" + string.Join("&", kept) : path;
            }
            return baseUrl + (baseUrl.IndexOf('?') >= 0 ? "&" : "?") + "msg=" + msg;
        }

        private class LanguageGroupVM
        {
            public int CategoryId { get; set; }
            public string CategoryName { get; set; }
            public int CourseCount { get; set; }
            public int LearnerCount { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // admin authorization is enforced centrally by AdminMaster (runs earlier, in Init)
            if (!IsPostBack)
            {
                string msgKey = Request.QueryString["msg"];
                string msgText;
                if (!string.IsNullOrEmpty(msgKey) && ActionMessages.TryGetValue(msgKey, out msgText))
                {
                    litActionSuccess.Text = msgText;
                    pnlActionSuccess.Visible = true;
                }

                int categoryId;
                string idParam = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idParam) && int.TryParse(idParam, out categoryId) && categoryId > 0)
                {
                    LoadLanguageForEdit(categoryId);
                }
                else if (Request.QueryString["new"] == "1")
                {
                    hfCategoryId.Value = "";
                    litFormTitle.Text = "Add Language Family";
                    pnlLanguageForm.Visible = true;
                }
            }

            BindLanguages();
        }

        private void LoadLanguageForEdit(int categoryId)
        {
            try
            {
                Category c = new CategoryBLL().GetCategoryById(categoryId);
                hfCategoryId.Value = c.CategoryID.ToString();
                txtLanguageName.Text = c.Name;
                litFormTitle.Text = "Edit Language Family";
                pnlLanguageForm.Visible = true;
            }
            catch (ValidationException)
            {
                Response.Redirect("~/Admin/Languages.aspx");
            }
        }

        private List<LanguageGroupVM> BuildLanguageGroups()
        {
            var categories = new CategoryBLL().GetAllCategories();
            var stats = new EnrollmentBLL().GetEnrollmentCountsByCourse();

            return categories.Select(cat => new LanguageGroupVM
            {
                CategoryId = cat.CategoryID,
                CategoryName = cat.Name,
                CourseCount = stats.Count(s => s.CategoryId == cat.CategoryID),
                LearnerCount = stats.Where(s => s.CategoryId == cat.CategoryID).Sum(s => s.EnrollmentCount)
            }).ToList();
        }

        private void BindLanguages()
        {
            var groups = BuildLanguageGroups();

            litTotalLanguages.Text = groups.Count.ToString();
            litTotalCourses.Text = groups.Sum(g => g.CourseCount).ToString();
            litTotalLearners.Text = groups.Sum(g => g.LearnerCount).ToString();

            // every family is rendered; search and paging happen in the browser (Scripts/binary-ui.js)
            rptLanguages.DataSource = groups.OrderByDescending(g => g.LearnerCount).ThenBy(g => g.CategoryName).ToList();
            rptLanguages.DataBind();
        }

        protected void btnSaveLanguage_Click(object sender, EventArgs e)
        {
            try
            {
                var bll = new CategoryBLL();
                int categoryId;
                if (!string.IsNullOrEmpty(hfCategoryId.Value) && int.TryParse(hfCategoryId.Value, out categoryId) && categoryId > 0)
                {
                    bll.UpdateCategory(new Category { CategoryID = categoryId, Name = txtLanguageName.Text.Trim() });
                }
                else
                {
                    bll.AddCategory(new Category { Name = txtLanguageName.Text.Trim() });
                }
                Response.Redirect(WithMsg("~/Admin/Languages.aspx", "language-saved"));
            }
            catch (ValidationException vex)
            {
                litLanguageError.Text = Server.HtmlEncode(vex.Message);
                pnlLanguageError.Visible = true;
                pnlLanguageForm.Visible = true;
            }
            catch (System.Threading.ThreadAbortException)
            {
                throw;   // Response.Redirect ends the request this way; not an error
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Save language family failed: {0}", ex);
                litLanguageError.Text = "Something went wrong saving this language family. Please try again.";
                pnlLanguageError.Visible = true;
                pnlLanguageForm.Visible = true;
            }
        }

        protected void rptLanguages_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteLanguage") return;

            int categoryId = Convert.ToInt32(e.CommandArgument);
            try
            {
                new CategoryBLL().DeleteCategory(categoryId);
                Response.Redirect(WithMsg("~/Admin/Languages.aspx", "language-deleted"));
            }
            catch (ValidationException vex)
            {
                litLanguageError.Text = Server.HtmlEncode(vex.Message);
                pnlLanguageError.Visible = true;
            }
            catch (System.Threading.ThreadAbortException)
            {
                throw;   // Response.Redirect ends the request this way; not an error
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Delete language family {0} failed: {1}", categoryId, ex);
                litLanguageError.Text = "Something went wrong. Please try again.";
                pnlLanguageError.Visible = true;
            }
        }
    }
}
