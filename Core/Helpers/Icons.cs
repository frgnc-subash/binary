using System.Collections.Generic;

namespace binary.Core.Helpers
{
    // One set of stroke icons (24px grid, 2px round strokes) used everywhere instead of emoji,
    // so every icon renders identically on every OS and matches the sidebar/button icons.
    public static class Icons
    {
        private static readonly Dictionary<string, string> Paths = new Dictionary<string, string>
        {
            // learner titles
            { "sprout", "<path d=\"M7 20h10\"/><path d=\"M10 20c5.5-2.5.8-6.4 3-10\"/><path d=\"M9.5 9.4c1.1.8 1.8 2.2 2.3 3.7-2 .4-3.5.4-4.8-.3-1.2-.6-2.3-1.9-3-4.2 2.8-.5 4.4 0 5.5.8z\"/><path d=\"M14.1 6a7 7 0 0 0-1.1 4c1.9-.1 3.3-.6 4.3-1.4 1-1 1.6-2.3 1.7-4.6-2.7.1-4 1-4.9 2z\"/>" },
            { "rocket", "<path d=\"M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z\"/><path d=\"m12 15-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.35 22.35 0 0 1-4 2z\"/><path d=\"M9 12H4s.55-3.03 2-4c1.62-1.08 5 0 5 0\"/><path d=\"M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5\"/>" },
            { "flame", "<path d=\"M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z\"/>" },
            { "graduation", "<path d=\"M22 10 12 5 2 10l10 5 10-5z\"/><path d=\"M6 12v5c3 3 9 3 12 0v-5\"/><path d=\"M22 10v6\"/>" },
            { "crown", "<path d=\"m2 5 3.5 12h13L22 5l-6 6-4-7-4 7-6-6z\"/><path d=\"M5 21h14\"/>" },

            // general UI
            { "video", "<polygon points=\"23 7 16 12 23 17 23 7\"/><rect x=\"1\" y=\"5\" width=\"15\" height=\"14\" rx=\"2\"/>" },
            { "lock", "<rect x=\"4\" y=\"11\" width=\"16\" height=\"10\" rx=\"2\"/><path d=\"M8 11V7a4 4 0 0 1 8 0v4\"/>" },
            { "bolt", "<polygon points=\"13 2 3 14 12 14 11 22 21 10 12 10 13 2\"/>" },
            { "check", "<polyline points=\"20 6 9 17 4 12\"/>" },
            { "users", "<path d=\"M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2\"/><circle cx=\"9\" cy=\"7\" r=\"4\"/><path d=\"M23 21v-2a4 4 0 0 0-3-3.87\"/><path d=\"M16 3.13a4 4 0 0 1 0 7.75\"/>" },
            { "practice", "<path d=\"m3 7 2 2 4-4\"/><path d=\"m3 15 2 2 4-4\"/><line x1=\"11\" y1=\"8\" x2=\"21\" y2=\"8\"/><line x1=\"11\" y1=\"16\" x2=\"21\" y2=\"16\"/>" },
            { "trophy", "<path d=\"M8 21h8\"/><path d=\"M12 17v4\"/><path d=\"M7 4h10v5a5 5 0 0 1-10 0V4Z\"/><path d=\"M7 5H4.5a2.5 2.5 0 0 0 0 5H7\"/><path d=\"M17 5h2.5a2.5 2.5 0 0 1 0 5H17\"/>" },
            { "thumbs-up", "<path d=\"M7 10v12\"/><path d=\"M15 5.88 14 10h5.83a2 2 0 0 1 1.92 2.56l-2.33 8A2 2 0 0 1 17.5 22H4a2 2 0 0 1-2-2v-8a2 2 0 0 1 2-2h2.76a2 2 0 0 0 1.79-1.11L12 2a3.13 3.13 0 0 1 3 3.88Z\"/>" },
            { "target", "<circle cx=\"12\" cy=\"12\" r=\"10\"/><circle cx=\"12\" cy=\"12\" r=\"6\"/><circle cx=\"12\" cy=\"12\" r=\"2\"/>" },
            { "globe", "<circle cx=\"12\" cy=\"12\" r=\"10\"/><path d=\"M2 12h20\"/><path d=\"M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z\"/>" },
            { "sparkles", "<path d=\"m12 3-1.9 5.8a2 2 0 0 1-1.3 1.3L3 12l5.8 1.9a2 2 0 0 1 1.3 1.3L12 21l1.9-5.8a2 2 0 0 1 1.3-1.3L21 12l-5.8-1.9a2 2 0 0 1-1.3-1.3Z\"/>" },
            { "upload", "<path d=\"M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4\"/><polyline points=\"17 8 12 3 7 8\"/><line x1=\"12\" y1=\"3\" x2=\"12\" y2=\"15\"/>" },
            { "book", "<path d=\"M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z\"/><path d=\"M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z\"/>" },

            // onboarding "why are you learning"
            { "plane", "<path d=\"M17.8 19.2 16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.1-1.1.5l-.3.5c-.2.5-.1 1 .3 1.3L9 12l-2 3H4l-1 1 3 2 2 3 1-1v-3l3-2 3.5 5.3c.3.4.8.5 1.3.3l.5-.2c.4-.3.6-.7.5-1.2z\"/>" },
            { "briefcase", "<rect x=\"2\" y=\"7\" width=\"20\" height=\"14\" rx=\"2\"/><path d=\"M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16\"/>" },
            { "tv", "<rect x=\"2\" y=\"7\" width=\"20\" height=\"15\" rx=\"2\"/><polyline points=\"17 2 12 7 7 2\"/>" },
            { "heart", "<path d=\"M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z\"/>" },
            { "smile", "<circle cx=\"12\" cy=\"12\" r=\"10\"/><path d=\"M8 14s1.5 2 4 2 4-2 4-2\"/><line x1=\"9\" y1=\"9\" x2=\"9.01\" y2=\"9\"/><line x1=\"15\" y1=\"9\" x2=\"15.01\" y2=\"9\"/>" },
        };

        // full <svg> for a named icon; decorative, so hidden from screen readers
        public static string Svg(string name, string cssClass = "ui-icon")
        {
            string body;
            if (name == null || !Paths.TryGetValue(name, out body)) body = Paths["sparkles"];
            return "<svg class=\"" + cssClass + "\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" " +
                   "stroke-linecap=\"round\" stroke-linejoin=\"round\" aria-hidden=\"true\">" + body + "</svg>";
        }
    }
}
