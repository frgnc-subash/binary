using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Core.DAL
{
    // per-course enrollment count, joined with its category, for the admin Reports/Languages pages
    public class CourseEnrollmentStat
    {
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public int EnrollmentCount { get; set; }
    }

    // a single enrollment event, for the admin Reports activity feed
    public class RecentEnrollment
    {
        public string UserName { get; set; }
        public string CourseTitle { get; set; }
        public DateTime EnrolledDate { get; set; }
    }

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

        public Enrollment SelectByUserAndCourse(int userId, int courseId)
        {
            const string sql = @"
                SELECT e.EnrollmentID, e.UserID, e.CourseID, c.Title AS CourseTitle, c.Level AS CourseLevel,
                       e.ProgressPercent, e.EnrolledDate
                FROM Enrollments e
                INNER JOIN Courses c ON e.CourseID = c.CourseID
                WHERE e.UserID = @UserID AND e.CourseID = @CourseID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                DbHelper.AddParam(cmd, "@CourseID", courseId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new Enrollment
                        {
                            EnrollmentID = Convert.ToInt32(reader["EnrollmentID"]),
                            UserID = Convert.ToInt32(reader["UserID"]),
                            CourseID = Convert.ToInt32(reader["CourseID"]),
                            CourseTitle = reader["CourseTitle"].ToString(),
                            CourseLevel = reader["CourseLevel"].ToString(),
                            ProgressPercent = Convert.ToInt32(reader["ProgressPercent"]),
                            EnrolledDate = Convert.ToDateTime(reader["EnrolledDate"])
                        };
                    }
                }
            }
            return null;
        }

        public void UpdateProgress(int enrollmentId, int progressPercent)
        {
            const string sql = "UPDATE Enrollments SET ProgressPercent = @ProgressPercent WHERE EnrollmentID = @EnrollmentID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@ProgressPercent", progressPercent);
                DbHelper.AddParam(cmd, "@EnrollmentID", enrollmentId);
                cmd.ExecuteNonQuery();
            }
        }

        public List<CourseEnrollmentStat> GetEnrollmentCountsByCourse()
        {
            const string sql = @"
                SELECT c.CourseID, c.Title AS CourseTitle, c.CategoryID, cat.Name AS CategoryName,
                       COUNT(e.EnrollmentID) AS EnrollmentCount
                FROM Courses c
                INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID
                LEFT JOIN Enrollments e ON e.CourseID = c.CourseID
                GROUP BY c.CourseID, c.Title, c.CategoryID, cat.Name
                ORDER BY EnrollmentCount DESC;";

            var list = new List<CourseEnrollmentStat>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    list.Add(new CourseEnrollmentStat
                    {
                        CourseId = Convert.ToInt32(reader["CourseID"]),
                        CourseTitle = reader["CourseTitle"].ToString(),
                        CategoryId = Convert.ToInt32(reader["CategoryID"]),
                        CategoryName = reader["CategoryName"].ToString(),
                        EnrollmentCount = Convert.ToInt32(reader["EnrollmentCount"])
                    });
                }
            }
            return list;
        }

        public List<RecentEnrollment> GetRecentEnrollments(int top)
        {
            const string sql = @"
                SELECT TOP (@Top) u.FirstName, u.LastName, c.Title AS CourseTitle, e.EnrolledDate
                FROM Enrollments e
                INNER JOIN Users u ON e.UserID = u.UserID
                INNER JOIN Courses c ON e.CourseID = c.CourseID
                ORDER BY e.EnrolledDate DESC;";

            var list = new List<RecentEnrollment>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Top", top);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new RecentEnrollment
                        {
                            UserName = (reader["FirstName"] + " " + reader["LastName"]).Trim(),
                            CourseTitle = reader["CourseTitle"].ToString(),
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
