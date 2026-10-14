using Famizyo.Integration.Adisyo.Domain;

namespace Famizyo.Integration.Adisyo.Services;

public interface IAdisyoOrderMappingService
{
    /// <summary>
    /// GrandNode sipariş ID'sine göre mapping'i getirir
    /// </summary>
    Task<AdisyoOrderMapping?> GetByGrandNodeOrderIdAsync(string grandNodeOrderId);
    
    /// <summary>
    /// Adisyo sipariş ID'sine göre mapping'i getirir
    /// </summary>
    Task<AdisyoOrderMapping?> GetByAdisyoOrderIdAsync(int adisyoOrderId);
    
    /// <summary>
    /// Yeni mapping ekler
    /// </summary>
    Task InsertAsync(AdisyoOrderMapping mapping);
    
    /// <summary>
    /// Mapping'i günceller
    /// </summary>
    Task UpdateAsync(AdisyoOrderMapping mapping);
    
    /// <summary>
    /// Mapping'i siler
    /// </summary>
    Task DeleteAsync(AdisyoOrderMapping mapping);
    
    /// <summary>
    /// Belirli duruma sahip mapping'leri getirir
    /// </summary>
    Task<List<AdisyoOrderMapping>> GetBySyncStatusAsync(string syncStatus);
    
    /// <summary>
    /// Belirli tarihten sonra güncellenmiş mapping'leri getirir
    /// </summary>
    Task<List<AdisyoOrderMapping>> GetUpdatedAfterAsync(DateTime date);
}