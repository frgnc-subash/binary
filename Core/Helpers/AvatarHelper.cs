using System;
using System.Collections.Generic;
using System.IO;
using System.Web;

namespace binary.Core.Helpers
{
    // validates and names uploaded profile picture files
    public static class AvatarHelper
    {
        public const string AvatarFolderVirtualPath = "~/Uploads/Avatars/";
        public const long MaxFileSizeBytes = 2 * 1024 * 1024; // 2 MB

        private static readonly HashSet<string> AllowedExtensions =
            new HashSet<string>(StringComparer.OrdinalIgnoreCase) { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

        public static bool IsValidImage(HttpPostedFile file, out string error)
        {
            error = null;

            if (file == null || file.ContentLength <= 0)
            {
                error = "Please choose an image file.";
                return false;
            }

            if (file.ContentLength > MaxFileSizeBytes)
            {
                error = "Image must be 2 MB or smaller.";
                return false;
            }

            string ext = Path.GetExtension(file.FileName);
            if (string.IsNullOrEmpty(ext) || !AllowedExtensions.Contains(ext))
            {
                error = "Please upload a JPG, PNG, GIF, or WEBP image.";
                return false;
            }

            return true;
        }

        // unique per upload, so old cached copies never collide with a replacement image
        public static string BuildFileName(int userId, string originalFileName)
        {
            string ext = Path.GetExtension(originalFileName).ToLowerInvariant();
            return "u" + userId + "_" + Guid.NewGuid().ToString("N") + ext;
        }
    }
}
