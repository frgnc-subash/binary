using System;
using System.Collections.Generic;
using System.Linq;
using binary.Core.DAL;
using binary.Models;

namespace binary.Core.BLL
{
    // one line of the answer review shown after a quiz
    public class QuizAnswerReview
    {
        public int Number { get; set; }
        public string QuestionText { get; set; }
        public string YourAnswer { get; set; }
        public string CorrectAnswer { get; set; }
        public bool IsCorrect { get; set; }
    }

    // result of a scored quiz attempt
    public class QuizResult
    {
        public int Score { get; set; }
        public int MaxScore { get; set; }
        public int XpAwarded { get; set; }
        public List<QuizAnswerReview> Review { get; set; }

        public int Percent
        {
            get { return MaxScore > 0 ? (int)Math.Round(Score * 100.0 / MaxScore) : 0; }
        }
    }

    public class QuizBLL
    {
        public const int XpPerCorrectAnswer = 5;

        private readonly QuizDAL _dal = new QuizDAL();
        private readonly EnrollmentBLL _enrollmentBll = new EnrollmentBLL();

        public List<Quiz> GetQuizzesForEnrolledCourses(int userId)
        {
            if (userId <= 0) return new List<Quiz>();

            var courseIds = _enrollmentBll.GetUserEnrollments(userId).Select(e => e.CourseID).ToList();
            // a quiz with no questions yet can't be taken, so don't offer it
            return _dal.SelectByCourseIds(courseIds).Where(q => q.QuestionCount > 0).ToList();
        }

        public Quiz GetQuizWithQuestions(int userId, int quizId)
        {
            Quiz quiz = GetQuizzesForEnrolledCourses(userId).FirstOrDefault(q => q.QuizID == quizId);
            if (quiz == null)
                throw new ValidationException("Quiz not found, or you are not enrolled in its course.");

            quiz.Questions = _dal.SelectQuestionsWithOptions(quizId);
            return quiz;
        }

        public QuizResult SubmitAttempt(int userId, int quizId, Dictionary<int, int> selectedOptionIdByQuestionId)
        {
            if (userId <= 0)
                throw new ValidationException("You must be logged in to submit a quiz.");
            if (selectedOptionIdByQuestionId == null)
                selectedOptionIdByQuestionId = new Dictionary<int, int>();

            Quiz quiz = GetQuizWithQuestions(userId, quizId);
            int score = 0;
            var review = new List<QuizAnswerReview>();

            foreach (Question question in quiz.Questions)
            {
                var options = question.Options ?? new List<QuestionOption>();
                int selectedOptionId;
                QuestionOption selected = selectedOptionIdByQuestionId.TryGetValue(question.QuestionID, out selectedOptionId)
                    ? options.FirstOrDefault(o => o.OptionID == selectedOptionId)
                    : null;
                QuestionOption correct = options.FirstOrDefault(o => o.IsCorrect);

                bool isCorrect = selected != null && selected.IsCorrect;
                if (isCorrect) score++;

                review.Add(new QuizAnswerReview
                {
                    Number = review.Count + 1,
                    QuestionText = question.QuestionText,
                    YourAnswer = selected != null ? selected.OptionText : null,
                    CorrectAnswer = correct != null ? correct.OptionText : null,
                    IsCorrect = isCorrect
                });
            }

            int maxScore = quiz.Questions.Count;
            int xpAwarded = score * XpPerCorrectAnswer;

            _dal.InsertAttempt(userId, quizId, score, maxScore);
            new XpBLL().Award(userId, xpAwarded);

            new NotificationBLL().Notify(userId,
                "Quiz result: " + quiz.Title,
                "You scored " + score + "/" + maxScore + (xpAwarded > 0 ? " and earned +" + xpAwarded + " XP." : ". Try again to earn XP."),
                xpAwarded > 0 ? NotificationTypes.Xp : NotificationTypes.Info,
                "~/Users/Profile.aspx?tab=practice");

            return new QuizResult { Score = score, MaxScore = maxScore, XpAwarded = xpAwarded, Review = review };
        }

        /* ---------- admin: one quiz per lesson ---------- */

        public const int MaxOptions = 4;

        // the lesson's quiz with its questions, or null if the lesson has none yet
        public Quiz GetLessonQuiz(int lessonId)
        {
            Quiz quiz = _dal.SelectByLesson(lessonId);
            if (quiz != null) quiz.Questions = _dal.SelectQuestionsWithOptions(quiz.QuizID);
            return quiz;
        }

        // lessonId -> quiz for a course's lessons (question counts included, no questions)
        public Dictionary<int, Quiz> GetLessonQuizzes(int courseId)
        {
            return courseId <= 0 ? new Dictionary<int, Quiz>() : _dal.SelectLessonQuizzesByCourse(courseId);
        }

        public int CreateLessonQuiz(int lessonId, string title)
        {
            Lesson lesson = new LessonBLL().GetLessonById(lessonId);
            if (_dal.SelectByLesson(lessonId) != null)
                throw new ValidationException("This lesson already has a quiz.");
            return _dal.InsertQuiz(lesson.CourseID, lesson.LessonID, CleanTitle(title));
        }

        public void RenameQuiz(int quizId, string title)
        {
            if (quizId <= 0) throw new ValidationException("Invalid quiz.");
            _dal.UpdateTitle(quizId, CleanTitle(title));
        }

        public void DeleteQuiz(int quizId)
        {
            if (quizId <= 0) throw new ValidationException("Invalid quiz.");
            _dal.DeleteQuiz(quizId);
        }

        // Adds (questionId 0) or updates a multiple-choice question. Blank option boxes are ignored;
        // at least two options are needed and the one marked correct must have text.
        public void SaveQuestion(int quizId, int questionId, string questionText, IList<string> optionTexts, int correctIndex)
        {
            if (quizId <= 0) throw new ValidationException("Invalid quiz.");

            questionText = (questionText ?? "").Trim();
            if (questionText.Length == 0)
                throw new ValidationException("Please write the question.");
            if (questionText.Length > 500)
                throw new ValidationException("Questions must be 500 characters or fewer.");

            var options = new List<QuestionOption>();
            bool correctHasText = false;
            for (int i = 0; i < Math.Min(optionTexts == null ? 0 : optionTexts.Count, MaxOptions); i++)
            {
                string text = (optionTexts[i] ?? "").Trim();
                if (text.Length == 0) continue;
                if (text.Length > 200)
                    throw new ValidationException("Answer options must be 200 characters or fewer.");
                if (options.Any(o => string.Equals(o.OptionText, text, StringComparison.OrdinalIgnoreCase)))
                    throw new ValidationException("Two answer options are the same. Each option needs different text.");

                bool isCorrect = i == correctIndex;
                if (isCorrect) correctHasText = true;
                options.Add(new QuestionOption { OptionText = text, IsCorrect = isCorrect });
            }

            if (options.Count < 2)
                throw new ValidationException("Add at least two answer options.");
            if (!correctHasText)
                throw new ValidationException("Mark which answer is correct.");

            _dal.SaveQuestion(quizId, questionId, questionText, options);
        }

        public void DeleteQuestion(int quizId, int questionId)
        {
            if (quizId <= 0 || questionId <= 0) throw new ValidationException("Invalid question.");
            _dal.DeleteQuestion(quizId, questionId);
        }

        private static string CleanTitle(string title)
        {
            title = (title ?? "").Trim();
            if (title.Length == 0) throw new ValidationException("Please give the quiz a title.");
            if (title.Length > 200) throw new ValidationException("Quiz titles must be 200 characters or fewer.");
            return title;
        }

        public List<QuizAttempt> GetUserAttempts(int userId)
        {
            if (userId <= 0) return new List<QuizAttempt>();
            return _dal.SelectAttemptsByUser(userId);
        }

        public QuizAttemptsSummary GetAttemptsSummary()
        {
            return _dal.SelectAttemptsSummary();
        }

        public List<RecentAttempt> GetRecentAttempts(int top)
        {
            return _dal.SelectRecentAttempts(top <= 0 ? 10 : top);
        }
    }
}
