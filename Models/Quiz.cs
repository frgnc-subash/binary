using System.Collections.Generic;

namespace binary.Models
{
    /// <summary>
    /// Plain model for a quiz belonging to a course.
    /// </summary>
    public class Quiz
    {
        public int QuizID { get; set; }
        public int CourseID { get; set; }
        public int? LessonID { get; set; }       // set when the quiz belongs to one lesson
        public string LessonTitle { get; set; }
        public string Title { get; set; }
        public string CourseTitle { get; set; }
        public string CourseFlagUrl { get; set; }
        public int QuestionCount { get; set; }
        public List<Question> Questions { get; set; }
    }
}
