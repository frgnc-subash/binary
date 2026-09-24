using System;
using System.Collections.Generic;
using binary.Core.DAL;
using binary.Models;

namespace binary.Core.BLL
{
    public static class NotificationTypes
    {
        public const string Info = "info";
        public const string Success = "success";
        public const string Xp = "xp";
        public const string Warning = "warning";
        public const string Admin = "admin";
        public const string Award = "award";
    }

    public class NotificationBLL
    {
        private const int DrawerSize = 20;

        private readonly NotificationDAL _dal = new NotificationDAL();

        // Notifications are a side effect: a failure here must never roll back or fail
        // the action that triggered it (enrolling, submitting a quiz, registering...).
        public void Notify(int userId, string title, string message, string type = NotificationTypes.Info, string linkUrl = null)
        {
            if (userId <= 0) return;
            try
            {
                _dal.Insert(new Notification
                {
                    UserID = userId,
                    Title = Truncate(title, 150),
                    Message = Truncate(message, 500),
                    Type = type ?? NotificationTypes.Info,
                    LinkUrl = linkUrl
                });
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Notify user {0} failed: {1}", userId, ex);
            }
        }

        public void NotifyAdmins(string title, string message, string linkUrl = null)
        {
            try
            {
                _dal.InsertForAdmins(Truncate(title, 150), Truncate(message, 500), NotificationTypes.Admin, linkUrl);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Notify admins failed: {0}", ex);
            }
        }

        public List<Notification> GetInbox(int userId)
        {
            if (userId <= 0) return new List<Notification>();
            return _dal.SelectRecentByUser(userId, false, DrawerSize);
        }

        public List<Notification> GetArchived(int userId)
        {
            if (userId <= 0) return new List<Notification>();
            return _dal.SelectRecentByUser(userId, true, DrawerSize);
        }

        public void MarkRead(int userId, int notificationId)
        {
            if (userId <= 0 || notificationId <= 0) return;
            _dal.MarkRead(userId, notificationId);
        }

        public void Archive(int userId, int notificationId)
        {
            if (userId <= 0 || notificationId <= 0) return;
            _dal.SetArchived(userId, notificationId, true);
        }

        public void Unarchive(int userId, int notificationId)
        {
            if (userId <= 0 || notificationId <= 0) return;
            _dal.SetArchived(userId, notificationId, false);
        }

        public int GetUnreadCount(int userId)
        {
            if (userId <= 0) return 0;
            return _dal.CountUnread(userId);
        }

        public void MarkAllRead(int userId)
        {
            if (userId <= 0) return;
            _dal.MarkAllRead(userId);
        }

        private static string Truncate(string text, int max)
        {
            if (string.IsNullOrEmpty(text) || text.Length <= max) return text ?? "";
            return text.Substring(0, max - 1) + "…";
        }
    }
}
