using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using binary.Models;

namespace binary.Core.BLL
{
    public class OnboardingOption
    {
        public string Key { get; set; }
        public string Label { get; set; }
        public string FlagUrl { get; set; }    // a flag from Content/images/flags, if we have one
        public string IconName { get; set; }   // otherwise an icon from Core/Helpers/Icons
        public string Code { get; set; }       // short badge text when there's neither (e.g. "EN")
    }

    // What a visitor picked in the Get Started flow, kept in session until their account exists.
    // Every step allows more than one answer.
    [Serializable]
    public class OnboardingChoice
    {
        public List<int> CourseIds { get; set; }
        public int CourseId { get; set; }             // the first course picked; registration opens it
        public string CourseTitle { get; set; }       // all picked titles, e.g. "Spanish for Beginners, French Immersion"
        public string CourseFlagUrl { get; set; }     // flag of the first course
        public string NativeLanguage { get; set; }    // labels, e.g. "English, Nepali"
        public string Reason { get; set; }            // labels, e.g. "Travel, Career"; null if skipped
    }

    public static class OnboardingBLL
    {
        private const string SessionKey = "ONBOARDING_CHOICE";
        private const string Flags = "~/Content/images/flags/";

        public static readonly IList<OnboardingOption> NativeLanguages = new List<OnboardingOption>
        {
            new OnboardingOption { Key = "en", Label = "English", Code = "EN" },
            new OnboardingOption { Key = "ne", Label = "Nepali", FlagUrl = Flags + "nepal.png" },
            new OnboardingOption { Key = "hi", Label = "Hindi", Code = "HI" },
            new OnboardingOption { Key = "zh", Label = "Chinese", FlagUrl = Flags + "china.png" },
            new OnboardingOption { Key = "es", Label = "Spanish", FlagUrl = Flags + "spain.png" },
            new OnboardingOption { Key = "fr", Label = "French", FlagUrl = Flags + "france.png" },
            new OnboardingOption { Key = "ar", Label = "Arabic", FlagUrl = Flags + "arab-league.png" },
            new OnboardingOption { Key = "ja", Label = "Japanese", FlagUrl = Flags + "japan.png" },
            new OnboardingOption { Key = "ko", Label = "Korean", FlagUrl = Flags + "south-korea.png" },
            new OnboardingOption { Key = "other", Label = "Another language", IconName = "globe" },
        }.AsReadOnly();

        public static readonly IList<OnboardingOption> Reasons = new List<OnboardingOption>
        {
            new OnboardingOption { Key = "travel", Label = "Travel", IconName = "plane" },
            new OnboardingOption { Key = "career", Label = "Career", IconName = "briefcase" },
            new OnboardingOption { Key = "school", Label = "School or exams", IconName = "graduation" },
            new OnboardingOption { Key = "culture", Label = "Films, music & culture", IconName = "tv" },
            new OnboardingOption { Key = "family", Label = "Family & friends", IconName = "heart" },
            new OnboardingOption { Key = "fun", Label = "Just for fun", IconName = "smile" },
        }.AsReadOnly();

        public static OnboardingChoice Current
        {
            get
            {
                var session = HttpContext.Current == null ? null : HttpContext.Current.Session;
                return session == null ? null : session[SessionKey] as OnboardingChoice;
            }
        }

        // validates the form values (they come straight from the browser) and remembers them;
        // unknown ids and keys are ignored, and each list keeps the order the options are shown in
        public static OnboardingChoice Save(string[] courseIdValues, string[] nativeKeys, string[] reasonKeys)
        {
            var wanted = new HashSet<string>(courseIdValues ?? new string[0]);
            List<Course> courses = new CourseBLL().GetPublishedCourses()
                .Where(c => wanted.Contains(c.CourseID.ToString()))
                .ToList();
            if (courses.Count == 0)
                throw new ValidationException("Please choose at least one language to learn.");

            List<OnboardingOption> natives = Pick(NativeLanguages, nativeKeys);
            if (natives.Count == 0)
                throw new ValidationException("Please tell us which languages you speak.");

            List<OnboardingOption> reasons = Pick(Reasons, reasonKeys);   // optional

            var choice = new OnboardingChoice
            {
                CourseIds = courses.Select(c => c.CourseID).ToList(),
                CourseId = courses[0].CourseID,
                CourseTitle = string.Join(", ", courses.Select(c => c.Title)),
                CourseFlagUrl = courses[0].FlagImageUrl,
                NativeLanguage = string.Join(", ", natives.Select(o => o.Label)),
                Reason = reasons.Count == 0 ? null : string.Join(", ", reasons.Select(o => o.Label))
            };
            HttpContext.Current.Session[SessionKey] = choice;
            return choice;
        }

        private static List<OnboardingOption> Pick(IList<OnboardingOption> options, string[] keys)
        {
            var wanted = new HashSet<string>(keys ?? new string[0]);
            return options.Where(o => wanted.Contains(o.Key)).ToList();
        }

        // Called right after registration. Saves the answers to the profile and enrolls the learner in
        // every course they picked. Returns the first course's id, or 0 if there was nothing to apply.
        public static int ApplyToNewUser(int userId)
        {
            OnboardingChoice choice = Current;
            if (choice == null || userId <= 0) return 0;
            HttpContext.Current.Session.Remove(SessionKey);

            try
            {
                new UserBLL().SaveOnboarding(userId, choice.NativeLanguage, choice.Reason);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Saving onboarding answers for user {0} failed: {1}", userId, ex);
            }

            // the account already exists; a failed enrollment just means they pick that course themselves
            int firstEnrolled = 0;
            var enrollmentBll = new EnrollmentBLL();
            foreach (int courseId in choice.CourseIds ?? new List<int> { choice.CourseId })
            {
                try
                {
                    enrollmentBll.Enroll(userId, courseId);
                    if (firstEnrolled == 0) firstEnrolled = courseId;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Onboarding enrollment in course {0} for user {1} failed: {2}", courseId, userId, ex);
                }
            }
            return firstEnrolled;
        }
    }
}
