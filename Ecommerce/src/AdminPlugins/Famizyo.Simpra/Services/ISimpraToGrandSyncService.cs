using Grand.Domain.Catalog;
using Famizyo.Simpra.Models;

namespace Famizyo.Simpra.Services;

/// <summary>
/// Service for synchronizing products from Simpra to GrandNode
/// </summary>
public interface ISimpraToGrandSyncService
{
    /// <summary>
    /// Synchronizes products from Simpra to GrandNode
    /// </summary>
    Task SyncProductsFromSimpraAsync();

    /// <summary>
    /// Synchronizes only product prices from Simpra to GrandNode
    /// </summary>
    Task SyncProductPricesFromSimpraAsync();

    /// <summary>
    /// Synchronizes categories from Simpra menu item groups to GrandNode
    /// </summary>
    Task SyncCategoriesFromSimpraAsync();

    /// <summary>
    /// Imports a product image from Simpra
    /// </summary>
    Task ImportProductImageFromSimpraAsync(Product product, SimpraMenuItemImage imageInfo);

    /// <summary>
    /// Gets item definition (price and availability) for a menu item in a specific revenue center
    /// </summary>
    Task<SimpraItemDefinition?> GetItemDefinitionForMenuItemAsync(string menuItemId);
}