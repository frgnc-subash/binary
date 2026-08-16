using System;

namespace binary.Models
{
    // model representing a user account
    public class User
    {
        public int UserID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public string PasswordSalt { get; set; }
        public int RoleID { get; set; }
        public string RoleName { get; set; }
        public bool IsActive { get; set; }
        public int FailedLoginAttempts { get; set; }
        public DateTime? LockoutEndUtc { get; set; }
        public DateTime CreatedDate { get; set; }

        public string FullName
        {
            get { return (FirstName + " " + LastName).Trim(); }
        }
    }
}
