namespace SaasManager.Domain.Enums;

public enum LogSeverity
{
    /// <summary>
    /// Debug/geliştirme logları
    /// </summary>
    Debug = 0,

    /// <summary>
    /// Bilgi amaçlı loglar
    /// </summary>
    Information = 1,

    /// <summary>
    /// Uyarı logları
    /// </summary>
    Warning = 2,

    /// <summary>
    /// Hata logları
    /// </summary>
    Error = 3,

    /// <summary>
    /// Kritik hatalar
    /// </summary>
    Critical = 4
}
