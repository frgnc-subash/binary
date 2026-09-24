using System.Collections.Generic;

namespace binary.Models
{
    /// <summary>
    /// Plain model for a question within a quiz.
    /// </summary>
    public class Question
    {
        public int QuestionID { get; set; }
        public int QuizID { get; set; }
        public string QuestionText { get; set; }
        public int SortOrder { get; set; }
        public List<QuestionOption> Options { get; set; }
    }
}
