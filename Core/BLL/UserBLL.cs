using System;
using System.Text.RegularExpressions;
using binary.DAL;
using binary.Helpers;
using binary.Models;

namespace binary.BLL
{
    // business logic for user accounts
    public class UserBLL
    {
        private readonly UserDAL _dal = new UserDAL();

        public int Register(string firstName, string lastName, string email, string password)
        {
            // validate user inputs
            if (string.IsNullOrWhiteSpace(firstName))
                throw new ValidationException("First name is required.");
            if (string.IsNullOrWhiteSpace(lastName))
                throw new ValidationException("Last name is required.");
            if (string.IsNullOrWhiteSpace(email))
                throw new ValidationException("Email address is required.");

            string cleanEmail = email.Trim().ToLowerInvariant();

            if (!Regex.IsMatch(cleanEmail, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
                throw new ValidationException("Please enter a valid email address.");

            if (string.IsNullOrEmpty(password) || password.Length < 8)
                throw new ValidationException("Password must be at least 8 characters long.");

            if (_dal.EmailExists(cleanEmail))
                throw new ValidationException("An account with this email address already exists.");

            // hash password with random salt
            string salt = PasswordHelper.GenerateSalt();
            string hash = PasswordHelper.Hash(password, salt);

            var user = new User
            {
                FirstName = firstName.Trim(),
                LastName = lastName.Trim(),
                Email = cleanEmail,
                PasswordHash = hash,
                PasswordSalt = salt,
                RoleID = 2,
                IsActive = true
            };

            return _dal.Insert(user);
        }

        public User GetProfile(int userId)
        {
            if (userId <= 0)
                throw new ValidationException("Invalid user ID.");

            User u = _dal.SelectById(userId);
            if (u == null)
                throw new ValidationException("User not found.");

            return u;
        }

        public void UpdateProfile(int userId, string firstName, string lastName)
        {
            if (userId <= 0)
                throw new ValidationException("Invalid user ID.");
            if (string.IsNullOrWhiteSpace(firstName))
                throw new ValidationException("First name cannot be empty.");
            if (string.IsNullOrWhiteSpace(lastName))
                throw new ValidationException("Last name cannot be empty.");

            var user = new User
            {
                UserID = userId,
                FirstName = firstName.Trim(),
                LastName = lastName.Trim()
            };

            _dal.UpdateProfile(user);
        }

        public void ChangePassword(int userId, string currentPassword, string newPassword)
        {
            if (userId <= 0)
                throw new ValidationException("Invalid user ID.");

            User u = _dal.SelectById(userId);
            if (u == null)
                throw new ValidationException("User not found.");

            if (!PasswordHelper.Verify(currentPassword, u.PasswordSalt, u.PasswordHash))
                throw new ValidationException("Current password is incorrect.");

            if (string.IsNullOrEmpty(newPassword) || newPassword.Length < 8)
                throw new ValidationException("New password must be at least 8 characters long.");

            string newSalt = PasswordHelper.GenerateSalt();
            string newHash = PasswordHelper.Hash(newPassword, newSalt);

            _dal.UpdatePassword(userId, newHash, newSalt);
        }
    }
}
