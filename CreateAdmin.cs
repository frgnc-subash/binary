using System;
using System.Configuration;
using System.Data.SqlClient;
using binary.Core.Helpers;

namespace binary
{
    // seeds initial admin account
    public class CreateAdmin
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("=== Binary LMS — Admin Account Creator ===");

            // credentials come from the command line or a prompt, never from source code
            //   usage: CreateAdmin <email> [password]
            string firstName = "Admin";
            string lastName = "User";
            string email = args.Length > 0 ? args[0] : Prompt("Admin email: ");
            string password = args.Length > 1 ? args[1] : ReadPassword("Admin password (min 8 characters): ");

            email = (email ?? "").Trim().ToLowerInvariant();
            if (email.Length == 0 || !email.Contains("@"))
            {
                Console.WriteLine("A valid email is required.");
                return;
            }
            if (string.IsNullOrEmpty(password) || password.Length < 8)
            {
                Console.WriteLine("Password must be at least 8 characters long.");
                return;
            }

            Console.WriteLine("Creating admin account for: " + email);

            string salt = PasswordHelper.GenerateSalt();
            string hash = PasswordHelper.Hash(password, salt);

            string connectionString = ConfigurationManager.ConnectionStrings["BinaryConnectionString"]?.ConnectionString
                ?? @"Data Source=.\SQLEXPRESS01;Initial Catalog=BinaryDB;Integrated Security=True;TrustServerCertificate=True;";

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
                }
            }
        }

        private static string Prompt(string label)
        {
            Console.Write(label);
            return Console.ReadLine();
        }

        // reads a line without echoing it to the console
        private static string ReadPassword(string label)
        {
            Console.Write(label);
            var sb = new System.Text.StringBuilder();
            while (true)
            {
                ConsoleKeyInfo key = Console.ReadKey(true);
                if (key.Key == ConsoleKey.Enter) break;
                if (key.Key == ConsoleKey.Backspace)
                {
                    if (sb.Length > 0) sb.Length--;
                }
                else if (!char.IsControl(key.KeyChar))
                {
                    sb.Append(key.KeyChar);
                }
            }
            Console.WriteLine();
            return sb.ToString();
        }
    }
}
