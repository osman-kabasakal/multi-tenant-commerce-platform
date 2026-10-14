using Grand.Domain.Catalog;
using Famizyo.Simpra.Models;

namespace Famizyo.Simpra.Services;

/// <summary>
/// Service for synchronizing products from GrandNode to Simpra
/// </summary>
public interface IGrandToSimpraSyncService
{
    /// <summary>
    /// Synchronizes products from GrandNode to Simpra
    /// </summary>
    Task SyncProductsToSimpraAsync();

    /// <summary>
    /// Synchronizes only product prices from GrandNode to Simpra
    /// </summary>
    Task SyncProductPricesToSimpraAsync();

    /// <summary>
    /// Converts a GrandNode product to Simpra menu item request
    /// </summary>
    Task<SimpraMenuItemRequest> ConvertProductToMenuItemAsync(Product product);

    /// <summary>
    /// Gets Simpra menu item group ID for a given GrandNode category
    /// </summary>
    Task<string?> GetSimpraMenuItemGroupIdAsync(string categoryId);

    /// <summary>
    /// Checks if a product should be synchronized to Simpra
    /// </summary>
    bool ShouldSyncProduct(Product product);

    /// <summary>
    /// Gets condiment groups for a product based on its attributes
    /// </summary>
    Task<List<SimpraCondimentGroup>> GetCondimentGroupsForProductAsync(Product product);
}