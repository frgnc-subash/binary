using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using binary.Core.DAL;
using binary.Models;

namespace binary.Core.BLL
{
    public class FeedbackBLL
    {
        private readonly FeedbackDAL _dal = new FeedbackDAL();

        public int SubmitFeedback(string name, string email, string subject, string message, int? userId = null)
        {
            if (string.IsNullOrWhiteSpace(name))
                throw new ValidationException("Name is required.");
            if (string.IsNullOrWhiteSpace(email))
                throw new ValidationException("Email is required.");
            if (!Regex.IsMatch(email.Trim(), @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
                throw new ValidationException("Please enter a valid email address.");
            if (string.IsNullOrWhiteSpace(message))
                throw new ValidationException("Message cannot be empty.");

            var fb = new Feedback
            {
                UserID = userId,
                Name = name.Trim(),
                Email = email.Trim().ToLowerInvariant(),
                Subject = string.IsNullOrWhiteSpace(subject) ? "General Inquiry" : subject.Trim(),
                Message = message.Trim()
            };

            int feedbackId = _dal.Insert(fb);

            new NotificationBLL().NotifyAdmins(
                "New message: " + fb.Subject,
                "From " + fb.Name + ": " + fb.Message,
                "~/Admin/Feedback.aspx");

            return feedbackId;
        }

        public List<Feedback> GetAllFeedback()
        {
            return _dal.SelectAll();
        }

        public void DeleteFeedback(int feedbackId)
        {
            if (feedbackId <= 0)
                throw new ValidationException("Invalid feedback ID.");

            _dal.Delete(feedbackId);
        }
    }
}
