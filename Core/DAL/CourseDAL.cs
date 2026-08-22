using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Core.DAL
{
    public class CourseDAL
    {
        public List<Course> SelectAll()
        {
            const string sql = @"
                SELECT c.CourseID, c.Title, c.Description, c.CategoryID, cat.Name AS CategoryName, 
                       c.Level, c.ThumbnailUrl, c.IsPublished, c.CreatedBy, c.CreatedDate
                FROM Courses c
                INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID
                ORDER BY c.CourseID ASC;";

            var list = new List<Course>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    list.Add(MapCourse(reader));
                }
            }
            return list;
        }

        public List<Course> SelectPublished()
        {
            const string sql = @"
                SELECT c.CourseID, c.Title, c.Description, c.CategoryID, cat.Name AS CategoryName, 
                       c.Level, c.ThumbnailUrl, c.IsPublished, c.CreatedBy, c.CreatedDate
                FROM Courses c
                INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID
                WHERE c.IsPublished = 1
                ORDER BY c.CourseID ASC;";

            var list = new List<Course>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    list.Add(MapCourse(reader));
                }
            }
            return list;
        }

        public Course SelectById(int courseId)
        {
            const string sql = @"
                SELECT c.CourseID, c.Title, c.Description, c.CategoryID, cat.Name AS CategoryName, 
                       c.Level, c.ThumbnailUrl, c.IsPublished, c.CreatedBy, c.CreatedDate
                FROM Courses c
                INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID
                WHERE c.CourseID = @CourseID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@CourseID", courseId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return MapCourse(reader);
                    }
                }
            }
            return null;
        }

        public int Insert(Course c)
        {
            const string sql = @"
                INSERT INTO Courses (Title, Description, CategoryID, Level, ThumbnailUrl, IsPublished, CreatedBy, CreatedDate)
                VALUES (@Title, @Description, @CategoryID, @Level, @ThumbnailUrl, @IsPublished, @CreatedBy, GETUTCDATE());
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Title", c.Title);
                DbHelper.AddParam(cmd, "@Description", c.Description);
                DbHelper.AddParam(cmd, "@CategoryID", c.CategoryID);
                DbHelper.AddParam(cmd, "@Level", c.Level ?? "Beginner");
                DbHelper.AddParam(cmd, "@ThumbnailUrl", c.ThumbnailUrl);
                DbHelper.AddParam(cmd, "@IsPublished", c.IsPublished);
                DbHelper.AddParam(cmd, "@CreatedBy", c.CreatedBy);

                return (int)cmd.ExecuteScalar();
            }
        }

        public void Update(Course c)
        {
            const string sql = @"
                UPDATE Courses 
                SET Title = @Title, Description = @Description, CategoryID = @CategoryID, 
                    Level = @Level, ThumbnailUrl = @ThumbnailUrl, IsPublished = @IsPublished
                WHERE CourseID = @CourseID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Title", c.Title);
                DbHelper.AddParam(cmd, "@Description", c.Description);
                DbHelper.AddParam(cmd, "@CategoryID", c.CategoryID);
                DbHelper.AddParam(cmd, "@Level", c.Level ?? "Beginner");
                DbHelper.AddParam(cmd, "@ThumbnailUrl", c.ThumbnailUrl);
                DbHelper.AddParam(cmd, "@IsPublished", c.IsPublished);
                DbHelper.AddParam(cmd, "@CourseID", c.CourseID);

                cmd.ExecuteNonQuery();
            }
        }

        public void Delete(int courseId)
        {
            const string sql = "DELETE FROM Courses WHERE CourseID = @CourseID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@CourseID", courseId);
                cmd.ExecuteNonQuery();
            }
        }

        private static Course MapCourse(SqlDataReader reader)
        {
            return new Course
            {
                CourseID = Convert.ToInt32(reader["CourseID"]),
                Title = reader["Title"].ToString(),
                Description = reader["Description"] == DBNull.Value ? null : reader["Description"].ToString(),
                CategoryID = Convert.ToInt32(reader["CategoryID"]),
                CategoryName = reader["CategoryName"].ToString(),
                Level = reader["Level"].ToString(),
                ThumbnailUrl = reader["ThumbnailUrl"] == DBNull.Value ? null : reader["ThumbnailUrl"].ToString(),
                IsPublished = Convert.ToBoolean(reader["IsPublished"]),
                CreatedBy = reader["CreatedBy"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["CreatedBy"]),
                CreatedDate = Convert.ToDateTime(reader["CreatedDate"])
            };
        }
    }
}
