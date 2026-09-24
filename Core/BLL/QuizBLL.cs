using System;
using System.Collections.Generic;
using System.Linq;
using binary.Core.DAL;
using binary.Models;

namespace binary.Core.BLL
{
    // result of a scored quiz attempt
    public class QuizResult
    {
        public int Score { get; set; }
        public int MaxScore { get; set; }
        public int XpAwarded { get; set; }

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
            return _dal.SelectByCourseIds(courseIds);
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

            foreach (Question question in quiz.Questions)
            {
                int selectedOptionId;
                if (!selectedOptionIdByQuestionId.TryGetValue(question.QuestionID, out selectedOptionId))
                    continue;

                bool isCorrect = question.Options != null &&
                    question.Options.Any(o => o.OptionID == selectedOptionId && o.IsCorrect);

                if (isCorrect) score++;
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

            return new QuizResult { Score = score, MaxScore = maxScore, XpAwarded = xpAwarded };
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
