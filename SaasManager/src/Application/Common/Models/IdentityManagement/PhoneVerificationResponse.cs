namespace SaasManager.Application.Common.Models.IdentityManagement;

public record PhoneVerificationResponse
{
    /// <summary>
    /// Doğrulama süreci için geçici token
    /// </summary>
    public string TempToken { get; init; } = string.Empty;

    /// <summary>
    /// Doğrulama kodunun geçerlilik süresi (ISO 8601 formatında)
    /// </summary>
    public string ExpiresAt { get; init; } = string.Empty;

    /// <summary>
    /// Maskelenmiş telefon numarası (örn: +90 *** *** 1234)
    /// </summary>
    public string MaskedPhone { get; init; } = string.Empty;

    /// <summary>
    /// Bir sonraki doğrulama kodu gönderimi için beklenecek süre (saniye)
    /// </summary>
    public int ResendDelay { get; init; } = 60;

    /// <summary>
    /// Kalan doğrulama hakkı
    /// </summary>
    public int RemainingAttempts { get; init; } = 3;
}
