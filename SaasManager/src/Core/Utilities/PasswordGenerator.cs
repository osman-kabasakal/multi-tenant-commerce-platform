using System.Text;

namespace Core.Utilities;

public class PasswordGenerator
{
    private const string LowercaseChars = "abcdefghijklmnopqrstuvwxyz";
    private const string UppercaseChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private const string NumberChars = "0123456789";
    private const string SpecialChars = "!#$&*()";

    public static string GenerateRandomPassword(
        int length = 12,
        bool includeLowercase = true,
        bool includeUppercase = true,
        bool includeNumbers = true,
        bool includeSpecial = true)
    {
        if (length < 4)
            throw new ArgumentException("Password length must be at least 4 characters.");

        var chars = new StringBuilder();
        var random = new Random();
        var password = new StringBuilder();

        // Add character sets based on parameters
        if (includeLowercase) chars.Append(LowercaseChars);
        if (includeUppercase) chars.Append(UppercaseChars);
        if (includeNumbers) chars.Append(NumberChars);
        if (includeSpecial) chars.Append(SpecialChars);

        // Ensure at least one character from each selected set
        if (includeLowercase)
            password.Append(LowercaseChars[random.Next(LowercaseChars.Length)]);
        if (includeUppercase)
            password.Append(UppercaseChars[random.Next(UppercaseChars.Length)]);
        if (includeNumbers)
            password.Append(NumberChars[random.Next(NumberChars.Length)]);
        if (includeSpecial)
            password.Append(SpecialChars[random.Next(SpecialChars.Length)]);

        // Fill remaining length with random characters
        var allChars = chars.ToString();
        for (int i = password.Length; i < length; i++)
        {
            password.Append(allChars[random.Next(allChars.Length)]);
        }

        // Shuffle the password
        return new string(password.ToString()
            .OrderBy(c => random.Next())
            .ToArray());
    }
}
