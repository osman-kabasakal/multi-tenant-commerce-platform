namespace SaasManager.Domain.Enums;

public enum BanType
{
    /// <summary>
    /// Çok fazla başarısız deneme
    /// </summary>
    TooManyAttempts = 0,

    /// <summary>
    /// Şüpheli aktivite
    /// </summary>
    SuspiciousActivity = 1,

    /// <summary>
    /// Güvenlik ihlali
    /// </summary>
    SecurityViolation = 2,

    /// <summary>
    /// Spam aktivitesi
    /// </summary>
    Spam = 3,

    /// <summary>
    /// Manuel ban
    /// </summary>
    Manual = 4
}
