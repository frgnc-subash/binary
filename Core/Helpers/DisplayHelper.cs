using System;
using System.Collections.Generic;
using System.Linq;

namespace binary.Core.Helpers
{
    // a single day's value in a 7-day activity bar chart
    public class ChartBar
    {
        public string Label { get; set; }
        public int Count { get; set; }
        public int HeightPercent { get; set; }
        public bool IsToday { get; set; }
    }

    // shared display-formatting helpers for name initials, decorative monograms, and bar charts
    public static class DisplayHelper
    {
        public static string GetInitials(string firstName, string lastName)
        {
            string f = string.IsNullOrEmpty(firstName) ? "" : firstName.Substring(0, 1);
            string l = string.IsNullOrEmpty(lastName) ? "" : lastName.Substring(0, 1);
            string initials = (f + l).ToUpperInvariant();
            return string.IsNullOrEmpty(initials) ? "U" : initials;
        }

        // decorative two-letter monogram derived from a course title; not a language code
        public static string GetTitleMonogram(string title)
        {
            if (string.IsNullOrWhiteSpace(title)) return "??";
            return title.Substring(0, Math.Min(2, title.Length)).ToUpperInvariant();
        }

        // builds a trailing N-day series (oldest first) for the shared .bar-chart-container markup,
        // scaling each day's bar height relative to the busiest day in the window
        public static List<ChartBar> BuildDailyChart(Func<DateTime, int> countForDay, int days = 7)
        {
            var result = new List<ChartBar>();
            DateTime today = DateTime.UtcNow.Date;
            for (int i = days - 1; i >= 0; i--)
            {
                DateTime day = today.AddDays(-i);
                result.Add(new ChartBar { Label = day.ToString("ddd"), Count = countForDay(day), IsToday = i == 0 });
            }

            int max = result.Count > 0 ? result.Max(d => d.Count) : 0;
            if (max < 1) max = 1;
            foreach (var d in result)
                d.HeightPercent = d.Count == 0 ? 6 : Math.Max(12, (int)Math.Round(d.Count * 100.0 / max));

            return result;
        }

        public static string GetChartBarClass(object isToday)
        {
            return (bool)isToday ? "bar-pill active" : "bar-pill";
        }

        public static string GetChartLabelStyle(object isToday)
        {
            return (bool)isToday ? "font-weight:800;color:#4f46e5;" : "";
        }

        public static string GetChartTooltip(object isToday, object count)
        {
            int c = Convert.ToInt32(count);
            if ((bool)isToday && c > 0)
                return "<div class=\"bar-badge-tooltip\">" + c + " today</div>";
            return "";
        }
    }
}
