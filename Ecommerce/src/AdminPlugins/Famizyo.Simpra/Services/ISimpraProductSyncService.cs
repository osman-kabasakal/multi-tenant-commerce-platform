namespace Famizyo.Simpra.Services;

/// <summary>
/// Composite service that orchestrates both GrandNode to Simpra and Simpra to GrandNode synchronization
/// </summary>
public interface ISimpraProductSyncService
{
    /// <summary>
    /// Performs bidirectional product synchronization based on settings
    /// </summary>
    Task SyncProductsBidirectionalAsync();

    /// <summary>
    /// Performs bidirectional price synchronization based on settings
    /// </summary>
    Task SyncProductPricesBidirectionalAsync();
}