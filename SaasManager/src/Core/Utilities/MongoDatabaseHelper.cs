namespace Core.Utilities;

public class MongoDatabaseHelper
{
    private const int MAX_BYTES = 64;
    
    private static readonly Dictionary<short, char> NumberToChar = new()
    {
        {0, 'a'},
        {1, 'b'},
        {2, 'c'},
        {3, 'd'},
        {4, 'e'},
        {5, 'f'},
        {6, 'g'},
        {7, 'h'},
        {8, 'i'},
        {9, 'j'}
    };
    public static string SanitizeDatabaseName(string databaseName)
    {
        if (string.IsNullOrEmpty(databaseName))
            throw new ArgumentException("Database name cannot be empty");

        // İzin verilmeyen karakterler
        var invalidChars = new[] { ' ', '.', '$', '/', '\\', '\0' };

        // İzin verilmeyen karakterleri tire ile değiştir
        string sanitized = databaseName;
        foreach (var c in invalidChars)
        {
            sanitized = sanitized.Replace(c, '-');
        }

        // Birden fazla tireyi tek tireye çevir
        sanitized = string.Join("-", sanitized.Split(new[] { '-' }, StringSplitOptions.RemoveEmptyEntries));

        // Baştaki ve sondaki tireleri kaldır
        sanitized = sanitized.Trim('-');

        // UTF-8 byte uzunluğu kontrolü
        var byteCount = System.Text.Encoding.UTF8.GetByteCount(sanitized);
        if (byteCount > MAX_BYTES)
        {
            // Karakter karakter kısaltarak 64 byte sınırına uy
            while (byteCount > MAX_BYTES && sanitized.Length > 0)
            {
                sanitized = sanitized.Substring(0, sanitized.Length - 1);
                byteCount = System.Text.Encoding.UTF8.GetByteCount(sanitized);
            }
            sanitized = sanitized.TrimEnd('-');
        }

        if (string.IsNullOrEmpty(sanitized))
            throw new ArgumentException("Database name contains only invalid characters");
        
        var databaseNameReplaceNumberToChar = string.Join("", sanitized.Select(c => char.IsDigit(c) ? NumberToChar[short.Parse(c.ToString())]:c));

        return databaseNameReplaceNumberToChar;
    }
}
