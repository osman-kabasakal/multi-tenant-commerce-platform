namespace Core.Utilities;

public static class MongoUsernameHelper
{
    private const int MIN_LENGTH = 3;
    private const int MAX_LENGTH = 64;
    
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

    private static readonly Dictionary<char, char> InvalidCharToValidChar = new Dictionary<char, char>()
    {
        { ' ','a' },
        { '.','b' },
        { ',', 'c' },
        { ';', 'd' },
        { ':', 'e' },
        { '?' , 'f' },
        { '!', 'g' },
        { '@', 'h' },
        { '#', 'i' },
        { '$','o' },
        { '&','u' },
        { '=','v' },
        { '\'','y' },
        { '"','z' },
        { '/','x' },
        { '\\','j' },
        { '{','k' },
        { '}','l' },
        { '[','m' },
        { ']','n' },
        { '(','p' },
        { ')','q' },
        { '<' , 'r' },
        { '>', 's' },
        { '|','t' },
        { '%','w' },
        { '-', 'a' },
        { '+', 'b' }
    };

    public static string SanitizeMongoUsername(string username)
    {
        if (string.IsNullOrEmpty(username))
            throw new ArgumentException("Username cannot be empty");

        // İzin verilmeyen karakterleri kaldır
        var invalidChars = new[]
        {
            ' ', '.', ',', ';', ':', '?', '!', '@', '#', '$', '&', '=', '\'', '"', '/', '\\', '{', '}', '[', ']',
            '(', ')', '<', '>', '|', '%', '-', '+'
        };

        // Tüm izin verilmeyen karakterleri alt çizgi ile değiştir
        string sanitized = string.Join("", username.Select(c => InvalidCharToValidChar.ContainsKey(c) ? InvalidCharToValidChar[c] : c));
        

        // Birden fazla alt çizgiyi tek alt çizgiye çevir
        sanitized = string.Join("_", sanitized.Split(new[] { '_' }, StringSplitOptions.RemoveEmptyEntries));

        // Minimum uzunluk kontrolü
        if (sanitized.Length < MIN_LENGTH)
        {
            sanitized = sanitized + "_" +
                        PasswordGenerator.GenerateRandomPassword(4,
                            true,
                            false,
                            false,
                            false);
        }

        // Maksimum 64 karakter olacak şekilde kes
        if (sanitized.Length > MAX_LENGTH)
        {
            sanitized = sanitized.Substring(0, MAX_LENGTH);
        }

        var userNameReplaceNumberToChar = string.Join("", sanitized.Select(c => char.IsDigit(c) ? NumberToChar[short.Parse(c.ToString())]:c));
        return userNameReplaceNumberToChar;
    }
}
