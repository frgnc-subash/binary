using System;

namespace binary.Models
{
    // model representing an in-app notification shown in the dashboard drawer
    public class Notification
    {
        public int NotificationID { get; set; }
        public int UserID { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public string Type { get; set; }
        public string LinkUrl { get; set; }
        public bool IsRead { get; set; }
        public bool IsArchived { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
