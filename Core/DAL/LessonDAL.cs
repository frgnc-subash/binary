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
    }
}
