using System.Collections.Generic;
using binary.Core.DAL;
using binary.Models;

namespace binary.Core.BLL
{
    public class LessonBLL
    {
        private readonly LessonDAL _dal = new LessonDAL();
        private readonly CourseDAL _courseDal = new CourseDAL();

        public List<Lesson> GetLessonsByCourse(int courseId)
        {
            if (courseId <= 0)
                throw new ValidationException("Invalid course ID.");

            return _dal.SelectByCourse(courseId);
        }

        public Dictionary<int, int> GetLessonCountsByCourse()
        {
            return _dal.CountByCourse();
        }

        public Lesson GetLessonById(int lessonId)
        {
            if (lessonId <= 0)
                throw new ValidationException("Invalid lesson ID.");

            Lesson l = _dal.SelectById(lessonId);
            if (l == null)
                throw new ValidationException("Lesson not found.");

            return l;
        }

        public int AddLesson(Lesson l)
        {
            Validate(l);
            return _dal.Insert(l);
        }

        public void UpdateLesson(Lesson l)
        {
            Validate(l);
            if (l.LessonID <= 0)
                throw new ValidationException("Invalid lesson ID.");

            _dal.Update(l);
        }

        public void DeleteLesson(int lessonId)
        {
            if (lessonId <= 0)
                throw new ValidationException("Invalid lesson ID.");

            _dal.Delete(lessonId);
        }

        private void Validate(Lesson l)
        {
            if (l == null)
                throw new ValidationException("No lesson data supplied.");
            if (string.IsNullOrWhiteSpace(l.Title))
                throw new ValidationException("Lesson title is required.");
            if (l.Title.Trim().Length > 200)
                throw new ValidationException("Lesson title must be 200 characters or fewer.");
            if (l.CourseID <= 0 || _courseDal.SelectById(l.CourseID) == null)
                throw new ValidationException("The selected course does not exist.");
        }
    }
}
