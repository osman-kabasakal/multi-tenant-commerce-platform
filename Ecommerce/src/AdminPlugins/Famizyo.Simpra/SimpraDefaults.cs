namespace Famizyo.Simpra;

public class SimpraDefaults
{
    public const string ProviderSystemName = "Famizyo.Simpra";
    public const string SimpraIntegrationFriendlyName = "Famizyo.Simpra.FriendlyName";
    
    public const string SimpraApiAuthHeaderKeyName = "Simpra-Access-Token";
    
    // Redis settings
    public const string RedisOrderStatusChannel = "simpra:order:status:updates";
    
    // Localization keys
    public const string AccessToken = "CHANGE_ME";
    public const string Environment = "Plugins.Simpra.Fields.Environment";
    public const string EnableProductSync = "Plugins.Simpra.Fields.EnableProductSync";
    public const string ProductMappingStrategy = "Plugins.Simpra.Fields.ProductMappingStrategy";
    public const string SelectedCategoryIds = "Plugins.Simpra.Fields.SelectedCategoryIds";
    public const string ProductSyncInterval = "Plugins.Simpra.Fields.ProductSyncInterval";
    public const string UpdateExistingProducts = "Plugins.Simpra.Fields.UpdateExistingProducts";
    public const string CreateNewProducts = "Plugins.Simpra.Fields.CreateNewProducts";
    public const string SyncProductPrices = "Plugins.Simpra.Fields.SyncProductPrices";
    public const string PublishSyncedProducts = "Plugins.Simpra.Fields.PublishSyncedProducts";
    public const string RevenueCenterId = "Plugins.Simpra.Fields.RevenueCenterId";
    public const string SalesChannelId = "Plugins.Simpra.Fields.SalesChannelId";
    public const string EmployeeId = "Plugins.Simpra.Fields.EmployeeId";
    public const string EnableOrderStatusSync = "Plugins.Simpra.Fields.EnableOrderStatusSync";
    public const string OrderStatusSyncInterval = "Plugins.Simpra.Fields.OrderStatusSyncInterval";
    public const string EnableOrderCancellation = "Plugins.Simpra.Fields.EnableOrderCancellation";
    public const string RedisChannelPrefix = "Plugins.Simpra.Fields.RedisChannelPrefix";
    public const string PaymentMethodMappings = "Plugins.Simpra.Fields.PaymentMethodMappings";
}