using System.Security.Claims;
using Core.Models.Configs;

namespace SaasManager.Application.Common.Interfaces.Security;


/// <summary>
/// Güvenlikle ilgili yardımcı metodları içeren servis
/// </summary>
public interface ISecurityService
{
    /// <summary>
    /// 6 haneli sayısal doğrulama kodu üretir
    /// </summary>
    string GenerateVerificationCode();

    /// <summary>
    /// Geçici oturum için token üretir
    /// </summary>
    string GenerateTempToken();

    /// <summary>
    /// Verilen stringi hash'ler
    /// </summary>
    string HashString(string input);

    /// <summary>
    /// Verilen hash'in geçerli olup olmadığını kontrol eder
    /// </summary>
    bool ValidateHash(string input, string hash);

    /// <summary>
    /// Güvenli rastgele string üretir
    /// </summary>
    /// <param name="length">Üretilecek string'in uzunluğu</param>
    /// <param name="useSpecialChars">Özel karakter kullanılsın mı</param>
    string GenerateRandomString(int length, bool useSpecialChars = false);

    string GenerateGuestToken(GuestAuthConfiguration authConfiguration, Guid guestId,DateTime? validTo=null);
    
    ClaimsPrincipal ValidateGuestToken(GuestAuthConfiguration authConfiguration, string token);

    string GenerateValidationToken(DateTime validTo);
    bool ValidateValidationToken(string token);
}
