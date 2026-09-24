using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;

namespace binary.Core.Helpers
{
    // How a lesson video should be played in the browser.
    public class VideoEmbed
    {
        public string Kind { get; set; }      // "youtube" | "vimeo" | "file"
        public string Source { get; set; }    // embed URL, or file URL
        public string YouTubeId { get; set; } // youtube only, for the thumbnail
    }

    // Lesson videos are stored in Lessons.VideoUrl as either an external link (YouTube, Vimeo,
    // or a direct video file) or the app-relative path of an uploaded file under ~/Uploads/Videos/.
    public static class VideoHelper
    {
        public const string VideoFolderVirtualPath = "~/Uploads/Videos/";
        public const int MaxUploadMegabytes = 200;   // keep in sync with the limits in Web.config
        public const long MaxUploadBytes = MaxUploadMegabytes * 1024L * 1024L;

        private static readonly HashSet<string> AllowedExtensions =
            new HashSet<string>(StringComparer.OrdinalIgnoreCase) { ".mp4", ".webm", ".ogv" };

        private static readonly Regex YouTubeId = new Regex(
            @"(?:youtube\.com/(?:watch\?(?:.*&)?v=|embed/|shorts/|live/)|youtu\.be/)([A-Za-z0-9_-]{11})",
            RegexOptions.IgnoreCase | RegexOptions.Compiled);

        private static readonly Regex VimeoId = new Regex(
            @"vimeo\.com/(?:video/)?(\d+)", RegexOptions.IgnoreCase | RegexOptions.Compiled);

        public static bool IsUploadedVideo(string videoUrl)
        {
            return !string.IsNullOrEmpty(videoUrl) &&
                   videoUrl.StartsWith(VideoFolderVirtualPath, StringComparison.OrdinalIgnoreCase);
        }

        public static bool IsValidUpload(HttpPostedFile file, out string error)
        {
            error = null;
            if (file == null || file.ContentLength <= 0)
            {
                error = "Please choose a video file.";
                return false;
            }
            if (file.ContentLength > MaxUploadBytes)
            {
                error = "Video must be " + MaxUploadMegabytes + " MB or smaller. For longer videos, upload to YouTube and paste the link instead.";
                return false;
            }
            string ext = Path.GetExtension(file.FileName);
            if (string.IsNullOrEmpty(ext) || !AllowedExtensions.Contains(ext))
            {
                error = "Please upload an MP4, WEBM, or OGV video. (MP4 plays in every browser.)";
                return false;
            }
            return true;
        }

        public static string BuildFileName(string originalFileName)
        {
            return "v_" + Guid.NewGuid().ToString("N") + Path.GetExtension(originalFileName).ToLowerInvariant();
        }

        // Accepts only links we know how to play, so a saved lesson never shows a broken player.
        // Only http(s) is allowed, which also rules out javascript: and other script URLs.
        public static bool TryNormalizeLink(string input, out string normalized, out string error)
        {
            normalized = null;
            error = null;
            string text = (input ?? "").Trim();

            Uri uri;
            if (!Uri.TryCreate(text, UriKind.Absolute, out uri) ||
                (uri.Scheme != Uri.UriSchemeHttp && uri.Scheme != Uri.UriSchemeHttps))
            {
                error = "Enter a full video link starting with https://";
                return false;
            }
            if (text.Length > 500)
            {
                error = "That video link is too long.";
                return false;
            }
            if (GetEmbed(text) == null)
            {
                error = "Use a YouTube or Vimeo link, or a direct link to an .mp4/.webm file.";
                return false;
            }

            normalized = text;
            return true;
        }

        // null if there's no video or it's in a format we can't play
        public static VideoEmbed GetEmbed(string videoUrl)
        {
            if (string.IsNullOrWhiteSpace(videoUrl)) return null;

            if (IsUploadedVideo(videoUrl))
                return new VideoEmbed { Kind = "file", Source = VirtualPathUtility.ToAbsolute(videoUrl) };

            Match yt = YouTubeId.Match(videoUrl);
            if (yt.Success)
            {
                string id = yt.Groups[1].Value;
                return new VideoEmbed
                {
                    Kind = "youtube",
                    YouTubeId = id,
                    // privacy-enhanced domain: no tracking cookies until the learner presses play
                    Source = "https://www.youtube-nocookie.com/embed/" + id + "?autoplay=1&rel=0&modestbranding=1"
                };
            }

            Match vimeo = VimeoId.Match(videoUrl);
            if (vimeo.Success)
                return new VideoEmbed { Kind = "vimeo", Source = "https://player.vimeo.com/video/" + vimeo.Groups[1].Value };

            Uri uri;
            if (Uri.TryCreate(videoUrl, UriKind.Absolute, out uri) && AllowedExtensions.Contains(Path.GetExtension(uri.AbsolutePath)))
                return new VideoEmbed { Kind = "file", Source = uri.AbsoluteUri };

            return null;
        }

        public static string GetSourceLabel(string videoUrl)
        {
            VideoEmbed embed = GetEmbed(videoUrl);
            if (embed == null) return "Video";
            if (IsUploadedVideo(videoUrl)) return "Uploaded video";
            if (embed.Kind == "youtube") return "YouTube";
            if (embed.Kind == "vimeo") return "Vimeo";
            return "Video link";
        }

        public static void TryDeleteUploadedFile(string videoUrl)
        {
            if (!IsUploadedVideo(videoUrl)) return;
            try
            {
                string path = HttpContext.Current.Server.MapPath(videoUrl);
                if (File.Exists(path)) File.Delete(path);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Failed to delete lesson video {0}: {1}", videoUrl, ex);
            }
        }
    }
}
