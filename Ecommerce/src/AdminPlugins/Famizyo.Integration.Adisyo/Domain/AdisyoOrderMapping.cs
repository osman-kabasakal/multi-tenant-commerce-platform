using Grand.Domain;

namespace Famizyo.Integration.Adisyo.Domain;

public class AdisyoOrderMapping : BaseEntity
{
    /// <summary>
    /// GrandNode sipariş ID'si
    /// </summary>
    public string GrandNodeOrderId { get; set; } = string.Empty;
    
    /// <summary>
    /// Adisyo sipariş ID'si
    /// </summary>
    public int AdisyoOrderId { get; set; }
    
    /// <summary>
    /// Adisyo'ya gönderilme tarihi
    /// </summary>
    public DateTime SentToAdisyoDate { get; set; }
    
    /// <summary>
    /// Senkronizasyon durumu
    /// </summary>
    public string SyncStatus { get; set; } = "Sent"; // Sent, Failed, Cancelled
    
    /// <summary>
    /// Son senkronizasyon tarihi
    /// </summary>
    public DateTime LastSyncDate { get; set; }
    
    /// <summary>
    /// Hata mesajı (varsa)
    /// </summary>
    public string? ErrorMessage { get; set; }
    
    /// <summary>
    /// Adisyo sipariş durumu
    /// </summary>
    public string? AdisyoOrderStatus { get; set; }
    
    /// <summary>
    /// İptal nedeni (varsa)
    /// </summary>
    public string? CancelReason { get; set; }
}