using Famizyo.Integration.Adisyo.Models;

namespace Famizyo.Integration.Adisyo.Services;

public interface IAdisyoApiService
{
    /// <summary>
    /// Gets all products from Adisyo API
    /// </summary>
    Task<List<AdisyoProductCategory>> GetProductsAsync();
    
    /// <summary>
    /// Gets product categories from Adisyo API (alias for GetProductsAsync)
    /// </summary>
    Task<List<AdisyoProductCategory>> GetProductCategoriesAsync();
    
    
    /// <summary>
    /// Gets sophisticated feature groups with detailed structure from Adisyo API
    /// </summary>
    Task<AdisyoFeaturesResponse> GetFeatureGroupsAsync();
    
    
    /// <summary>
    /// Gets available payment types from Adisyo API
    /// </summary>
    Task<List<AdisyoPaymentType>> GetPaymentTypesAsync();
    
    /// <summary>
    /// Sends order to Adisyo API
    /// </summary>
    Task<AdisyoOrderResponse> SaveOrderAsync(AdisyoOrderRequest orderRequest);
    
    /// <summary>
    /// Cancels an order in Adisyo
    /// </summary>
    Task<AdisyoApiResponse<object>> CancelOrderAsync(int orderId, string? cancelReason = null);
    
    /// <summary>
    /// Gets recent orders from Adisyo
    /// </summary>
    Task<AdisyoOrderQueryResponse> GetRecentOrdersAsync(AdisyoRecentOrdersRequest request);
    
    /// <summary>
    /// Gets completed orders from Adisyo
    /// </summary>
    Task<CompletedOrderRequestResponse> GetCompletedOrdersAsync(AdisyoCompletedOrdersRequest request);
    
    Task<byte[]> GetImageWithUrl(string imageUrl);
}