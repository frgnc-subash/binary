using System;
using System.Web;
using binary.Core.DAL;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Core.BLL
{
    // centralized session-based authentication management
    public static class AuthBLL
    {
        private const string SessionUserIdKey = "AUTH_USER_ID";
        private const string SessionUserNameKey = "AUTH_USER_NAME";
        private const string SessionUserEmailKey = "AUTH_USER_EMAIL";
        private const string SessionUserRoleKey = "AUTH_USER_ROLE";

        private const int MaxFailedAttempts = 5;
        private static readonly TimeSpan LockoutDuration = TimeSpan.FromMinutes(15);

        private static readonly UserDAL _userDal = new UserDAL();

        // check if user is logged in
        public static bool IsLoggedIn
        {
            get
            {
                var session = HttpContext.Current?.Session;
                return session != null && session[SessionUserIdKey] != null && (int)session[SessionUserIdKey] > 0;
            }
        }

        // logged-in user id
        public static int CurrentUserId
        {
            get
            {
                var session = HttpContext.Current?.Session;
                if (session != null && session[SessionUserIdKey] != null)
                {
                    return (int)session[SessionUserIdKey];
                }
                return 0;
            }
        }

        // logged-in user display name
        public static string CurrentUserName
        {
            get
            {
                var session = HttpContext.Current?.Session;
                if (session != null && session[SessionUserNameKey] != null)
                {
                    return session[SessionUserNameKey].ToString();
                }
                return string.Empty;
            }
        }

        // logged-in user email
        public static string CurrentUserEmail
        {
            get
            {
                var session = HttpContext.Current?.Session;
                if (session != null && session[SessionUserEmailKey] != null)
                {
                    return session[SessionUserEmailKey].ToString();
                }
                return string.Empty;
            }
        }

        // check if logged-in user is admin
        public static bool IsAdmin
        {
            get
            {
                var session = HttpContext.Current?.Session;
                if (session != null && session[SessionUserRoleKey] != null)
                {
                    return string.Equals(session[SessionUserRoleKey].ToString(), "Admin", StringComparison.OrdinalIgnoreCase);
                }
                return false;
            }
        }

        // verifies credentials, checks lockout, and establishes session
        public static void Login(string email, string password)
        {
            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                throw new ValidationException("Please enter both email and password.");
            }

            string cleanEmail = email.Trim().ToLowerInvariant();
            User u = _userDal.SelectByEmail(cleanEmail);

            if (u == null || !u.IsActive)
            {
                // uniform error message to prevent enumeration
                throw new ValidationException("Invalid email or password.");
            }

            // check lockout status
            if (u.LockoutEndUtc.HasValue && u.LockoutEndUtc.Value > DateTime.UtcNow)
            {
                int minutesLeft = (int)Math.Ceiling((u.LockoutEndUtc.Value - DateTime.UtcNow).TotalMinutes);
                throw new ValidationException(string.Format("Too many failed attempts. Try again in {0} minute{1}.",
                    minutesLeft, minutesLeft == 1 ? "" : "s"));
            }

            // verify password hash
            if (!PasswordHelper.Verify(password, u.PasswordSalt, u.PasswordHash))
            {
                int newCount = u.FailedLoginAttempts + 1;
                DateTime? lockoutEnd = null;

                if (newCount >= MaxFailedAttempts)
                {
                    lockoutEnd = DateTime.UtcNow.Add(LockoutDuration);
                }

                _userDal.RecordFailedLogin(u.UserID, newCount, lockoutEnd);

                if (newCount >= MaxFailedAttempts)
                {
                    throw new ValidationException(string.Format("Too many failed attempts. Account is locked for {0} minutes.", (int)LockoutDuration.TotalMinutes));
                }

                throw new ValidationException("Invalid email or password.");
            }

            // reset failed login count on success
            if (u.FailedLoginAttempts > 0 || u.LockoutEndUtc.HasValue)
            {
                _userDal.ResetFailedLogin(u.UserID);
            }

            EstablishSession(u);
        }

        // sets session variables for user
        public static void EstablishSession(User user)
        {
            var session = HttpContext.Current?.Session;
            if (session != null)
            {
                session[SessionUserIdKey] = user.UserID;
                session[SessionUserNameKey] = user.FullName;
                session[SessionUserEmailKey] = user.Email;
                session[SessionUserRoleKey] = user.RoleName;
            }
        }

        // clears current session
        public static void Logout()
        {
            var session = HttpContext.Current?.Session;
            if (session != null)
            {
                session.Clear();
                session.Abandon();
            }
        }
    }
}
