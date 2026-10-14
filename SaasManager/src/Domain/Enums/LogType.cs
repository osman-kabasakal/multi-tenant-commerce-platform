namespace SaasManager.Domain.Enums;

public enum LogType
{
    /// <summary>
    /// Genel bilgi logları
    /// </summary>
    Info = 0,

    /// <summary>
    /// İşletme kayıt ve yaşam döngüsü logları
    /// </summary>
    Business = 1,

    /// <summary>
    /// Ödeme işlemleri logları
    /// </summary>
    Payment = 2,

    /// <summary>
    /// Entegrasyon logları
    /// </summary>
    Integration = 3,

    /// <summary>
    /// Güvenlik ile ilgili loglar
    /// </summary>
    Security = 4,

    /// <summary>
    /// Sistem hataları
    /// </summary>
    Error = 5,

    /// <summary>
    /// Veritabanı işlem logları
    /// </summary>
    Database = 6,

    /// <summary>
    /// Performans metrikleri
    /// </summary>
    Performance = 7,

    /// <summary>
    /// Uygulama build ve deployment logları
    /// </summary>
    Deployment = 8,

    /// <summary>
    /// Kurye işlemleri logları
    /// </summary>
    Courier = 9
}
