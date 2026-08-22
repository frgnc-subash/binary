using System;
using System.Collections.Generic;
using binary.DAL;
using binary.Models;

namespace binary.BLL
{
    public class CourseBLL
    {
        private readonly CourseDAL _dal = new CourseDAL();

        public List<Course> GetAllCourses()
        {
            return _dal.SelectAll();
        }

        public List<Course> GetPublishedCourses()
        {
            return _dal.SelectPublished();
        }

        public Course GetCourseById(int courseId)
        {
            if (courseId <= 0)
                throw new ValidationException("Invalid course ID.");

            Course c = _dal.SelectById(courseId);
            if (c == null)
                throw new ValidationException("Course not found.");

            return c;
        }

        public int AddCourse(Course c, int createdByUserId)
        {
            Validate(c);
            c.CreatedBy = createdByUserId;
            return _dal.Insert(c);
        }

        public void UpdateCourse(Course c)
        {
            Validate(c);
            if (c.CourseID <= 0)
                throw new ValidationException("Invalid course ID.");

            _dal.Update(c);
        }

        public void DeleteCourse(int courseId)
        {
            if (courseId <= 0)
                throw new ValidationException("Invalid course ID.");

            _dal.Delete(courseId);
        }

        private void Validate(Course c)
        {
            if (c == null)
                throw new ValidationException("No course data supplied.");
            if (string.IsNullOrWhiteSpace(c.Title))
                throw new ValidationException("Course title is required.");
            if (c.Title.Trim().Length > 200)
                throw new ValidationException("Course title must be 200 characters or fewer.");
            if (c.CategoryID <= 0)
                throw new ValidationException("Please choose a valid category.");
        }
    }
}
