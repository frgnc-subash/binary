using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using binary.Core.BLL;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Admin
{
    public partial class AdminCourses : System.Web.UI.Page
    {
        private static readonly Dictionary<string, string> ActionMessages = new Dictionary<string, string>
        {
            { "course-saved", "Course saved successfully." },
            { "course-deleted", "Course deleted." },
            { "course-published", "Course published." },
            { "course-unpublished", "Course moved back to draft." },
            { "lesson-saved", "Lesson saved successfully." },
            { "lesson-deleted", "Lesson deleted." },
            { "category-added", "Category added." },
            { "category-renamed", "Category renamed." },
            { "category-deleted", "Category deleted." },
            { "quiz-deleted", "Lesson quiz deleted." },
        };

        // appends a success flag to a redirect target, replacing any existing msg param
        // (Request.RawUrl may already carry one, e.g. toggling publish twice in a row)
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

        protected void Page_Load(object sender, EventArgs e)
        {
            // admin authorization is enforced centrally by AdminMaster (runs earlier, in Init)
            if (!IsPostBack)
            {
                // Only bind on the initial GET. Rebinding rptCategories on every postback would
                // reset txtCategoryRename (Eval-bound) back to its original DB value before
                // rptCategories_ItemCommand reads the posted rename text, silently discarding it.
                BindCategoriesDropdown();
                BindCategoryList();
                BindCategoryFilterDropdown();
                BindFlagDropdown();

                // the admin header search box arrives as ?q=...; the list script reads it from the URL

                string msgKey = Request.QueryString["msg"];
                string msgText;
                if (!string.IsNullOrEmpty(msgKey) && ActionMessages.TryGetValue(msgKey, out msgText))
                {
                    litActionSuccess.Text = msgText;
                    pnlActionSuccess.Visible = true;
                }

                int courseId;
                string idParam = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idParam) && int.TryParse(idParam, out courseId) && courseId > 0)
                {
                    LoadCourseForEdit(courseId);
                }
                else if (Request.QueryString["new"] == "1")
                {
                    hfCourseId.Value = "";
                    pnlCourseForm.Visible = true;
                }
            }

            BindCourseList();

            if (!string.IsNullOrEmpty(hfCourseId.Value))
            {
                pnlLessons.Visible = true;
                BindLessons(int.Parse(hfCourseId.Value));
            }
            else
            {
                pnlLessons.Visible = false;
            }
        }

        private void BindCategoriesDropdown()
        {
            ddlCategory.DataSource = new CategoryBLL().GetAllCategories();
            ddlCategory.DataBind();
        }

        private void BindFlagDropdown()
        {
            ddlFlag.Items.Clear();
            ddlFlag.Items.Add(new ListItem("No flag", ""));
            foreach (FlagOption flag in FlagHelper.GetLibrary())
                ddlFlag.Items.Add(new ListItem(flag.Label, flag.FileName));
        }

        private void BindCategoryFilterDropdown()
        {
            ddlCategoryFilter.DataSource = new CategoryBLL().GetAllCategories();
            ddlCategoryFilter.DataBind();
        }

        // a category with how many courses use it, for the sidebar list
        protected class CategoryRow
        {
            public int CategoryID { get; set; }
            public string Name { get; set; }
            public int CourseCount { get; set; }
        }

        private void BindCategoryList()
        {
            var courses = new CourseBLL().GetAllCourses();
            var rows = new CategoryBLL().GetAllCategories().Select(c => new CategoryRow
            {
                CategoryID = c.CategoryID,
                Name = c.Name,
                CourseCount = courses.Count(x => x.CategoryID == c.CategoryID)
            }).ToList();

            rptCategories.DataSource = rows;
            rptCategories.DataBind();
            pnlNoCategories.Visible = rows.Count == 0;
            litCategoryTotal.Text = rows.Count.ToString();
        }

        // Every course is rendered; search, filters and paging happen in the browser
        // (Scripts/binary-ui.js), so filtering never reloads the page.
        private void BindCourseList()
        {
            var courses = new CourseBLL().GetAllCourses();
            rptCourses.DataSource = courses;
            rptCourses.DataBind();
        }

        // what the search box matches against: title and category, lower-cased
        protected string GetCourseSearchText(object dataItem)
        {
            var course = (Course)dataItem;
            return HttpUtility.HtmlAttributeEncode((course.Title + " " + course.CategoryName).ToLowerInvariant());
        }

        // lessonId -> quiz, for the Quiz column of the lesson table
        private Dictionary<int, Quiz> _lessonQuizzes = new Dictionary<int, Quiz>();

        private void BindLessons(int courseId)
        {
            _lessonQuizzes = new QuizBLL().GetLessonQuizzes(courseId);
            rptLessons.DataSource = new LessonBLL().GetLessonsByCourse(courseId);
            rptLessons.DataBind();
        }

        protected string GetQuizBadge(int lessonId)
        {
            Quiz quiz;
            if (!_lessonQuizzes.TryGetValue(lessonId, out quiz))
                return "<span style=\"color:var(--text-subtle);\">None</span>";
            return quiz.QuestionCount == 0
                ? "<span class=\"badge badge-warning\">No questions</span>"
                : "<span class=\"badge badge-success\">" + quiz.QuestionCount + (quiz.QuestionCount == 1 ? " question" : " questions") + "</span>";
        }

        private void LoadCourseForEdit(int courseId)
        {
            try
            {
                Course c = new CourseBLL().GetCourseById(courseId);
                hfCourseId.Value = c.CourseID.ToString();
                txtTitle.Text = c.Title;
                txtDescription.Text = c.Description;
                ddlCategory.SelectedValue = c.CategoryID.ToString();
                ddlLevel.SelectedValue = c.Level;
                txtThumbnailUrl.Text = c.ThumbnailUrl;
                ListItem flagItem = ddlFlag.Items.FindByValue(FlagHelper.ToFileName(c.FlagImageUrl));
                if (flagItem != null) ddlFlag.SelectedValue = flagItem.Value;
                chkPublished.Checked = c.IsPublished;
                pnlCourseForm.Visible = true;
            }
            catch (ValidationException)
            {
                Response.Redirect("~/Admin/Courses.aspx");
            }
        }

        protected string GetPublishBadge(object isPublished)
        {
            bool published = Convert.ToBoolean(isPublished);
            return published
                ? "<span class=\"badge badge-success\">Published</span>"
                : "<span class=\"badge badge-muted\">Draft</span>";
        }

        protected string GetToggleLabel(object isPublished)
        {
            return Convert.ToBoolean(isPublished) ? "Unpublish" : "Publish";
        }

        protected void btnSaveCourse_Click(object sender, EventArgs e)
        {
            try
            {
                int categoryId;
                int.TryParse(ddlCategory.SelectedValue, out categoryId);

                var c = new Course
                {
                    Title = txtTitle.Text.Trim(),
                    Description = txtDescription.Text.Trim(),
                    CategoryID = categoryId,
                    Level = ddlLevel.SelectedValue,
                    ThumbnailUrl = string.IsNullOrWhiteSpace(txtThumbnailUrl.Text) ? null : txtThumbnailUrl.Text.Trim(),
                    // a newly uploaded flag wins; otherwise the one picked from the library (validated against it)
                    FlagImageUrl = fuFlag.HasFile ? FlagHelper.SaveUpload(fuFlag.PostedFile) : FlagHelper.ToVirtualPath(ddlFlag.SelectedValue),
                    IsPublished = chkPublished.Checked
                };

                var bll = new CourseBLL();
                int courseId;
                if (!string.IsNullOrEmpty(hfCourseId.Value) && int.TryParse(hfCourseId.Value, out courseId) && courseId > 0)
                {
                    c.CourseID = courseId;
                    bll.UpdateCourse(c);
                    Response.Redirect(WithMsg("~/Admin/Courses.aspx?id=" + courseId, "course-saved"));
                }
                else
                {
                    int newId = bll.AddCourse(c, AuthBLL.CurrentUserId);
                    Response.Redirect(WithMsg("~/Admin/Courses.aspx?id=" + newId, "course-saved"));
                }
            }
            catch (ValidationException vex)
            {
                litCourseError.Text = Server.HtmlEncode(vex.Message);
                pnlCourseError.Visible = true;
                pnlCourseForm.Visible = true;
            }
            catch (System.Threading.ThreadAbortException)
            {
                throw;   // Response.Redirect ends the request this way; not an error
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Save course failed: {0}", ex);
                litCourseError.Text = "Something went wrong saving the course. Please try again.";
                pnlCourseError.Visible = true;
                pnlCourseForm.Visible = true;
            }
        }

        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int courseId = Convert.ToInt32(e.CommandArgument);
            var bll = new CourseBLL();

            try
            {
                if (e.CommandName == "DeleteCourse")
                {
                    // the database cascades to lessons, but their uploaded video files live on disk
                    var videos = new LessonBLL().GetLessonsByCourse(courseId).Select(l => l.VideoUrl).ToList();
                    bll.DeleteCourse(courseId);
                    foreach (string video in videos) VideoHelper.TryDeleteUploadedFile(video);
                    Response.Redirect(WithMsg("~/Admin/Courses.aspx", "course-deleted"));
                }
                else if (e.CommandName == "TogglePublish")
                {
                    Course c = bll.GetCourseById(courseId);
                    c.IsPublished = !c.IsPublished;
                    bll.UpdateCourse(c);
                    Response.Redirect(WithMsg(Request.RawUrl, c.IsPublished ? "course-published" : "course-unpublished"));
                }
            }
            catch (ValidationException vex)
            {
                litCourseError.Text = Server.HtmlEncode(vex.Message);
                pnlCourseError.Visible = true;
            }
            catch (System.Threading.ThreadAbortException)
            {
                throw;   // Response.Redirect ends the request this way; not an error
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Course action '{0}' failed for course {1}: {2}", e.CommandName, courseId, ex);
                litCourseError.Text = "Something went wrong. Please try again.";
                pnlCourseError.Visible = true;
            }
        }

        protected void btnSaveLesson_Click(object sender, EventArgs e)
        {
            int courseId = 0;
            string newUpload = null;   // video saved during this request; removed again if the save fails

            try
            {
                courseId = int.Parse(hfCourseId.Value);
                int sortOrder;
                int.TryParse(txtLessonSortOrder.Text, out sortOrder);

                var bll = new LessonBLL();
                int lessonId;
                bool editing = int.TryParse(hfLessonId.Value, out lessonId) && lessonId > 0;
                string currentVideo = editing ? bll.GetLessonById(lessonId).VideoUrl : null;

                string video = ResolveLessonVideo(currentVideo, out newUpload);

                var l = new Lesson
                {
                    CourseID = courseId,
                    Title = txtLessonTitle.Text.Trim(),
                    Content = txtLessonContent.Text.Trim(),
                    VideoUrl = video,
                    SortOrder = sortOrder
                };

                if (editing)
                {
                    l.LessonID = lessonId;
                    bll.UpdateLesson(l);
                }
                else
                {
                    bll.AddLesson(l);
                }

                // replaced or removed: the old uploaded file is no longer referenced
                if (!string.Equals(currentVideo, video, StringComparison.Ordinal))
                    VideoHelper.TryDeleteUploadedFile(currentVideo);
                newUpload = null;
            }
            catch (ValidationException vex)
            {
                VideoHelper.TryDeleteUploadedFile(newUpload);
                litLessonError.Text = Server.HtmlEncode(vex.Message);
                pnlLessonError.Visible = true;
                return;
            }
            catch (Exception ex)
            {
                VideoHelper.TryDeleteUploadedFile(newUpload);
                System.Diagnostics.Trace.TraceError("Save lesson failed: {0}", ex);
                litLessonError.Text = "Something went wrong saving the lesson. Please try again.";
                pnlLessonError.Visible = true;
                return;
            }

            // outside the try: Response.Redirect aborts the thread, which catch (Exception) would intercept
            Response.Redirect(WithMsg("~/Admin/Courses.aspx?id=" + courseId, "lesson-saved"));
        }

        // Precedence: a newly uploaded file, then "Remove video", then a pasted link, then keep the
        // existing uploaded file. An emptied link box on a link-based lesson means "no video".
        private string ResolveLessonVideo(string currentVideo, out string newUpload)
        {
            newUpload = null;

            if (fuLessonVideo.HasFile)
            {
                string error;
                if (!VideoHelper.IsValidUpload(fuLessonVideo.PostedFile, out error))
                    throw new ValidationException(error);

                string folder = Server.MapPath(VideoHelper.VideoFolderVirtualPath);
                Directory.CreateDirectory(folder);
                string fileName = VideoHelper.BuildFileName(fuLessonVideo.FileName);
                fuLessonVideo.SaveAs(Path.Combine(folder, fileName));

                newUpload = VideoHelper.VideoFolderVirtualPath + fileName;
                return newUpload;
            }

            if (chkRemoveVideo.Checked)
                return null;

            string link = (txtLessonVideoUrl.Text ?? "").Trim();
            if (link.Length > 0)
            {
                string normalized;
                string error;
                if (!VideoHelper.TryNormalizeLink(link, out normalized, out error))
                    throw new ValidationException(error);
                return normalized;
            }

            return VideoHelper.IsUploadedVideo(currentVideo) ? currentVideo : null;
        }

        protected string GetVideoBadge(object videoUrl)
        {
            string url = videoUrl as string;
            if (string.IsNullOrEmpty(url))
                return "<span style=\"color:var(--text-subtle);\">—</span>";
            return "<span class=\"badge badge-primary\">" + Icons.Svg("video", "ui-icon ui-icon-before") + Server.HtmlEncode(VideoHelper.GetSourceLabel(url)) + "</span>";
        }

        protected void rptLessons_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int lessonId = Convert.ToInt32(e.CommandArgument);
            var bll = new LessonBLL();

            try
            {
                if (e.CommandName == "EditLesson")
                {
                    Lesson l = bll.GetLessonById(lessonId);
                    hfLessonId.Value = l.LessonID.ToString();
                    txtLessonTitle.Text = l.Title;
                    txtLessonContent.Text = l.Content;
                    txtLessonSortOrder.Text = l.SortOrder.ToString();

                    // uploaded files aren't editable as text; they're shown as "current" with a remove option
                    bool uploaded = VideoHelper.IsUploadedVideo(l.VideoUrl);
                    txtLessonVideoUrl.Text = uploaded ? "" : l.VideoUrl;
                    chkRemoveVideo.Checked = false;
                    pnlCurrentVideo.Visible = !string.IsNullOrEmpty(l.VideoUrl);
                    if (pnlCurrentVideo.Visible)
                    {
                        string href = uploaded ? ResolveUrl(l.VideoUrl) : l.VideoUrl;
                        litCurrentVideo.Text = Server.HtmlEncode(VideoHelper.GetSourceLabel(l.VideoUrl)) +
                            " · <a href=\"" + HttpUtility.HtmlAttributeEncode(href) + "\" target=\"_blank\" rel=\"noopener\">preview</a>";
                    }
                }
                else if (e.CommandName == "DeleteLesson")
                {
                    string video = bll.GetLessonById(lessonId).VideoUrl;
                    bll.DeleteLesson(lessonId);
                    VideoHelper.TryDeleteUploadedFile(video);
                    Response.Redirect(WithMsg("~/Admin/Courses.aspx?id=" + hfCourseId.Value, "lesson-deleted"));
                }
            }
            catch (ValidationException vex)
            {
                litLessonError.Text = Server.HtmlEncode(vex.Message);
                pnlLessonError.Visible = true;
            }
            catch (System.Threading.ThreadAbortException)
            {
                throw;   // Response.Redirect ends the request this way; not an error
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Lesson action '{0}' failed for lesson {1}: {2}", e.CommandName, lessonId, ex);
                litLessonError.Text = "Something went wrong. Please try again.";
                pnlLessonError.Visible = true;
            }
        }

        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            try
            {
                new CategoryBLL().AddCategory(new Category { Name = txtCategoryName.Text.Trim() });
                Response.Redirect(WithMsg(Request.RawUrl, "category-added"));
            }
            catch (ValidationException vex)
            {
                litCategoryError.Text = Server.HtmlEncode(vex.Message);
                pnlCategoryError.Visible = true;
            }
            catch (System.Threading.ThreadAbortException)
            {
                throw;   // Response.Redirect ends the request this way; not an error
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Add category failed: {0}", ex);
                litCategoryError.Text = "Something went wrong adding the category. Please try again.";
                pnlCategoryError.Visible = true;
            }
        }

        protected void rptCategories_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int categoryId = Convert.ToInt32(e.CommandArgument);

            try
            {
                if (e.CommandName == "DeleteCategory")
                {
                    new CategoryBLL().DeleteCategory(categoryId);
                    Response.Redirect(WithMsg(Request.RawUrl, "category-deleted"));
                }
                else if (e.CommandName == "RenameCategory")
                {
                    var txtRename = (TextBox)e.Item.FindControl("txtCategoryRename");
                    new CategoryBLL().UpdateCategory(new Category { CategoryID = categoryId, Name = txtRename.Text.Trim() });
                    Response.Redirect(WithMsg(Request.RawUrl, "category-renamed"));
                }
            }
            catch (ValidationException vex)
            {
                litCategoryError.Text = Server.HtmlEncode(vex.Message);
                pnlCategoryError.Visible = true;
            }
            catch (System.Threading.ThreadAbortException)
            {
                throw;   // Response.Redirect ends the request this way; not an error
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Category action '{0}' failed for category {1}: {2}", e.CommandName, categoryId, ex);
                litCategoryError.Text = "Something went wrong. Please try again.";
                pnlCategoryError.Visible = true;
            }
        }
    }
}
