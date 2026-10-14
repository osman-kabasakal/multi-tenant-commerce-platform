using Famizyo.TrendyolIntegration.Models;
using Famizyo.TrendyolIntegration.Services.Shared;
using Famizyo.TrendyolIntegration.Settings;
using System.Net.Http;

namespace Famizyo.TrendyolIntegration.Services;

public class TrendyolRestaurantClient(TrendyolIntegrationSettings settings) : BaseClient<RestaurantList>(settings)
{
    private readonly TrendyolIntegrationSettings _settings = settings;
    public override string Url => $"store/meal/suppliers/{_settings.SaticiId}/stores";
    public override HttpMethod Method => HttpMethod.Get;
    public override Dictionary<string, object> QueryData { get; set; }
}