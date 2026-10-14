using Core.Models.Responses;
using Microsoft.Extensions.Caching.Memory;
using SaasManager.Application.Common.Interfaces.Cache;
using SaasManager.Application.Common.Models.SubscriptionPlans;

namespace SaasManager.Application.SubscriptionPlans.Queries.GetSubscriptionPlans;

public class CachedSubscriptionPlansQueryHandler : IRequestHandler<GetSubscriptionPlansQuery, ServiceResponse<List<SubscriptionPlanDto>>>
{
    private readonly IRequestHandler<GetSubscriptionPlansQuery, ServiceResponse<List<SubscriptionPlanDto>>> _decorated;
    private readonly ICacheBase _cache;
    private static readonly string CacheKey = "subscription_plans";
    private static readonly TimeSpan CacheDuration = TimeSpan.FromMinutes(30);

    public CachedSubscriptionPlansQueryHandler(
        GetSubscriptionPlansQueryHandler decorated,
        ICacheBase cache)
    {
        _decorated = decorated;
        _cache = cache;
    }

    public async Task<ServiceResponse<List<SubscriptionPlanDto>>> Handle(
        GetSubscriptionPlansQuery request,
        CancellationToken cancellationToken)
    {
        var response = await _cache.GetAsync(CacheKey, async () =>
        {
            var response = await _decorated.Handle(request, cancellationToken);
            if (response.IsSuccess)
            {
                return response.Data;
            }

            return null;
        });

        return ServiceResponse<List<SubscriptionPlanDto>>.Success(response??[]);
    }
}
