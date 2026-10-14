namespace SaasManager.Application.Common.Models.IdentityManagement;

public record VerifyCodeResponse
{
    /// <summary>
    /// Doğrulama başarılı mı?
    /// </summary>
    public bool IsVerified { get; init; }

    /// <summary>
    /// Sonraki adım (örn: PHONE_VERIFICATION, BUSINESS_INFO)
    /// </summary>
    public string NextStep { get; init; } = string.Empty;

    /// <summary>
    /// Kalan doğrulama hakkı
    /// </summary>
    public int RemainingAttempts { get; init; }

    /// <summary>
    /// Başarısız doğrulama durumunda yeni kod için beklenecek süre (saniye)
    /// </summary>
    public int? WaitDuration { get; init; }
}
