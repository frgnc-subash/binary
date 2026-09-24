using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Core.DAL
{
    public class NotificationDAL
    {
        public void Insert(Notification n)
        {
            const string sql = @"
                INSERT INTO Notifications (UserID, Title, Message, Type, LinkUrl, IsRead, CreatedDate)
                VALUES (@UserID, @Title, @Message, @Type, @LinkUrl, 0, GETUTCDATE());";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", n.UserID);
                DbHelper.AddParam(cmd, "@Title", n.Title);
                DbHelper.AddParam(cmd, "@Message", n.Message);
                DbHelper.AddParam(cmd, "@Type", n.Type);
                DbHelper.AddParam(cmd, "@LinkUrl", n.LinkUrl);
                cmd.ExecuteNonQuery();
            }
        }

        // fans one notification out to every active admin in a single statement
        public void InsertForAdmins(string title, string message, string type, string linkUrl)
        {
            const string sql = @"
                INSERT INTO Notifications (UserID, Title, Message, Type, LinkUrl, IsRead, CreatedDate)
                SELECT u.UserID, @Title, @Message, @Type, @LinkUrl, 0, GETUTCDATE()
                FROM Users u
                INNER JOIN Roles r ON u.RoleID = r.RoleID
                WHERE r.RoleName = 'Admin' AND u.IsActive = 1;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Title", title);
                DbHelper.AddParam(cmd, "@Message", message);
                DbHelper.AddParam(cmd, "@Type", type);
                DbHelper.AddParam(cmd, "@LinkUrl", linkUrl);
                cmd.ExecuteNonQuery();
            }
        }

        public List<Notification> SelectRecentByUser(int userId, bool archived, int top)
        {
            const string sql = @"
                SELECT TOP (@Top) NotificationID, UserID, Title, Message, Type, LinkUrl, IsRead, IsArchived, CreatedDate
                FROM Notifications
                WHERE UserID = @UserID AND IsArchived = @IsArchived
                ORDER BY CreatedDate DESC, NotificationID DESC;";

            var list = new List<Notification>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Top", top);
                DbHelper.AddParam(cmd, "@UserID", userId);
                DbHelper.AddParam(cmd, "@IsArchived", archived);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new Notification
                        {
                            NotificationID = Convert.ToInt32(reader["NotificationID"]),
                            UserID = Convert.ToInt32(reader["UserID"]),
                            Title = reader["Title"].ToString(),
                            Message = reader["Message"].ToString(),
                            Type = reader["Type"].ToString(),
                            LinkUrl = reader["LinkUrl"] == DBNull.Value ? null : reader["LinkUrl"].ToString(),
                            IsRead = Convert.ToBoolean(reader["IsRead"]),
                            IsArchived = Convert.ToBoolean(reader["IsArchived"]),
                            CreatedDate = Convert.ToDateTime(reader["CreatedDate"])
                        });
                    }
                }
            }
            return list;
        }

        public int CountUnread(int userId)
        {
            const string sql = "SELECT COUNT(1) FROM Notifications WHERE UserID = @UserID AND IsRead = 0 AND IsArchived = 0;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                return (int)cmd.ExecuteScalar();
            }
        }

        public void MarkAllRead(int userId)
        {
            const string sql = "UPDATE Notifications SET IsRead = 1 WHERE UserID = @UserID AND IsRead = 0;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                cmd.ExecuteNonQuery();
            }
        }

        // all per-notification writes are scoped by UserID, so an ID from another account is a no-op

        public void MarkRead(int userId, int notificationId)
        {
            const string sql = "UPDATE Notifications SET IsRead = 1 WHERE NotificationID = @NotificationID AND UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@NotificationID", notificationId);
                DbHelper.AddParam(cmd, "@UserID", userId);
                cmd.ExecuteNonQuery();
            }
        }

        // archiving also marks it read, so archived items never count toward the unread badge
        public void SetArchived(int userId, int notificationId, bool archived)
        {
            const string sql = @"
                UPDATE Notifications
                SET IsArchived = @IsArchived, IsRead = CASE WHEN @IsArchived = 1 THEN 1 ELSE IsRead END
                WHERE NotificationID = @NotificationID AND UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@IsArchived", archived);
                DbHelper.AddParam(cmd, "@NotificationID", notificationId);
                DbHelper.AddParam(cmd, "@UserID", userId);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
