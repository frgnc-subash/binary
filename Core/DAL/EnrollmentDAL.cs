using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Core.DAL
{
    public class EnrollmentDAL
    {
        public bool IsEnrolled(int userId, int courseId)
        {
            const string sql = "SELECT COUNT(1) FROM Enrollments WHERE UserID = @UserID AND CourseID = @CourseID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                DbHelper.AddParam(cmd, "@CourseID", courseId);
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        public int Insert(int userId, int courseId)
        {
            const string sql = @"
                INSERT INTO Enrollments (UserID, CourseID, ProgressPercent, EnrolledDate)
                VALUES (@UserID, @CourseID, 0, GETUTCDATE());
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                DbHelper.AddParam(cmd, "@CourseID", courseId);
                return (int)cmd.ExecuteScalar();
            }
        }

        public List<Enrollment> SelectByUser(int userId)
        {
            const string sql = @"
                SELECT e.EnrollmentID, e.UserID, e.CourseID, c.Title AS CourseTitle, c.Level AS CourseLevel, 
                       e.ProgressPercent, e.EnrolledDate
                FROM Enrollments e
                INNER JOIN Courses c ON e.CourseID = c.CourseID
                WHERE e.UserID = @UserID
                ORDER BY e.EnrolledDate DESC;";

            var list = new List<Enrollment>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new Enrollment
                        {
                            EnrollmentID = Convert.ToInt32(reader["EnrollmentID"]),
                            UserID = Convert.ToInt32(reader["UserID"]),
                            CourseID = Convert.ToInt32(reader["CourseID"]),
                            CourseTitle = reader["CourseTitle"].ToString(),
                            CourseLevel = reader["CourseLevel"].ToString(),
                            ProgressPercent = Convert.ToInt32(reader["ProgressPercent"]),
                            EnrolledDate = Convert.ToDateTime(reader["EnrolledDate"])
                        });
                    }
                }
            }
            return list;
        }

        public void Delete(int userId, int courseId)
        {
            const string sql = "DELETE FROM Enrollments WHERE UserID = @UserID AND CourseID = @CourseID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                DbHelper.AddParam(cmd, "@CourseID", courseId);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
