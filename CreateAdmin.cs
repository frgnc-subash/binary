using System;
using System.Configuration;
using System.Data.SqlClient;
using binary.Helpers;

namespace binary
{
    // seeds initial admin account
    public class CreateAdmin
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("=== Binary LMS — Admin Account Creator ===");

            string firstName = "Admin";
            string lastName = "User";
            string email = "admin@binary.com";
            string password = "AdminPassword123!";

            Console.WriteLine("Creating admin account for: " + email);

            string salt = PasswordHelper.GenerateSalt();
            string hash = PasswordHelper.Hash(password, salt);

            string connectionString = ConfigurationManager.ConnectionStrings["LoginConnectionString"]?.ConnectionString
                ?? @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=Auth;Integrated Security=True;TrustServerCertificate=True;";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // ensure admin role exists
                const string checkRoleSql = "IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleName = 'Admin') INSERT INTO Roles (RoleName) VALUES ('Admin');";
                using (SqlCommand cmd = new SqlCommand(checkRoleSql, con))
                {
                    cmd.ExecuteNonQuery();
                }

                // check if admin already exists
                const string checkAdminSql = "SELECT COUNT(1) FROM Users WHERE Email = @Email;";
                using (SqlCommand cmd = new SqlCommand(checkAdminSql, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    int count = (int)cmd.ExecuteScalar();
                    if (count > 0)
                    {
                        Console.WriteLine("Admin account already exists!");
                        return;
                    }
                }

                // insert admin user
                const string insertAdminSql = @"
                    INSERT INTO Users (FirstName, LastName, Email, PasswordHash, PasswordSalt, RoleID, IsActive, FailedLoginAttempts, LockoutEndUtc, CreatedDate)
                    VALUES (@FirstName, @LastName, @Email, @PasswordHash, @PasswordSalt, 1, 1, 0, NULL, GETUTCDATE());";

                using (SqlCommand cmd = new SqlCommand(insertAdminSql, con))
                {
                    cmd.Parameters.AddWithValue("@FirstName", firstName);
                    cmd.Parameters.AddWithValue("@LastName", lastName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@PasswordHash", hash);
                    cmd.Parameters.AddWithValue("@PasswordSalt", salt);

                    cmd.ExecuteNonQuery();
                    Console.WriteLine("Admin account created successfully!");
                    Console.WriteLine("Email: " + email);
                    Console.WriteLine("Password: " + password);
                }
            }
        }
    }
}
