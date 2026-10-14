using Grand.Domain.Configuration;

namespace Famizyo.TrendyolIntegration.Settings;

public class TrendyolIntegrationSettings: ISettings
{
    public string? SaticiId { get; set; }

    public string? ApiKey { get; set; }

    public string? ApiSecret { get; set; }

    public int? StoreId { get; set; }
    public int? BestSellerSectionId { get; set; }
    public int? NewSectionId { get; set; }
}