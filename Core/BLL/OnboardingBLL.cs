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
    [Serializable]
    public class OnboardingChoice
    {
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public string CourseFlagUrl { get; set; }
        public string NativeLanguage { get; set; }   // label, e.g. "Nepali"
        public string Reason { get; set; }           // label, e.g. "Travel"; null if skipped
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

        // validates the form values (they come straight from the browser) and remembers them
        public static OnboardingChoice Save(string courseIdValue, string nativeKey, string reasonKey)
        {
            int courseId;
            if (!int.TryParse(courseIdValue, out courseId))
                throw new ValidationException("Please choose a language to learn.");

            Course course = new CourseBLL().GetPublishedCourses().FirstOrDefault(c => c.CourseID == courseId);
            if (course == null)
                throw new ValidationException("That course isn't available. Please choose another.");

            OnboardingOption native = NativeLanguages.FirstOrDefault(o => o.Key == nativeKey);
            if (native == null)
                throw new ValidationException("Please tell us which language you speak.");

            OnboardingOption reason = Reasons.FirstOrDefault(o => o.Key == reasonKey);   // optional

            var choice = new OnboardingChoice
            {
                CourseId = course.CourseID,
                CourseTitle = course.Title,
                CourseFlagUrl = course.FlagImageUrl,
                NativeLanguage = native.Label,
                Reason = reason == null ? null : reason.Label
            };
            HttpContext.Current.Session[SessionKey] = choice;
            return choice;
        }

        // Called right after registration. Saves the answers to the profile and enrolls the learner in
        // the course they picked. Returns that course's id, or 0 if there was nothing to apply.
        public static int ApplyToNewUser(int userId)
        {
            OnboardingChoice choice = Current;
            if (choice == null || userId <= 0) return 0;
            HttpContext.Current.Session.Remove(SessionKey);

            try
            {
                new UserBLL().SaveOnboarding(userId, choice.NativeLanguage, choice.Reason);
                new EnrollmentBLL().Enroll(userId, choice.CourseId);
                return choice.CourseId;
            }
            catch (Exception ex)
            {
                // the account already exists; a failed enrollment just means they pick a course themselves
                System.Diagnostics.Trace.TraceError("Applying onboarding for user {0} failed: {1}", userId, ex);
                return 0;
            }
        }
    }
}
