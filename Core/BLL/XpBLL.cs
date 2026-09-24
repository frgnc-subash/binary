using System;
using System.Collections.Generic;
using System.Linq;
using binary.Core.DAL;

namespace binary.Core.BLL
{
    public class LearnerTitle
    {
        public int MinXp { get; set; }
        public string Name { get; set; }
        public string Emoji { get; set; }
        public string Description { get; set; }

        public string Display
        {
            get { return Emoji + " " + Name; }
        }
    }

    // Titles are derived from TotalXP rather than stored, so they can't drift out of sync with it.
    // Must stay ordered by MinXp ascending, starting at 0.
    public static class LearnerTitles
    {
        public static readonly IList<LearnerTitle> All = new List<LearnerTitle>
        {
            new LearnerTitle { MinXp = 0,    Emoji = "🌱", Name = "Beginner",         Description = "Every polyglot starts here." },
            new LearnerTitle { MinXp = 50,   Emoji = "🚀", Name = "Active Learner",   Description = "You're building a real study habit." },
            new LearnerTitle { MinXp = 200,  Emoji = "🔥", Name = "Avid Explorer",    Description = "Lessons and quizzes are part of your routine." },
            new LearnerTitle { MinXp = 500,  Emoji = "📚", Name = "Language Scholar", Description = "Serious progress across your tracks." },
            new LearnerTitle { MinXp = 1000, Emoji = "🌟", Name = "Master Polyglot",  Description = "The highest title on Binary." },
        }.AsReadOnly();

        public static LearnerTitle For(int xp)
        {
            return All.Last(t => t.MinXp <= Math.Max(0, xp));
        }

        // null once the top title is reached
        public static LearnerTitle Next(int xp)
        {
            return All.FirstOrDefault(t => t.MinXp > xp);
        }
    }

    public class XpBLL
    {
        private readonly UserDAL _userDal = new UserDAL();

        // The one way XP gets awarded, so crossing a title threshold is never missed.
        public void Award(int userId, int amount)
        {
            if (userId <= 0 || amount <= 0) return;

            XpChange change = _userDal.AddXP(userId, amount);
            if (change == null) return;

            LearnerTitle before = LearnerTitles.For(change.OldXp);
            LearnerTitle after = LearnerTitles.For(change.NewXp);
            if (after.MinXp <= before.MinXp) return;

            new NotificationBLL().Notify(userId,
                "New title unlocked: " + after.Display,
                "You reached " + after.MinXp + " XP. Your new title now shows on your profile and the leaderboard.",
                NotificationTypes.Award,
                "~/Users/Profile.aspx?tab=exp");
        }
    }
}
