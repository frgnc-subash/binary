using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using binary.Helpers;
using binary.Models;

namespace binary.DAL
{
    public class FeedbackDAL
    {
        public int Insert(Feedback fb)
        {
            const string sql = @"
                INSERT INTO Feedback (UserID, Name, Email, Subject, Message, SubmittedDate)
                VALUES (@UserID, @Name, @Email, @Subject, @Message, GETUTCDATE());
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", fb.UserID);
                DbHelper.AddParam(cmd, "@Name", fb.Name);
                DbHelper.AddParam(cmd, "@Email", fb.Email);
                DbHelper.AddParam(cmd, "@Subject", fb.Subject);
                DbHelper.AddParam(cmd, "@Message", fb.Message);

                return (int)cmd.ExecuteScalar();
            }
        }

        public List<Feedback> SelectAll()
        {
            const string sql = @"
                SELECT FeedbackID, UserID, Name, Email, Subject, Message, SubmittedDate
                FROM Feedback
                ORDER BY SubmittedDate DESC;";

            var list = new List<Feedback>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    list.Add(new Feedback
                    {
                        FeedbackID = Convert.ToInt32(reader["FeedbackID"]),
                        UserID = reader["UserID"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["UserID"]),
                        Name = reader["Name"].ToString(),
                        Email = reader["Email"].ToString(),
                        Subject = reader["Subject"] == DBNull.Value ? null : reader["Subject"].ToString(),
                        Message = reader["Message"].ToString(),
                        SubmittedDate = Convert.ToDateTime(reader["SubmittedDate"])
                    });
                }
            }
            return list;
        }
    }
}
