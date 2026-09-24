using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using binary.Core.Helpers;

namespace binary.Core.DAL
{
    public class LessonProgressDAL
    {
        public bool IsCompleted(int enrollmentId, int lessonId)
        {
            const string sql = @"
                SELECT COUNT(1) FROM LessonProgress
                WHERE EnrollmentID = @EnrollmentID AND LessonID = @LessonID AND IsCompleted = 1;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@EnrollmentID", enrollmentId);
                DbHelper.AddParam(cmd, "@LessonID", lessonId);
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        public void MarkComplete(int enrollmentId, int lessonId)
        {
            const string sql = @"
                IF EXISTS (SELECT 1 FROM LessonProgress WHERE EnrollmentID = @EnrollmentID AND LessonID = @LessonID)
                    UPDATE LessonProgress
                    SET IsCompleted = 1, CompletedDate = GETUTCDATE()
                    WHERE EnrollmentID = @EnrollmentID AND LessonID = @LessonID;
                ELSE
                    INSERT INTO LessonProgress (EnrollmentID, LessonID, IsCompleted, CompletedDate)
                    VALUES (@EnrollmentID, @LessonID, 1, GETUTCDATE());";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@EnrollmentID", enrollmentId);
                DbHelper.AddParam(cmd, "@LessonID", lessonId);
                cmd.ExecuteNonQuery();
            }
        }

        public int CountCompleted(int enrollmentId)
        {
            const string sql = "SELECT COUNT(1) FROM LessonProgress WHERE EnrollmentID = @EnrollmentID AND IsCompleted = 1;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@EnrollmentID", enrollmentId);
                return (int)cmd.ExecuteScalar();
            }
        }

        public List<int> GetCompletedLessonIds(int enrollmentId)
        {
            const string sql = "SELECT LessonID FROM LessonProgress WHERE EnrollmentID = @EnrollmentID AND IsCompleted = 1;";

            var list = new List<int>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@EnrollmentID", enrollmentId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(Convert.ToInt32(reader["LessonID"]));
                    }
                }
            }
            return list;
        }

        public int CountAllCompleted()
        {
            const string sql = "SELECT COUNT(1) FROM LessonProgress WHERE IsCompleted = 1;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                return (int)cmd.ExecuteScalar();
            }
        }

        public Dictionary<DateTime, int> GetCompletionCountsByUser(int userId, DateTime fromDateUtc)
        {
            const string sql = @"
                SELECT CAST(lp.CompletedDate AS DATE) AS CompletedDay, COUNT(*) AS Cnt
                FROM LessonProgress lp
                INNER JOIN Enrollments e ON lp.EnrollmentID = e.EnrollmentID
                WHERE e.UserID = @UserID AND lp.IsCompleted = 1 AND lp.CompletedDate >= @FromDate
                GROUP BY CAST(lp.CompletedDate AS DATE);";

            var result = new Dictionary<DateTime, int>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                DbHelper.AddParam(cmd, "@FromDate", fromDateUtc);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result[Convert.ToDateTime(reader["CompletedDay"])] = Convert.ToInt32(reader["Cnt"]);
                    }
                }
            }
            return result;
        }

        // distinct calendar days the user was active: lesson completions or quiz attempts
        public HashSet<DateTime> GetActivityDates(int userId)
        {
            const string sql = @"
                SELECT DISTINCT CAST(ActivityDate AS DATE) AS ActivityDay
                FROM (
                    SELECT lp.CompletedDate AS ActivityDate
                    FROM LessonProgress lp
                    INNER JOIN Enrollments e ON lp.EnrollmentID = e.EnrollmentID
                    WHERE e.UserID = @UserID AND lp.IsCompleted = 1

                    UNION ALL

                    SELECT qa.AttemptDate AS ActivityDate
                    FROM QuizAttempts qa
                    WHERE qa.UserID = @UserID
                ) AS activity;";

            var result = new HashSet<DateTime>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(Convert.ToDateTime(reader["ActivityDay"]));
                    }
                }
            }
            return result;
        }
    }
}
