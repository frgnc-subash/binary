using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Core.DAL
{
    public class LessonDAL
    {
        public List<Lesson> SelectByCourse(int courseId)
        {
            const string sql = @"
                SELECT LessonID, CourseID, Title, Content, VideoUrl, SortOrder 
                FROM Lessons 
                WHERE CourseID = @CourseID 
                ORDER BY SortOrder ASC;";

            var list = new List<Lesson>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@CourseID", courseId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new Lesson
                        {
                            LessonID = Convert.ToInt32(reader["LessonID"]),
                            CourseID = Convert.ToInt32(reader["CourseID"]),
                            Title = reader["Title"].ToString(),
                            Content = reader["Content"] == DBNull.Value ? null : reader["Content"].ToString(),
                            VideoUrl = reader["VideoUrl"] == DBNull.Value ? null : reader["VideoUrl"].ToString(),
                            SortOrder = Convert.ToInt32(reader["SortOrder"])
                        });
                    }
                }
            }
            return list;
        }

        public Dictionary<int, int> CountByCourse()
        {
            const string sql = "SELECT CourseID, COUNT(*) AS LessonCount FROM Lessons GROUP BY CourseID;";

            var counts = new Dictionary<int, int>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    counts[Convert.ToInt32(reader["CourseID"])] = Convert.ToInt32(reader["LessonCount"]);
                }
            }
            return counts;
        }

        public Lesson SelectById(int lessonId)
        {
            const string sql = @"
                SELECT LessonID, CourseID, Title, Content, VideoUrl, SortOrder 
                FROM Lessons 
                WHERE LessonID = @LessonID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@LessonID", lessonId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new Lesson
                        {
                            LessonID = Convert.ToInt32(reader["LessonID"]),
                            CourseID = Convert.ToInt32(reader["CourseID"]),
                            Title = reader["Title"].ToString(),
                            Content = reader["Content"] == DBNull.Value ? null : reader["Content"].ToString(),
                            VideoUrl = reader["VideoUrl"] == DBNull.Value ? null : reader["VideoUrl"].ToString(),
                            SortOrder = Convert.ToInt32(reader["SortOrder"])
                        };
                    }
                }
            }
            return null;
        }

        public int Insert(Lesson l)
        {
            const string sql = @"
                INSERT INTO Lessons (CourseID, Title, Content, VideoUrl, SortOrder)
                VALUES (@CourseID, @Title, @Content, @VideoUrl, @SortOrder);
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@CourseID", l.CourseID);
                DbHelper.AddParam(cmd, "@Title", l.Title);
                DbHelper.AddParam(cmd, "@Content", l.Content);
                DbHelper.AddParam(cmd, "@VideoUrl", l.VideoUrl);
                DbHelper.AddParam(cmd, "@SortOrder", l.SortOrder);
                return (int)cmd.ExecuteScalar();
            }
        }

        public void Update(Lesson l)
        {
            const string sql = @"
                UPDATE Lessons
                SET Title = @Title, Content = @Content, VideoUrl = @VideoUrl, SortOrder = @SortOrder
                WHERE LessonID = @LessonID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Title", l.Title);
                DbHelper.AddParam(cmd, "@Content", l.Content);
                DbHelper.AddParam(cmd, "@VideoUrl", l.VideoUrl);
                DbHelper.AddParam(cmd, "@SortOrder", l.SortOrder);
                DbHelper.AddParam(cmd, "@LessonID", l.LessonID);
                cmd.ExecuteNonQuery();
            }
        }

        public void Delete(int lessonId)
        {
            // the lesson's quiz goes with it (attempts first: they don't cascade); all or nothing
            const string sql = @"
                SET XACT_ABORT ON;
                BEGIN TRAN;
                DELETE a FROM QuizAttempts a INNER JOIN Quizzes q ON a.QuizID = q.QuizID WHERE q.LessonID = @LessonID;
                DELETE FROM Quizzes WHERE LessonID = @LessonID;
                DELETE FROM Lessons WHERE LessonID = @LessonID;
                COMMIT;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@LessonID", lessonId);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
