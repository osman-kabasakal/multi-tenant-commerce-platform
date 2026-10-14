namespace Core.Utilities;

public static class CardDataHelper
{
    public static string MaskCardNumber(this string cardNumber)
    {
        if (string.IsNullOrWhiteSpace(cardNumber))
            return string.Empty;

        // İlk 6 ve son 4 haneyi göster, aradakileri maskele
        var firstSix = cardNumber.Substring(0, 6);
        var lastFour = cardNumber.Substring(cardNumber.Length - 4);
        var maskedLength = cardNumber.Length - 10;

        return $"{firstSix}{new string('*', maskedLength)}{lastFour}";
    }

    public static string GetCardBrand(this string cardNumber)
    {
        if (string.IsNullOrWhiteSpace(cardNumber))
            return "Unknown";

        // BIN (Bank Identification Number) kontrolü
        var bin = cardNumber.Substring(0, Math.Min(cardNumber.Length, 6));

        return bin switch
        {
            string s when s.StartsWith("4") => "Visa",
            string s when s.StartsWith("5") => "MasterCard",
            string s when s.StartsWith("34") || s.StartsWith("37") => "AmericanExpress",
            string s when s.StartsWith("6") => "Discover",
            _ => "Unknown"
        };
    }
}
