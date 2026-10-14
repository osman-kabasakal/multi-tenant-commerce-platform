namespace SaasManager.Application.Common.Models.IdentityManagement;

public record VerificationStatusResponse
{
    /// <summary>
    /// Guest kaydının ID'si
    /// </summary>
    public Guid GuestId { get; init; }

    /// <summary>
    /// Email doğrulama durumu
    /// </summary>
    public bool IsEmailVerified { get; init; }

    /// <summary>
    /// Telefon doğrulama durumu
    /// </summary>
    public bool IsPhoneVerified { get; init; }

    /// <summary>
    /// Şu anki doğrulama adımı
    /// </summary>
    public string CurrentStep { get; init; } = string.Empty;

    /// <summary>
    /// Geçici token'ın geçerlilik süresi
    /// </summary>
    public string TokenExpiresAt { get; init; } = string.Empty;
}
