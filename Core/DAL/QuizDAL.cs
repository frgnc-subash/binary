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
        // every quiz query selects these columns, so ReadQuiz can map any of them
        private const string QuizSelect = @"
                SELECT q.QuizID, q.CourseID, q.LessonID, q.Title, c.Title AS CourseTitle, c.FlagImageUrl AS CourseFlagUrl,
                       l.Title AS LessonTitle,
                       (SELECT COUNT(*) FROM Questions x WHERE x.QuizID = q.QuizID) AS QuestionCount
                FROM Quizzes q
                INNER JOIN Courses c ON q.CourseID = c.CourseID
                LEFT JOIN Lessons l ON q.LessonID = l.LessonID";

        private static Quiz ReadQuiz(SqlDataReader reader)
        {
            return new Quiz
            {
                QuizID = Convert.ToInt32(reader["QuizID"]),
                CourseID = Convert.ToInt32(reader["CourseID"]),
                LessonID = reader["LessonID"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["LessonID"]),
                Title = reader["Title"].ToString(),
                CourseTitle = reader["CourseTitle"].ToString(),
                CourseFlagUrl = reader["CourseFlagUrl"] == DBNull.Value ? null : reader["CourseFlagUrl"].ToString(),
                LessonTitle = reader["LessonTitle"] == DBNull.Value ? null : reader["LessonTitle"].ToString(),
                QuestionCount = Convert.ToInt32(reader["QuestionCount"])
            };
        }

        public List<Quiz> SelectByCourseIds(List<int> courseIds)
        {
            var list = new List<Quiz>();
            if (courseIds == null || courseIds.Count == 0) return list;

            var paramNames = new List<string>();
            var sb = new StringBuilder();
            sb.Append(QuizSelect).Append(" WHERE q.CourseID IN (");
            for (int i = 0; i < courseIds.Count; i++)
            {
                string pName = "@CourseID" + i;
                paramNames.Add(pName);
                sb.Append(pName);
                if (i < courseIds.Count - 1) sb.Append(",");
            }
            sb.Append(") ORDER BY c.Title, CASE WHEN q.LessonID IS NULL THEN 0 ELSE 1 END, l.SortOrder;");

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sb.ToString()))
            {
                for (int i = 0; i < courseIds.Count; i++)
                    DbHelper.AddParam(cmd, paramNames[i], courseIds[i]);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read()) list.Add(ReadQuiz(reader));
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

        /* ---------- admin: lesson quizzes ---------- */

        public Quiz SelectByLesson(int lessonId)
        {
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, QuizSelect + " WHERE q.LessonID = @LessonID;"))
            {
                DbHelper.AddParam(cmd, "@LessonID", lessonId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                    return reader.Read() ? ReadQuiz(reader) : null;
            }
        }

        // lessonId -> its quiz, for every lesson in the course that has one
        public Dictionary<int, Quiz> SelectLessonQuizzesByCourse(int courseId)
        {
            var map = new Dictionary<int, Quiz>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, QuizSelect + " WHERE q.CourseID = @CourseID AND q.LessonID IS NOT NULL;"))
            {
                DbHelper.AddParam(cmd, "@CourseID", courseId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Quiz quiz = ReadQuiz(reader);
                        map[quiz.LessonID.Value] = quiz;
                    }
                }
            }
            return map;
        }

        public int InsertQuiz(int courseId, int lessonId, string title)
        {
            const string sql = @"
                INSERT INTO Quizzes (CourseID, LessonID, Title) VALUES (@CourseID, @LessonID, @Title);
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@CourseID", courseId);
                DbHelper.AddParam(cmd, "@LessonID", lessonId);
                DbHelper.AddParam(cmd, "@Title", title);
                return (int)cmd.ExecuteScalar();
            }
        }

        public void UpdateTitle(int quizId, string title)
        {
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, "UPDATE Quizzes SET Title = @Title WHERE QuizID = @QuizID;"))
            {
                DbHelper.AddParam(cmd, "@Title", title);
                DbHelper.AddParam(cmd, "@QuizID", quizId);
                cmd.ExecuteNonQuery();
            }
        }

        // attempts don't cascade, so they go first; questions and options cascade from the quiz
        public void DeleteQuiz(int quizId)
        {
            const string sql = @"
                SET XACT_ABORT ON;
                BEGIN TRAN;
                DELETE FROM QuizAttempts WHERE QuizID = @QuizID;
                DELETE FROM Quizzes WHERE QuizID = @QuizID;
                COMMIT;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@QuizID", quizId);
                cmd.ExecuteNonQuery();
            }
        }

        // Adds a question (questionId = 0) or replaces an existing one's text and options, in one transaction.
        public int SaveQuestion(int quizId, int questionId, string questionText, IList<QuestionOption> options)
        {
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlTransaction tx = con.BeginTransaction())
            {
                SqlCommand cmd;
                if (questionId <= 0)
                {
                    cmd = new SqlCommand(@"
                        INSERT INTO Questions (QuizID, QuestionText, SortOrder)
                        SELECT @QuizID, @Text, ISNULL(MAX(SortOrder), 0) + 1 FROM Questions WHERE QuizID = @QuizID;
                        SELECT CAST(SCOPE_IDENTITY() AS INT);", con, tx);
                    DbHelper.AddParam(cmd, "@QuizID", quizId);
                    DbHelper.AddParam(cmd, "@Text", questionText);
                    questionId = (int)cmd.ExecuteScalar();
                }
                else
                {
                    cmd = new SqlCommand(@"
                        UPDATE Questions SET QuestionText = @Text WHERE QuestionID = @QuestionID AND QuizID = @QuizID;
                        DELETE FROM QuestionOptions WHERE QuestionID = @QuestionID;", con, tx);
                    DbHelper.AddParam(cmd, "@Text", questionText);
                    DbHelper.AddParam(cmd, "@QuestionID", questionId);
                    DbHelper.AddParam(cmd, "@QuizID", quizId);
                    cmd.ExecuteNonQuery();
                }

                foreach (QuestionOption option in options)
                {
                    var insert = new SqlCommand(
                        "INSERT INTO QuestionOptions (QuestionID, OptionText, IsCorrect) VALUES (@QuestionID, @Text, @IsCorrect);", con, tx);
                    DbHelper.AddParam(insert, "@QuestionID", questionId);
                    DbHelper.AddParam(insert, "@Text", option.OptionText);
                    DbHelper.AddParam(insert, "@IsCorrect", option.IsCorrect);
                    insert.ExecuteNonQuery();
                }

                tx.Commit();
                return questionId;
            }
        }

        public void DeleteQuestion(int quizId, int questionId)
        {
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, "DELETE FROM Questions WHERE QuestionID = @QuestionID AND QuizID = @QuizID;"))
            {
                DbHelper.AddParam(cmd, "@QuestionID", questionId);
                DbHelper.AddParam(cmd, "@QuizID", quizId);
                cmd.ExecuteNonQuery();
            }
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
