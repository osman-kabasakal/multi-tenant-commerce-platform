using System;
using System.Collections.Generic;
using System.IO;

/// <summary>
/// Utility class for working with MIME types
/// </summary>
public static class MimeTypeHelper
{
    /// <summary>
    /// Gets the MIME type for the specified file extension
    /// </summary>
    /// <param name="fileExtension">The file extension (with or without the leading dot)</param>
    /// <returns>The corresponding MIME type or "application/octet-stream" if not found</returns>
    public static string GetMimeType(string fileExtension)
    {
        if (string.IsNullOrEmpty(fileExtension))
            return "application/octet-stream";

        // Ensure the extension starts with a dot
        if (!fileExtension.StartsWith("."))
            fileExtension = "." + fileExtension;

        // Convert to lowercase for case-insensitive matching
        fileExtension = fileExtension.ToLowerInvariant();

        // Try to get the MIME type from the dictionary
        if (_mimeTypes.TryGetValue(fileExtension, out string mimeType))
            return mimeType;

        // Return default MIME type if not found
        return "application/octet-stream";
    }

    /// <summary>
    /// Dictionary of common file extensions and their corresponding MIME types
    /// </summary>
    private static readonly Dictionary<string, string> _mimeTypes = new Dictionary<string, string>
    {
        // Application
        { ".doc", "application/msword" },
        { ".docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document" },
        { ".pdf", "application/pdf" },
        { ".rtf", "application/rtf" },
        { ".xls", "application/vnd.ms-excel" },
        { ".xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" },
        { ".ppt", "application/vnd.ms-powerpoint" },
        { ".pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation" },
        { ".zip", "application/zip" },
        { ".7z", "application/x-7z-compressed" },
        { ".rar", "application/x-rar-compressed" },
        { ".exe", "application/x-msdownload" },
        { ".dll", "application/x-msdownload" },
        { ".json", "application/json" },
        { ".xml", "application/xml" },
        
        // Text
        { ".txt", "text/plain" },
        { ".csv", "text/csv" },
        { ".html", "text/html" },
        { ".htm", "text/html" },
        { ".css", "text/css" },
        { ".js", "text/javascript" },
        { ".md", "text/markdown" },
        
        // Image
        { ".jpg", "image/jpeg" },
        { ".jpeg", "image/jpeg" },
        { ".png", "image/png" },
        { ".gif", "image/gif" },
        { ".bmp", "image/bmp" },
        { ".svg", "image/svg+xml" },
        { ".webp", "image/webp" },
        { ".tiff", "image/tiff" },
        { ".tif", "image/tiff" },
        { ".ico", "image/x-icon" },
        
        // Audio
        { ".mp3", "audio/mpeg" },
        { ".wav", "audio/wav" },
        { ".ogg", "audio/ogg" },
        { ".flac", "audio/flac" },
        { ".aac", "audio/aac" },
        { ".m4a", "audio/mp4" },
        
        // Video
        { ".mp4", "video/mp4" },
        { ".avi", "video/x-msvideo" },
        { ".mov", "video/quicktime" },
        { ".wmv", "video/x-ms-wmv" },
        { ".mkv", "video/x-matroska" },
        { ".webm", "video/webm" },
        
        // Font
        { ".ttf", "font/ttf" },
        { ".otf", "font/otf" },
        { ".woff", "font/woff" },
        { ".woff2", "font/woff2" },
        
        // Programming
        { ".cs", "text/x-csharp" },
        { ".java", "text/x-java" },
        { ".py", "text/x-python" },
        { ".swift", "text/x-swift" },
        { ".php", "application/x-php" },
        
        // Others
        { ".sql", "application/sql" },
        { ".apk", "application/vnd.android.package-archive" },
        { ".ics", "text/calendar" }
    };
}
