using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Application.Common.Utilities;

public static class BusinessExtensions 
    {
        /// <summary>
        /// İşletmenin yasal unvanını subdomain formatına dönüştürür
        /// </summary>
        /// <param name="business">Business entity'si</param>
        /// <returns>Subdomain formatında string</returns>
        public static string ToSubdomain(this Business business)
        {
            if (business == null)
                throw new ArgumentNullException(nameof(business));

            if (string.IsNullOrWhiteSpace(business.LegalCompanyName))
                throw new ArgumentException("LegalCompanyName cannot be empty", nameof(business));

            return business.Name.ToSubdomain();
        }

        /// <summary>
        /// String'i subdomain formatına dönüştürür
        /// </summary>
        /// <param name="input">Dönüştürülecek string</param>
        /// <returns>Subdomain formatında string</returns>
        public static string ToSubdomain(this string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                throw new ArgumentException("Input cannot be empty", nameof(input));

            // Türkçe karakterleri dönüştür
            var normalized = input.Normalize(NormalizationForm.FormD);
            var withoutDiacritics = new string(
                normalized.Where(c => CharUnicodeInfo.GetUnicodeCategory(c) != UnicodeCategory.NonSpacingMark)
                .ToArray()
            );

            // Küçük harfe çevir
            var lowercase = withoutDiacritics.ToLowerInvariant();

            // İzin verilen karakterler dışındakileri tire ile değiştir
            var replaced = Regex.Replace(lowercase, @"[^a-z0-9]", "-");

            // Birden fazla tireyi tekli tireye dönüştür
            var singleHyphen = Regex.Replace(replaced, @"-+", "-");

            // Baştaki ve sondaki tireleri kaldır
            var trimmed = singleHyphen.Trim('-');

            // Boş string kontrolü
            if (string.IsNullOrEmpty(trimmed))
                return "default";

            // Maksimum 63 karakter (DNS standardı)
            return trimmed.Length > 63 ? trimmed.Substring(0, 63).TrimEnd('-') : trimmed;
        }
    }
