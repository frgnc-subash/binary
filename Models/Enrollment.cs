using System;

namespace binary.Models
{
    /// <summary>
    /// Plain model for a user's enrolment in a course.
    /// </summary>
    public class Enrollment
    {
        public int EnrollmentID { get; set; }
        public int UserID { get; set; }
        public int CourseID { get; set; }
        public string CourseTitle { get; set; }
        public string CourseLevel { get; set; }
        public int ProgressPercent { get; set; }
        public DateTime EnrolledDate { get; set; }
    }
}
