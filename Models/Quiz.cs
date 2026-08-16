namespace binary.Models
{
    /// <summary>
    /// Plain model for a quiz belonging to a course.
    /// </summary>
    public class Quiz
    {
        public int QuizID { get; set; }
        public int CourseID { get; set; }
        public string Title { get; set; }
        public string CourseTitle { get; set; }
    }
}
