namespace binary.Models
{
    /// <summary>
    /// Plain model for a lesson within a course.
    /// </summary>
    public class Lesson
    {
        public int LessonID { get; set; }
        public int CourseID { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public string VideoUrl { get; set; }
        public int SortOrder { get; set; }
    }
}
