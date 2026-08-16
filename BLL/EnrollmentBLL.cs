using System;
using System.Collections.Generic;
using binary.DAL;
using binary.Models;

namespace binary.BLL
{
    public class EnrollmentBLL
    {
        private readonly EnrollmentDAL _dal = new EnrollmentDAL();
        private readonly CourseDAL _courseDal = new CourseDAL();

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

            return _dal.Insert(userId, courseId);
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

        public void Unenroll(int userId, int courseId)
        {
            if (userId <= 0 || courseId <= 0)
                throw new ValidationException("Invalid request.");

            _dal.Delete(userId, courseId);
        }
    }
}
