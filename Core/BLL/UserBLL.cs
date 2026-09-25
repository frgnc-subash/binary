using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using binary.Core.DAL;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Core.BLL
{
    // business logic for user accounts
    public class UserBLL
    {
        private readonly UserDAL _dal = new UserDAL();

        private static string ValidateAndCleanEmail(string firstName, string lastName, string email)
        {
            if (string.IsNullOrWhiteSpace(firstName))
                throw new ValidationException("First name is required.");
            if (string.IsNullOrWhiteSpace(lastName))
                throw new ValidationException("Last name is required.");
            if (string.IsNullOrWhiteSpace(email))
                throw new ValidationException("Email address is required.");

            string cleanEmail = email.Trim().ToLowerInvariant();

            if (!Regex.IsMatch(cleanEmail, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
                throw new ValidationException("Please enter a valid email address.");

            return cleanEmail;
        }

        private static void ValidatePassword(string password)
        {
            if (string.IsNullOrEmpty(password) || password.Length < 8)
                throw new ValidationException("Password must be at least 8 characters long.");
        }

        private static void ValidateRole(int roleId)
        {
            if (roleId != 1 && roleId != 2)
                throw new ValidationException("Please choose a valid role.");
        }

        public int Register(string firstName, string lastName, string email, string password)
        {
            string cleanEmail = ValidateAndCleanEmail(firstName, lastName, email);
            ValidatePassword(password);

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

            int newUserId = _dal.Insert(user);

            var notifications = new NotificationBLL();
            notifications.Notify(newUserId,
                "Welcome to Binary, " + user.FirstName + "!",
                "Pick a course to start earning XP. Your progress and streaks show up on your dashboard.",
                NotificationTypes.Success,
                "~/Courses");
            notifications.NotifyAdmins(
                "New learner joined",
                user.FullName + " (" + user.Email + ") just created an account.",
                "~/Admin/Users.aspx?id=" + newUserId);

            return newUserId;
        }

        public int AdminCreateUser(string firstName, string lastName, string email, string password, int roleId, bool isActive)
        {
            string cleanEmail = ValidateAndCleanEmail(firstName, lastName, email);
            ValidatePassword(password);
            ValidateRole(roleId);

            if (_dal.EmailExists(cleanEmail))
                throw new ValidationException("An account with this email address already exists.");

            string salt = PasswordHelper.GenerateSalt();
            string hash = PasswordHelper.Hash(password, salt);

            var user = new User
            {
                FirstName = firstName.Trim(),
                LastName = lastName.Trim(),
                Email = cleanEmail,
                PasswordHash = hash,
                PasswordSalt = salt,
                RoleID = roleId,
                IsActive = isActive
            };

            return _dal.Insert(user);
        }

        public void AdminUpdateUser(int userId, string firstName, string lastName, string email, int roleId, bool isActive)
        {
            if (userId <= 0)
                throw new ValidationException("Invalid user ID.");

            string cleanEmail = ValidateAndCleanEmail(firstName, lastName, email);
            ValidateRole(roleId);

            if (_dal.EmailExistsExcluding(cleanEmail, userId))
                throw new ValidationException("An account with this email address already exists.");

            var user = new User
            {
                UserID = userId,
                FirstName = firstName.Trim(),
                LastName = lastName.Trim(),
                Email = cleanEmail,
                RoleID = roleId,
                IsActive = isActive
            };

            _dal.UpdateAdminDetails(user);
        }

        public void DeleteUser(int userId)
        {
            if (userId <= 0)
                throw new ValidationException("Invalid user ID.");

            try
            {
                _dal.Delete(userId);
            }
            catch (SqlException sqlEx) when (sqlEx.Number == 547)
            {
                // 547 = foreign key constraint violation
                throw new ValidationException("Cannot delete a user with existing courses, enrollments, or activity. Deactivate the account instead.");
            }
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

        public void SaveOnboarding(int userId, string nativeLanguage, string learningReason)
        {
            if (userId <= 0)
                throw new ValidationException("Invalid user ID.");
            _dal.UpdateOnboarding(userId, Limit(nativeLanguage, 200), Limit(learningReason, 200));
        }

        private static string Limit(string value, int max)
        {
            if (string.IsNullOrWhiteSpace(value)) return null;
            value = value.Trim();
            return value.Length > max ? value.Substring(0, max) : value;
        }

        // Validates, stores, and assigns an uploaded profile picture, then removes the old file.
        // Shared by the learner and admin profile pages.
        public void SaveProfilePicture(int userId, System.Web.HttpPostedFile file)
        {
            string error;
            if (!AvatarHelper.IsValidImage(file, out error))
                throw new ValidationException(error);

            var server = System.Web.HttpContext.Current.Server;
            string oldImageUrl = GetProfile(userId).ProfileImageUrl;

            string folder = server.MapPath(AvatarHelper.AvatarFolderVirtualPath);
            System.IO.Directory.CreateDirectory(folder);
            string fileName = AvatarHelper.BuildFileName(userId, file.FileName);
            file.SaveAs(System.IO.Path.Combine(folder, fileName));

            UpdateProfilePicture(userId, AvatarHelper.AvatarFolderVirtualPath + fileName);

            if (string.IsNullOrWhiteSpace(oldImageUrl)) return;
            try
            {
                string oldPath = server.MapPath(oldImageUrl);
                if (System.IO.File.Exists(oldPath)) System.IO.File.Delete(oldPath);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Failed to delete old avatar for user {0}: {1}", userId, ex);
            }
        }

        public void UpdateProfilePicture(int userId, string imageUrl)
        {
            if (userId <= 0)
                throw new ValidationException("Invalid user ID.");
            if (string.IsNullOrWhiteSpace(imageUrl))
                throw new ValidationException("No image was uploaded.");

            _dal.UpdateProfileImage(userId, imageUrl);
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

            new NotificationBLL().Notify(userId,
                "Password changed",
                "Your password was just updated. If this wasn't you, change it again right away and contact support.",
                NotificationTypes.Warning,
                "~/Users/Profile.aspx?tab=security");
        }

        public List<User> GetAllUsers()
        {
            return _dal.SelectAll();
        }

        public List<User> GetLeaderboard(int top)
        {
            if (top <= 0)
                top = 50;

            return _dal.SelectLeaderboard(top);
        }

        public int GetRank(int userId)
        {
            if (userId <= 0)
                throw new ValidationException("Invalid user ID.");

            return _dal.GetRank(userId);
        }
    }
}
