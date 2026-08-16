using System;

namespace binary.Models
{
    /// <summary>
    /// Plain model for a quiz attempt record.
    /// </summary>
    public class QuizAttempt
    {
        public int AttemptID { get; set; }
        public int UserID { get; set; }
        public int QuizID { get; set; }
        public string QuizTitle { get; set; }
        public int Score { get; set; }
        public int MaxScore { get; set; }
        public DateTime AttemptDate { get; set; }
    }
}
