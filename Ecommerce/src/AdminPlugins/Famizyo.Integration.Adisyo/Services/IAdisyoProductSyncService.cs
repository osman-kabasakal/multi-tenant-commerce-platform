using Famizyo.Integration.Adisyo.Models;

namespace Famizyo.Integration.Adisyo.Services;

public interface IAdisyoProductSyncService
{
    /// <summary>
    /// Adisyo'dan kategorileri ve ürünleri senkronize eder
    /// </summary>
    Task SyncProductsAndCategoriesAsync();
    
    /// <summary>
    /// Belirli bir kategoriyi senkronize eder
    /// </summary>
    Task<string> SyncCategoryAsync(AdisyoProductCategory category);
    
    /// <summary>
    /// Belirli bir ürünü senkronize eder
    /// </summary>
    Task<string> SyncProductAsync(AdisyoProduct product, string categoryId);
    
    /// <summary>
    /// Ürün özelliklerini (features) senkronize eder
    /// </summary>
    Task SyncProductFeaturesAsync(AdisyoProduct product, string grandNodeProductId);
    
    
    /// <summary>
    /// Adisyo API'sinden ürün kategorilerini getirir
    /// </summary>
    Task<List<AdisyoProductCategory>> GetProductCategoriesAsync();
    
    /// <summary>
    /// Senkronizasyon durumunu kontrol eder
    /// </summary>
    Task<bool> CanSyncProductsAsync();
}