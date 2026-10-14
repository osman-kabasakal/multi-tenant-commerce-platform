namespace SaasManager.Application.Common.Interfaces.Security;

/// <summary>
/// Tarih/saat işlemleri için yardımcı servis
/// </summary>
public interface IDateTime
{
    /// <summary>
    /// Şu anki UTC zamanını döner
    /// </summary>
    DateTime Now { get; }

    /// <summary>
    /// Şu anki UTC tarihi döner (saat 00:00:00)
    /// </summary>
    DateTime Today { get; }

    /// <summary>
    /// Unix timestamp olarak şu anki zamanı döner (UTC)
    /// </summary>
    long UnixTimestamp { get; }

    /// <summary>
    /// Verilen DateTime'ı ISO 8601 formatında string'e çevirir
    /// </summary>
    string FormatISO8601(DateTime dateTime);

    /// <summary>
    /// Verilen string'i DateTime'a parse eder (ISO 8601 format)
    /// </summary>
    DateTime? ParseISO8601(string dateTimeStr);
}
