using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using binary.Core.BLL;
using binary.Models;

namespace binary.Admin
{
    // One lesson's quiz: create it, add / edit / delete multiple-choice questions, rename or delete it.
    // Opened from the lesson table on Admin/Courses.aspx (?lesson=ID). Admin-only access is enforced by AdminMaster.
    public partial class AdminLessonQuiz : Page
    {
        private static readonly Dictionary<string, string> ActionMessages = new Dictionary<string, string>
        {
            { "quiz-created", "Quiz created. Add your first question." },
            { "quiz-renamed", "Quiz title saved." },
            { "question-added", "Question added." },
            { "question-saved", "Question updated." },
            { "question-deleted", "Question deleted." },
        };

        private readonly QuizBLL _quizBll = new QuizBLL();
        private Lesson _lesson;
        private Quiz _quiz;
        private int _correctIndex = 0;

        // highlights the question currently loaded in the editor
        protected int EditingQuestionId { get; private set; }

        private string PageUrl
        {
            get { return "~/Admin/LessonQuiz.aspx?lesson=" + _lesson.LessonID; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int lessonId;
            int.TryParse(Request.QueryString["lesson"], out lessonId);
            try
            {
                _lesson = new LessonBLL().GetLessonById(lessonId);
            }
            catch (ValidationException)
            {
                Response.Redirect("~/Admin/Courses.aspx", true);
                return;
            }

            Course course = new CourseBLL().GetCourseById(_lesson.CourseID);
            litSubtitle.Text = Server.HtmlEncode(course.Title + " · Lesson " + _lesson.SortOrder + ": " + _lesson.Title);
            lnkBack.HRef = ResolveUrl("~/Admin/Courses.aspx?id=" + _lesson.CourseID);
            lnkCancelEdit.NavigateUrl = PageUrl;

            _quiz = _quizBll.GetLessonQuiz(_lesson.LessonID);

            if (!IsPostBack)
            {
                string msgText;
                if (ActionMessages.TryGetValue(Request.QueryString["msg"] ?? "", out msgText))
                {
                    litActionSuccess.Text = msgText;
                    pnlActionSuccess.Visible = true;
                }

                txtNewTitle.Text = _lesson.Title + " quiz";
                if (_quiz != null) txtQuizTitle.Text = _quiz.Title;
            }
            else
            {
                // after a failed save, keep the answer the admin had marked as correct
                int.TryParse(Request.Form["correctOption"], out _correctIndex);
                int editingId;
                int.TryParse(hfQuestionId.Value, out editingId);
                EditingQuestionId = editingId;
            }

            // bound on the first request only; postbacks keep the list from ViewState so the
            // Edit / Delete buttons raise their commands, and every successful action redirects
            if (!IsPostBack) BindQuiz();
        }

        private void BindQuiz()
        {
            pnlNoQuiz.Visible = _quiz == null;
            pnlQuiz.Visible = _quiz != null;
            if (_quiz == null) return;

            rptQuestions.DataSource = _quiz.Questions;
            rptQuestions.DataBind();
            pnlNoQuestions.Visible = _quiz.Questions.Count == 0;
            litQuestionCount.Text = _quiz.Questions.Count.ToString();

            bool editing = EditingQuestionId > 0;
            litEditorTitle.Text = editing ? "Edit question" : "Add a question";
            btnSaveQuestion.Text = editing ? "Save changes" : "Add question";
            lnkCancelEdit.Visible = editing;
        }

        protected string CorrectChecked(int index)
        {
            return index == _correctIndex ? "checked" : "";
        }

        private void ShowError(string message)
        {
            litError.Text = Server.HtmlEncode(message);
            pnlError.Visible = true;
        }

        private string WithMsg(string msg)
        {
            return PageUrl + "&msg=" + msg;
        }

        protected void btnCreateQuiz_Click(object sender, EventArgs e)
        {
            string redirect = null;
            try
            {
                _quizBll.CreateLessonQuiz(_lesson.LessonID, txtNewTitle.Text);
                redirect = WithMsg("quiz-created");
            }
            catch (ValidationException vex)
            {
                ShowError(vex.Message);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Create quiz for lesson {0} failed: {1}", _lesson.LessonID, ex);
                ShowError("Something went wrong creating the quiz. Please try again.");
            }
            if (redirect != null) Response.Redirect(redirect, true);
        }

        protected void btnRenameQuiz_Click(object sender, EventArgs e)
        {
            if (_quiz == null) return;
            string redirect = null;
            try
            {
                _quizBll.RenameQuiz(_quiz.QuizID, txtQuizTitle.Text);
                redirect = WithMsg("quiz-renamed");
            }
            catch (ValidationException vex)
            {
                ShowError(vex.Message);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Rename quiz {0} failed: {1}", _quiz.QuizID, ex);
                ShowError("Something went wrong saving the title. Please try again.");
            }
            if (redirect != null) Response.Redirect(redirect, true);
        }

        protected void btnDeleteQuiz_Click(object sender, EventArgs e)
        {
            if (_quiz == null) return;
            string redirect = null;
            try
            {
                _quizBll.DeleteQuiz(_quiz.QuizID);
                redirect = "~/Admin/Courses.aspx?id=" + _lesson.CourseID + "&msg=quiz-deleted";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Delete quiz {0} failed: {1}", _quiz.QuizID, ex);
                ShowError("Something went wrong deleting the quiz. Please try again.");
            }
            if (redirect != null) Response.Redirect(redirect, true);
        }

        protected void btnSaveQuestion_Click(object sender, EventArgs e)
        {
            if (_quiz == null) return;
            string redirect = null;
            try
            {
                var options = new List<string> { txtOptionA.Text, txtOptionB.Text, txtOptionC.Text, txtOptionD.Text };
                _quizBll.SaveQuestion(_quiz.QuizID, EditingQuestionId, txtQuestion.Text, options, _correctIndex);
                redirect = WithMsg(EditingQuestionId > 0 ? "question-saved" : "question-added");
            }
            catch (ValidationException vex)
            {
                ShowError(vex.Message);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Save question on quiz {0} failed: {1}", _quiz.QuizID, ex);
                ShowError("Something went wrong saving the question. Please try again.");
            }
            if (redirect != null) Response.Redirect(redirect, true);
        }

        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (_quiz == null) return;
            int questionId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditQuestion")
            {
                Question question = _quiz.Questions.FirstOrDefault(q => q.QuestionID == questionId);
                if (question == null) return;

                hfQuestionId.Value = question.QuestionID.ToString();
                EditingQuestionId = question.QuestionID;
                txtQuestion.Text = question.QuestionText;

                var boxes = new[] { txtOptionA, txtOptionB, txtOptionC, txtOptionD };
                for (int i = 0; i < boxes.Length; i++)
                    boxes[i].Text = i < question.Options.Count ? question.Options[i].OptionText : "";

                int correct = question.Options.FindIndex(o => o.IsCorrect);
                _correctIndex = correct < 0 ? 0 : correct;
                BindQuiz();
                return;
            }

            if (e.CommandName == "DeleteQuestion")
            {
                string redirect = null;
                try
                {
                    _quizBll.DeleteQuestion(_quiz.QuizID, questionId);
                    redirect = WithMsg("question-deleted");
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Delete question {0} failed: {1}", questionId, ex);
                    ShowError("Something went wrong deleting the question. Please try again.");
                }
                if (redirect != null) Response.Redirect(redirect, true);
            }
        }
    }
}
