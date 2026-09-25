using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace binary.Core.Helpers
{
    public class FlagOption
    {
        public string FileName { get; set; }   // e.g. "south-korea.png"
        public string Label { get; set; }      // e.g. "South Korea"
        public string VirtualPath { get { return FlagHelper.FlagFolderVirtualPath + FileName; } }
    }

    // The flag library lives in ~/Content/images/flags. Admins pick a course's flag from it or upload a
    // new one (which is added to the library). Courses store the virtual path in Courses.FlagImageUrl.
    public static class FlagHelper
    {
        public const string FlagFolderVirtualPath = "~/Content/images/flags/";
        public const long MaxUploadBytes = 1024 * 1024; // 1 MB

        // no SVG: an uploaded SVG can carry script and is served from our own origin
        private static readonly HashSet<string> AllowedExtensions =
            new HashSet<string>(StringComparer.OrdinalIgnoreCase) { ".png", ".jpg", ".jpeg", ".webp", ".gif" };

        private static string FolderPath
        {
            get { return HttpContext.Current.Server.MapPath(FlagFolderVirtualPath); }
        }

        public static List<FlagOption> GetLibrary()
        {
            if (!Directory.Exists(FolderPath)) return new List<FlagOption>();
            return Directory.GetFiles(FolderPath)
                .Select(Path.GetFileName)
                .Where(f => AllowedExtensions.Contains(Path.GetExtension(f)))
                .Select(f => new FlagOption { FileName = f, Label = ToLabel(f) })
                .OrderBy(o => o.Label)
                .ToList();
        }

        // only files that actually exist in the library are accepted, so a tampered form value can't
        // point a course at an arbitrary path
        public static string ToVirtualPath(string fileName)
        {
            if (string.IsNullOrWhiteSpace(fileName)) return null;
            string match = GetLibrary().Select(o => o.FileName)
                .FirstOrDefault(f => string.Equals(f, fileName, StringComparison.OrdinalIgnoreCase));
            return match == null ? null : FlagFolderVirtualPath + match;
        }

        public static string ToFileName(string virtualPath)
        {
            if (string.IsNullOrEmpty(virtualPath) ||
                !virtualPath.StartsWith(FlagFolderVirtualPath, StringComparison.OrdinalIgnoreCase)) return "";
            return virtualPath.Substring(FlagFolderVirtualPath.Length);
        }

        public static bool IsValidUpload(HttpPostedFile file, out string error)
        {
            error = null;
            if (file == null || file.ContentLength <= 0) { error = "Please choose a flag image."; return false; }
            if (file.ContentLength > MaxUploadBytes) { error = "Flag images must be 1 MB or smaller."; return false; }
            if (!AllowedExtensions.Contains(Path.GetExtension(file.FileName) ?? ""))
            {
                error = "Please upload the flag as a PNG, JPG, WEBP, or GIF image.";
                return false;
            }
            return true;
        }

        // saves an uploaded flag into the library under a clean, unique name and returns its virtual path
        public static string SaveUpload(HttpPostedFile file)
        {
            string error;
            if (!IsValidUpload(file, out error)) throw new binary.Models.ValidationException(error);

            Directory.CreateDirectory(FolderPath);
            string ext = Path.GetExtension(file.FileName).ToLowerInvariant();
            string baseName = CleanName(Path.GetFileNameWithoutExtension(file.FileName));

            string fileName = baseName + ext;
            for (int i = 2; File.Exists(Path.Combine(FolderPath, fileName)); i++)
                fileName = baseName + "-" + i + ext;

            file.SaveAs(Path.Combine(FolderPath, fileName));
            return FlagFolderVirtualPath + fileName;
        }

        // flag image, or the course's two-letter monogram when it has no flag
        public static string Render(string flagUrl, string courseTitle, string cssClass)
        {
            if (!string.IsNullOrEmpty(flagUrl))
            {
                string src = VirtualPathUtility.ToAbsolute(flagUrl);
                return "<img class=\"flag " + cssClass + "\" src=\"" + HttpUtility.HtmlAttributeEncode(src) + "\" alt=\"\" loading=\"lazy\" />";
            }
            return "<span class=\"flag flag-fallback " + cssClass + "\">" +
                   HttpUtility.HtmlEncode(DisplayHelper.GetTitleMonogram(courseTitle ?? "")) + "</span>";
        }

        // "Flag_of_South_Korea-512x341" -> "south-korea"
        private static string CleanName(string raw)
        {
            string s = raw.ToLowerInvariant();
            s = Regex.Replace(s, @"^flag[_\- ]of[_\- ]", "");
            s = Regex.Replace(s, @"[-_ ]?\d+x\d+$", "");
            s = Regex.Replace(s, @"[^a-z0-9]+", "-").Trim('-');
            return s.Length == 0 ? "flag" : (s.Length > 60 ? s.Substring(0, 60) : s);
        }

        private static string ToLabel(string fileName)
        {
            string words = Path.GetFileNameWithoutExtension(fileName).Replace('-', ' ').Replace('_', ' ');
            return CultureInfo.InvariantCulture.TextInfo.ToTitleCase(words);
        }
    }
}
