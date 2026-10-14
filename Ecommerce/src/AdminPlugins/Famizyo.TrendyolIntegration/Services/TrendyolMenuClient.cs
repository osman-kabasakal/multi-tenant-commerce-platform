using Famizyo.TrendyolIntegration.Models;
using Famizyo.TrendyolIntegration.Services.Shared;
using Famizyo.TrendyolIntegration.Settings;
using System.Net.Http;

namespace Famizyo.TrendyolIntegration.Services;

public class TrendyolMenuClient: BaseClient<TrendyolMenuModel>
{
    private readonly TrendyolIntegrationSettings _settings;
    private readonly int _storeId;

    public TrendyolMenuClient(
        TrendyolIntegrationSettings settings,
        int storeId
    ):base(settings)
    {
        _settings = settings;
        _storeId = storeId;
    }

    public override string Url => $"product/meal/suppliers/{_settings.SaticiId}/stores/{_storeId}/products";
    public override HttpMethod Method => HttpMethod.Get;
    public override Dictionary<string, object> QueryData { get; set; }
}