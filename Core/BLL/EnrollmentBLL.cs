using System;
using System.Collections.Generic;
using binary.Core.DAL;
using binary.Models;

namespace binary.Core.BLL
{
    public class EnrollmentBLL
    {
        public const int LessonXpReward = 20;
        public const int CourseCompletionBonusXp = 100;

        private readonly EnrollmentDAL _dal = new EnrollmentDAL();
        private readonly CourseDAL _courseDal = new CourseDAL();
        private readonly LessonDAL _lessonDal = new LessonDAL();
        private readonly LessonProgressDAL _progressDal = new LessonProgressDAL();
        private readonly XpBLL _xp = new XpBLL();
        private readonly NotificationBLL _notifications = new NotificationBLL();

        public int Enroll(int userId, int courseId)
        {
            if (userId <= 0)
                throw new ValidationException("You must be logged in to enrol in a course.");

            Course course = _courseDal.SelectById(courseId);
            if (course == null)
                throw new ValidationException("The selected course does not exist.");

            if (!course.IsPublished)
                throw new ValidationException("This course is currently unpublished.");

            if (_dal.IsEnrolled(userId, courseId))
                throw new ValidationException("You are already enrolled in this course.");

            int enrollmentId = _dal.Insert(userId, courseId);

            _notifications.Notify(userId,
                "Enrolled in " + course.Title,
                "You're in! Complete lessons to earn +" + LessonXpReward + " XP each.",
                NotificationTypes.Success,
                "~/Courses/Detail.aspx?id=" + courseId);

            return enrollmentId;
        }

        public List<CourseEnrollmentStat> GetEnrollmentCountsByCourse()
        {
            return _dal.GetEnrollmentCountsByCourse();
        }

        public List<RecentEnrollment> GetRecentEnrollments(int top)
        {
            return _dal.GetRecentEnrollments(top <= 0 ? 10 : top);
        }

        public List<Enrollment> GetUserEnrollments(int userId)
        {
            if (userId <= 0)
                throw new ValidationException("Invalid user ID.");

            return _dal.SelectByUser(userId);
        }

        public bool IsUserEnrolled(int userId, int courseId)
        {
            if (userId <= 0 || courseId <= 0) return false;
            return _dal.IsEnrolled(userId, courseId);
        }

        public Enrollment GetEnrollment(int userId, int courseId)
        {
            if (userId <= 0 || courseId <= 0) return null;
            return _dal.SelectByUserAndCourse(userId, courseId);
        }

        public List<int> GetCompletedLessonIds(int enrollmentId)
        {
            if (enrollmentId <= 0) return new List<int>();
            return _progressDal.GetCompletedLessonIds(enrollmentId);
        }

        public int CountAllCompletedLessons()
        {
            return _progressDal.CountAllCompleted();
        }

        public Dictionary<DateTime, int> GetWeeklyActivity(int userId)
        {
            if (userId <= 0) return new Dictionary<DateTime, int>();
            return _progressDal.GetCompletionCountsByUser(userId, DateTime.UtcNow.Date.AddDays(-6));
        }

        // counts consecutive active days ending today (or yesterday, if today has no activity yet)
        public int GetCurrentStreak(int userId)
        {
            if (userId <= 0) return 0;

            HashSet<DateTime> activeDates = _progressDal.GetActivityDates(userId);
            if (activeDates.Count == 0) return 0;

            DateTime cursor = DateTime.UtcNow.Date;
            if (!activeDates.Contains(cursor))
                cursor = cursor.AddDays(-1);

            int streak = 0;
            while (activeDates.Contains(cursor))
            {
                streak++;
                cursor = cursor.AddDays(-1);
            }
            return streak;
        }

        public void Unenroll(int userId, int courseId)
        {
            if (userId <= 0 || courseId <= 0)
                throw new ValidationException("Invalid request.");

            _dal.Delete(userId, courseId);
        }

        public void MarkLessonComplete(int userId, int courseId, int lessonId)
        {
            if (userId <= 0)
                throw new ValidationException("You must be logged in to track progress.");

            Enrollment enrollment = _dal.SelectByUserAndCourse(userId, courseId);
            if (enrollment == null)
                throw new ValidationException("You are not enrolled in this course.");

            Lesson lesson = _lessonDal.SelectById(lessonId);
            if (lesson == null || lesson.CourseID != courseId)
                throw new ValidationException("Lesson not found in this course.");

            if (_progressDal.IsCompleted(enrollment.EnrollmentID, lessonId))
                return; // already completed; idempotent, no double XP

            _progressDal.MarkComplete(enrollment.EnrollmentID, lessonId);
            _xp.Award(userId, LessonXpReward);

            int totalLessons = _lessonDal.SelectByCourse(courseId).Count;
            int completedLessons = _progressDal.CountCompleted(enrollment.EnrollmentID);
            int newProgress = totalLessons > 0 ? (int)Math.Round(completedLessons * 100.0 / totalLessons) : 0;

            bool justCompletedCourse = newProgress >= 100 && enrollment.ProgressPercent < 100;
            _dal.UpdateProgress(enrollment.EnrollmentID, newProgress);

            if (justCompletedCourse)
            {
                _xp.Award(userId, CourseCompletionBonusXp);
                _notifications.Notify(userId,
                    "Course completed: " + enrollment.CourseTitle,
                    "Every lesson cleared. +" + CourseCompletionBonusXp + " XP completion bonus added.",
                    NotificationTypes.Xp,
                    "~/Courses/Detail.aspx?id=" + courseId);
            }
        }
    }
}
