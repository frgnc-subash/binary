using System;

namespace binary.Models
{
    /// <summary>
    /// Plain model for a language course.
    /// </summary>
    public class Course
    {
        public int CourseID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public int CategoryID { get; set; }
        public string CategoryName { get; set; }
        public string Level { get; set; }
        public string ThumbnailUrl { get; set; }
        public bool IsPublished { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
