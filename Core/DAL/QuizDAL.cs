using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Core.DAL
{
    // summary stats for the admin Reports page
    public class QuizAttemptsSummary
    {
        public int Count { get; set; }
        public double AvgPercent { get; set; }
    }

    // a single quiz attempt event, for the admin Reports activity feed
    public class RecentAttempt
    {
        public string UserName { get; set; }
        public string QuizTitle { get; set; }
        public int Score { get; set; }
        public int MaxScore { get; set; }
        public DateTime AttemptDate { get; set; }
    }

    public class QuizDAL
    {
        public List<Quiz> SelectByCourseIds(List<int> courseIds)
        {
            var list = new List<Quiz>();
            if (courseIds == null || courseIds.Count == 0) return list;

            var paramNames = new List<string>();
            var sb = new StringBuilder();
            sb.Append(@"
                SELECT q.QuizID, q.CourseID, q.Title, c.Title AS CourseTitle, c.FlagImageUrl AS CourseFlagUrl,
                       (SELECT COUNT(*) FROM Questions x WHERE x.QuizID = q.QuizID) AS QuestionCount
                FROM Quizzes q
                INNER JOIN Courses c ON q.CourseID = c.CourseID
                WHERE q.CourseID IN (");
            for (int i = 0; i < courseIds.Count; i++)
            {
                string pName = "@CourseID" + i;
                paramNames.Add(pName);
                sb.Append(pName);
                if (i < courseIds.Count - 1) sb.Append(",");
            }
            sb.Append(");");

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sb.ToString()))
            {
                for (int i = 0; i < courseIds.Count; i++)
                    DbHelper.AddParam(cmd, paramNames[i], courseIds[i]);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new Quiz
                        {
                            QuizID = Convert.ToInt32(reader["QuizID"]),
                            CourseID = Convert.ToInt32(reader["CourseID"]),
                            Title = reader["Title"].ToString(),
                            CourseTitle = reader["CourseTitle"].ToString(),
                            CourseFlagUrl = reader["CourseFlagUrl"] == DBNull.Value ? null : reader["CourseFlagUrl"].ToString(),
                            QuestionCount = Convert.ToInt32(reader["QuestionCount"])
                        });
                    }
                }
            }
            return list;
        }

        public List<Question> SelectQuestionsWithOptions(int quizId)
        {
            const string sql = @"
                SELECT q.QuestionID, q.QuizID, q.QuestionText, q.SortOrder,
                       o.OptionID, o.OptionText, o.IsCorrect
                FROM Questions q
                LEFT JOIN QuestionOptions o ON o.QuestionID = q.QuestionID
                WHERE q.QuizID = @QuizID
                ORDER BY q.SortOrder, q.QuestionID, o.OptionID;";

            var questions = new List<Question>();
            var byId = new Dictionary<int, Question>();

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@QuizID", quizId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        int questionId = Convert.ToInt32(reader["QuestionID"]);
                        Question question;
                        if (!byId.TryGetValue(questionId, out question))
                        {
                            question = new Question
                            {
                                QuestionID = questionId,
                                QuizID = Convert.ToInt32(reader["QuizID"]),
                                QuestionText = reader["QuestionText"].ToString(),
                                SortOrder = Convert.ToInt32(reader["SortOrder"]),
                                Options = new List<QuestionOption>()
                            };
                            byId[questionId] = question;
                            questions.Add(question);
                        }

                        if (reader["OptionID"] != DBNull.Value)
                        {
                            question.Options.Add(new QuestionOption
                            {
                                OptionID = Convert.ToInt32(reader["OptionID"]),
                                QuestionID = questionId,
                                OptionText = reader["OptionText"].ToString(),
                                IsCorrect = Convert.ToBoolean(reader["IsCorrect"])
                            });
                        }
                    }
                }
            }
            return questions;
        }

        public int InsertAttempt(int userId, int quizId, int score, int maxScore)
        {
            const string sql = @"
                INSERT INTO QuizAttempts (UserID, QuizID, Score, MaxScore, AttemptDate)
                VALUES (@UserID, @QuizID, @Score, @MaxScore, GETUTCDATE());
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                DbHelper.AddParam(cmd, "@QuizID", quizId);
                DbHelper.AddParam(cmd, "@Score", score);
                DbHelper.AddParam(cmd, "@MaxScore", maxScore);
                return (int)cmd.ExecuteScalar();
            }
        }

        public List<QuizAttempt> SelectAttemptsByUser(int userId)
        {
            const string sql = @"
                SELECT a.AttemptID, a.UserID, a.QuizID, qz.Title AS QuizTitle, a.Score, a.MaxScore, a.AttemptDate
                FROM QuizAttempts a
                INNER JOIN Quizzes qz ON a.QuizID = qz.QuizID
                WHERE a.UserID = @UserID
                ORDER BY a.AttemptDate DESC;";

            var list = new List<QuizAttempt>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new QuizAttempt
                        {
                            AttemptID = Convert.ToInt32(reader["AttemptID"]),
                            UserID = Convert.ToInt32(reader["UserID"]),
                            QuizID = Convert.ToInt32(reader["QuizID"]),
                            QuizTitle = reader["QuizTitle"].ToString(),
                            Score = Convert.ToInt32(reader["Score"]),
                            MaxScore = Convert.ToInt32(reader["MaxScore"]),
                            AttemptDate = Convert.ToDateTime(reader["AttemptDate"])
                        });
                    }
                }
            }
            return list;
        }

        public QuizAttemptsSummary SelectAttemptsSummary()
        {
            const string sql = @"
                SELECT COUNT(*) AS AttemptCount,
                       ISNULL(AVG(CAST(Score AS FLOAT) * 100.0 / NULLIF(MaxScore, 0)), 0) AS AvgPercent
                FROM QuizAttempts;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    return new QuizAttemptsSummary
                    {
                        Count = Convert.ToInt32(reader["AttemptCount"]),
                        AvgPercent = Convert.ToDouble(reader["AvgPercent"])
                    };
                }
            }
            return new QuizAttemptsSummary { Count = 0, AvgPercent = 0 };
        }

        public List<RecentAttempt> SelectRecentAttempts(int top)
        {
            const string sql = @"
                SELECT TOP (@Top) u.FirstName, u.LastName, qz.Title AS QuizTitle,
                       a.Score, a.MaxScore, a.AttemptDate
                FROM QuizAttempts a
                INNER JOIN Users u ON a.UserID = u.UserID
                INNER JOIN Quizzes qz ON a.QuizID = qz.QuizID
                ORDER BY a.AttemptDate DESC;";

            var list = new List<RecentAttempt>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Top", top);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new RecentAttempt
                        {
                            UserName = (reader["FirstName"] + " " + reader["LastName"]).Trim(),
                            QuizTitle = reader["QuizTitle"].ToString(),
                            Score = Convert.ToInt32(reader["Score"]),
                            MaxScore = Convert.ToInt32(reader["MaxScore"]),
                            AttemptDate = Convert.ToDateTime(reader["AttemptDate"])
                        });
                    }
                }
            }
            return list;
        }
    }
}
