using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Core.DAL
{
    public class XpChange
    {
        public int OldXp { get; set; }
        public int NewXp { get; set; }
    }

    // data access layer for users table
    public class UserDAL
    {
        public User SelectByEmail(string email)
        {
            const string sql = @"
                SELECT u.UserID, u.FirstName, u.LastName, u.Email, u.PasswordHash, u.PasswordSalt,
                       u.RoleID, r.RoleName, u.IsActive, u.FailedLoginAttempts, u.LockoutEndUtc, u.CreatedDate, u.TotalXP, u.ProfileImageUrl, u.NativeLanguage, u.LearningReason
                FROM Users u
                INNER JOIN Roles r ON u.RoleID = r.RoleID
                WHERE u.Email = @Email;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Email", email);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return MapUser(reader);
                    }
                }
            }
            return null;
        }

        public User SelectById(int userId)
        {
            const string sql = @"
                SELECT u.UserID, u.FirstName, u.LastName, u.Email, u.PasswordHash, u.PasswordSalt,
                       u.RoleID, r.RoleName, u.IsActive, u.FailedLoginAttempts, u.LockoutEndUtc, u.CreatedDate, u.TotalXP, u.ProfileImageUrl, u.NativeLanguage, u.LearningReason
                FROM Users u
                INNER JOIN Roles r ON u.RoleID = r.RoleID
                WHERE u.UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return MapUser(reader);
                    }
                }
            }
            return null;
        }

        public bool EmailExists(string email)
        {
            const string sql = "SELECT COUNT(1) FROM Users WHERE Email = @Email;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Email", email);
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        public bool EmailExistsExcluding(string email, int excludingUserId)
        {
            const string sql = "SELECT COUNT(1) FROM Users WHERE Email = @Email AND UserID <> @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Email", email);
                DbHelper.AddParam(cmd, "@UserID", excludingUserId);
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        public int Insert(User user)
        {
            const string sql = @"
                INSERT INTO Users (FirstName, LastName, Email, PasswordHash, PasswordSalt, RoleID, IsActive, FailedLoginAttempts, LockoutEndUtc, CreatedDate)
                VALUES (@FirstName, @LastName, @Email, @PasswordHash, @PasswordSalt, @RoleID, @IsActive, 0, NULL, GETUTCDATE());
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@FirstName", user.FirstName);
                DbHelper.AddParam(cmd, "@LastName", user.LastName);
                DbHelper.AddParam(cmd, "@Email", user.Email);
                DbHelper.AddParam(cmd, "@PasswordHash", user.PasswordHash);
                DbHelper.AddParam(cmd, "@PasswordSalt", user.PasswordSalt);
                DbHelper.AddParam(cmd, "@RoleID", user.RoleID <= 0 ? 2 : user.RoleID);
                DbHelper.AddParam(cmd, "@IsActive", user.IsActive);

                return (int)cmd.ExecuteScalar();
            }
        }

        public void RecordFailedLogin(int userId, int failedAttempts, DateTime? lockoutEnd)
        {
            const string sql = @"
                UPDATE Users 
                SET FailedLoginAttempts = @Attempts, LockoutEndUtc = @LockoutEnd 
                WHERE UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Attempts", failedAttempts);
                DbHelper.AddParam(cmd, "@LockoutEnd", lockoutEnd);
                DbHelper.AddParam(cmd, "@UserID", userId);

                cmd.ExecuteNonQuery();
            }
        }

        public void ResetFailedLogin(int userId)
        {
            const string sql = @"
                UPDATE Users 
                SET FailedLoginAttempts = 0, LockoutEndUtc = NULL 
                WHERE UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                cmd.ExecuteNonQuery();
            }
        }

        public void UpdateProfile(User user)
        {
            const string sql = @"
                UPDATE Users 
                SET FirstName = @FirstName, LastName = @LastName
                WHERE UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@FirstName", user.FirstName);
                DbHelper.AddParam(cmd, "@LastName", user.LastName);
                DbHelper.AddParam(cmd, "@UserID", user.UserID);

                cmd.ExecuteNonQuery();
            }
        }

        public void UpdateOnboarding(int userId, string nativeLanguage, string learningReason)
        {
            const string sql = "UPDATE Users SET NativeLanguage = @NativeLanguage, LearningReason = @LearningReason WHERE UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@NativeLanguage", nativeLanguage);
                DbHelper.AddParam(cmd, "@LearningReason", learningReason);
                DbHelper.AddParam(cmd, "@UserID", userId);
                cmd.ExecuteNonQuery();
            }
        }

        public void UpdateProfileImage(int userId, string imageUrl)
        {
            const string sql = "UPDATE Users SET ProfileImageUrl = @ProfileImageUrl WHERE UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@ProfileImageUrl", imageUrl);
                DbHelper.AddParam(cmd, "@UserID", userId);
                cmd.ExecuteNonQuery();
            }
        }

        public void UpdateAdminDetails(User user)
        {
            const string sql = @"
                UPDATE Users
                SET FirstName = @FirstName, LastName = @LastName, Email = @Email, RoleID = @RoleID, IsActive = @IsActive
                WHERE UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@FirstName", user.FirstName);
                DbHelper.AddParam(cmd, "@LastName", user.LastName);
                DbHelper.AddParam(cmd, "@Email", user.Email);
                DbHelper.AddParam(cmd, "@RoleID", user.RoleID);
                DbHelper.AddParam(cmd, "@IsActive", user.IsActive);
                DbHelper.AddParam(cmd, "@UserID", user.UserID);

                cmd.ExecuteNonQuery();
            }
        }

        public void Delete(int userId)
        {
            const string sql = "DELETE FROM Users WHERE UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                cmd.ExecuteNonQuery();
            }
        }

        public void UpdatePassword(int userId, string newHash, string newSalt)
        {
            const string sql = @"
                UPDATE Users 
                SET PasswordHash = @PasswordHash, PasswordSalt = @PasswordSalt 
                WHERE UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@PasswordHash", newHash);
                DbHelper.AddParam(cmd, "@PasswordSalt", newSalt);
                DbHelper.AddParam(cmd, "@UserID", userId);

                cmd.ExecuteNonQuery();
            }
        }

        public List<User> SelectAll()
        {
            const string sql = @"
                SELECT u.UserID, u.FirstName, u.LastName, u.Email, u.PasswordHash, u.PasswordSalt,
                       u.RoleID, r.RoleName, u.IsActive, u.FailedLoginAttempts, u.LockoutEndUtc, u.CreatedDate, u.TotalXP, u.ProfileImageUrl, u.NativeLanguage, u.LearningReason
                FROM Users u
                INNER JOIN Roles r ON u.RoleID = r.RoleID
                ORDER BY u.CreatedDate DESC;";

            var list = new List<User>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    list.Add(MapUser(reader));
                }
            }
            return list;
        }

        private static User MapUser(SqlDataReader reader)
        {
            return new User
            {
                UserID = Convert.ToInt32(reader["UserID"]),
                FirstName = reader["FirstName"].ToString(),
                LastName = reader["LastName"].ToString(),
                Email = reader["Email"].ToString(),
                PasswordHash = reader["PasswordHash"].ToString(),
                PasswordSalt = reader["PasswordSalt"].ToString(),
                RoleID = Convert.ToInt32(reader["RoleID"]),
                RoleName = reader["RoleName"].ToString(),
                IsActive = Convert.ToBoolean(reader["IsActive"]),
                FailedLoginAttempts = Convert.ToInt32(reader["FailedLoginAttempts"]),
                LockoutEndUtc = reader["LockoutEndUtc"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["LockoutEndUtc"]),
                CreatedDate = Convert.ToDateTime(reader["CreatedDate"]),
                TotalXP = Convert.ToInt32(reader["TotalXP"]),
                ProfileImageUrl = reader["ProfileImageUrl"] == DBNull.Value ? null : reader["ProfileImageUrl"].ToString(),
                NativeLanguage = reader["NativeLanguage"] == DBNull.Value ? null : reader["NativeLanguage"].ToString(),
                LearningReason = reader["LearningReason"] == DBNull.Value ? null : reader["LearningReason"].ToString()
            };
        }

        // returns the totals before and after in one atomic statement (null if the user doesn't exist),
        // so concurrent awards can't both see the same "before" value and miss a title threshold
        public XpChange AddXP(int userId, int amount)
        {
            const string sql = @"
                UPDATE Users SET TotalXP = TotalXP + @Amount
                OUTPUT deleted.TotalXP AS OldXP, inserted.TotalXP AS NewXP
                WHERE UserID = @UserID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Amount", amount);
                DbHelper.AddParam(cmd, "@UserID", userId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) return null;
                    return new XpChange
                    {
                        OldXp = Convert.ToInt32(reader["OldXP"]),
                        NewXp = Convert.ToInt32(reader["NewXP"])
                    };
                }
            }
        }

        public List<User> SelectLeaderboard(int top)
        {
            const string sql = @"
                SELECT TOP (@Top) u.UserID, u.FirstName, u.LastName, u.Email, u.PasswordHash, u.PasswordSalt,
                       u.RoleID, r.RoleName, u.IsActive, u.FailedLoginAttempts, u.LockoutEndUtc, u.CreatedDate, u.TotalXP, u.ProfileImageUrl, u.NativeLanguage, u.LearningReason
                FROM Users u
                INNER JOIN Roles r ON u.RoleID = r.RoleID
                WHERE u.IsActive = 1
                ORDER BY u.TotalXP DESC, u.CreatedDate ASC;";

            var list = new List<User>();
            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Top", top);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(MapUser(reader));
                    }
                }
            }
            return list;
        }

        public int GetRank(int userId)
        {
            const string sql = @"
                SELECT COUNT(*) + 1
                FROM Users
                WHERE IsActive = 1 AND TotalXP > (SELECT TotalXP FROM Users WHERE UserID = @UserID);";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@UserID", userId);
                return (int)cmd.ExecuteScalar();
            }
        }

    }
}
