namespace SaasManager.Domain.Enums;

public enum BuildPriority
{
    /// <summary>
    /// Düşük öncelikli build
    /// </summary>
    Low = 0,

    /// <summary>
    /// Normal öncelikli build
    /// </summary>
    Normal = 1,

    /// <summary>
    /// Yüksek öncelikli build
    /// </summary>
    High = 2,

    /// <summary>
    /// Acil build gerektiren durumlar için
    /// </summary>
    Critical = 3
}
