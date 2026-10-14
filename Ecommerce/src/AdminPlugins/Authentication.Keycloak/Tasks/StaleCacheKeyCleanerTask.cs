using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Data;
using Grand.Domain.Cache;
using Grand.Domain.Tasks;
using Grand.Infrastructure.Configuration;
using System;

namespace Authentication.Keycloak.Tasks;

public class StaleCacheKeyCleanerTask(
    IRepository<CacheKeyCorrelation> cacheKeyCorrelationRepository
) : IScheduleTask
{
    public async Task Execute()
    {
        await cacheKeyCorrelationRepository.DeleteManyAsync(x => x.CreatedAt< DateTime.UtcNow.AddHours(-5));
    }
}
