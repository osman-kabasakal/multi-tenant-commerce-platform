namespace SaasManager.Domain.Enums;

public enum NotificationType
{
    /// <summary>
    /// Sistem bildirimleri (bakım, güncelleme vb.)
    /// </summary>
    System = 0,

    /// <summary>
    /// Abonelik ile ilgili bildirimler
    /// </summary>
    Subscription = 1,

    /// <summary>
    /// Ödeme bildirimleri
    /// </summary>
    Payment = 2,

    /// <summary>
    /// Kurye bildirimleri
    /// </summary>
    Courier = 3,

    /// <summary>
    /// Stok bildirimleri
    /// </summary>
    Stock = 4,

    /// <summary>
    /// Sipariş bildirimleri
    /// </summary>
    Order = 5,

    /// <summary>
    /// Güvenlik bildirimleri
    /// </summary>
    Security = 6,

    /// <summary>
    /// Kampanya bildirimleri
    /// </summary>
    Campaign = 7,

    /// <summary>
    /// Genel duyurular
    /// </summary>
    Announcement = 8
}
