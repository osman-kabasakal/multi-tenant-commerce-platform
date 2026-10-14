using System;
using System.Text;

namespace DartModelGenerator;

public static class StringExtensions
{
    public static string ToSnakeCase(this string str)
    {
        if (string.IsNullOrEmpty(str))
        {
            return str;
        }

        var result = new StringBuilder();
        bool previousWasUpper = false;

        for (int i = 0; i < str.Length; i++)
        {
            char currentChar = str[i];

            // Büyük harf varsa, alt çizgi ekle ve küçük harfe çevir
            if (char.IsUpper(currentChar))
            {
                if (i > 0 && !previousWasUpper)
                {
                    result.Append('_');
                }
                result.Append(char.ToLower(currentChar));
                previousWasUpper = true;
            }
            else
            {
                result.Append(currentChar);
                previousWasUpper = false;
            }
        }

        return result.ToString();
    }

    public static string ToCamelCase(this string str)
    {
        if (string.IsNullOrEmpty(str))
        {
            return str;
        }

        // Boşluk veya alt çizgi ile ayrılmış kelimeleri ayır
        var words = str.Split(new[] { ' ', '_' }, StringSplitOptions.RemoveEmptyEntries);

        // İlk kelimeyi küçük harfle başlat
        var result = words[0].ToLower();

        // Diğer kelimelerin ilk harfini büyük yap ve birleştir
        for (int i = 1; i < words.Length; i++)
        {
            result += char.ToUpper(words[i][0]) + words[i].Substring(1).ToLower();
        }

        return result;
    }
}
