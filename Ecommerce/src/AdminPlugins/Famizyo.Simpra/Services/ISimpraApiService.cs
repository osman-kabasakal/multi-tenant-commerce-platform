using Famizyo.Simpra.Models;

namespace Famizyo.Simpra.Services;

public interface ISimpraApiService
{
    // Menu Items API
    Task<SimpraBaseResponse<SimpraMenuItemResponse>> CreateMenuItemAsync(SimpraMenuItemRequest request);
    Task<SimpraBaseResponse<SimpraMenuItemResponse>> UpdateMenuItemAsync(string menuItemId,
        SimpraMenuItemRequest request);
    Task<SimpraBaseResponse<List<SimpraMenuItemResponse>>> GetMenuItemsAsync(
        int page = 1, 
        int perPage = 50, 
        long? updatedAt = null, 
        string? status = null, 
        string? propertyIds = null, 
        string? sku = null);
    Task<SimpraBaseResponse<SimpraMenuItemResponse>> GetMenuItemAsync(string menuItemId);
    
    // Menu Item Groups API
    Task<SimpraBaseResponse<List<SimpraMenuItemGroup>>> GetMenuItemGroupsAsync();
    
    // Check (Orders) API
    Task<SimpraBaseResponse<SimpraCrudCheckResponse>> CreateCheckAsync(SimpraCheckRequest request);
    Task<SimpraBaseResponse<SimpraChecksResponse>> GetChecksAsync(
        int page = 1, 
        int perPage = 50, 
        string? businessDate = null,
        string? businessDateSince = null,
        string? businessDateUntil = null,
        string? status = null,
        string? sortBy = "desc",
        long? updatedAt = null,
        long? closedAtSince = null,
        long? closedAtUntil = null,
        string? revenueCenterId = null,
        string? tableId = null);
    Task<SimpraBaseResponse<SimpraCheckResponse>> GetCheckAsync(int checkId);
    
    // Check Payments API
    Task<SimpraBaseResponse<object?>?> CreateCheckPaymentAsync(string checkId, SimpraCheckPaymentRequest? request);
    
    // Delivery Status API
    Task<SimpraBaseResponse<object>> UpdateDeliveryStatusAsync(int checkId, SimpraDeliveryStatusRequest request);
    
    // Check Item Cancel API
    Task<SimpraBaseResponse<object>> CancelCheckItemAsync(int checkId, int checkItemId, SimpraCheckItemCancelRequest request);
    
    // Payment Types API
    Task<SimpraBaseResponse<List<SimpraPaymentType>>> GetPaymentTypesAsync();
    
    // Condiment Groups API
    Task<SimpraBaseResponse<List<SimpraCondimentGroup>>> GetCondimentGroupsAsync();
    
    // Test Connection
    Task<bool> TestConnectionAsync();
    
    // Revenue Centers API
    Task<SimpraBaseResponse<List<SimpraRevenueCenter>>> GetRevenueCentersAsync();
    
    // Sales Channels API
    Task<SimpraBaseResponse<List<SimpraSalesChannel>>> GetSalesChannelsAsync();
    
    // Employees API
    Task<SimpraBaseResponse<List<SimpraEmployee>>> GetEmployeesAsync();
    
    // Item Definitions API - for pricing and availability per revenue center
    Task<SimpraBaseResponse<List<SimpraItemDefinition>>> GetItemDefinitionsAsync(
        int page = 1,
        int perPage = 50,
        long updatedAt = 0,
        string? status = null,
        string? sourceType = null,
        string? sourceId = null,
        string? targetId = null,
        string? propertyIds = null);
    
    // Taxes API - for tax categories
    Task<SimpraBaseResponse<List<SimpraTax>>> GetTaxesAsync();
    
    // Condiments API - for condiment items
    Task<SimpraBaseResponse<List<SimpraCondiment>>> GetCondimentsAsync(
        int page = 1,
        int perPage = 50,
        string? status = null,
        long updatedAt = 0);
    
    // Service Charges API
    Task<SimpraBaseResponse<List<SimpraServiceCharge>>> GetServiceChargesAsync();
    Task<SimpraBaseResponse<SimpraCheckServiceChargeResponse>> CreateCheckServiceChargeAsync(string checkId, SimpraCheckServiceChargeRequest request);
}