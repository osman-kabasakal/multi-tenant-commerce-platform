using Grand.Data;
using Grand.Data.Mongo;
using Grand.Domain.Cache;
using Grand.Infrastructure.Migrations;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;

namespace Grand.Business.System.Services.Migrations._2._2;

public class MigrationStaleCache_22 : IMigration
{
    public int Priority => 0;

    public DbVersion Version => new(2, 2);

    public Guid Identity => new("f1a645fa-0bcc-4957-96cf-dbcddd1d5875");

    public string Name => "Stale Cache Migration";

    public bool UpgradeProcess(IDatabaseContext database, IServiceProvider serviceProvider)
    {
        var logger = serviceProvider.GetRequiredService<ILogger<MigrationStaleCache_22>>();
        logger.LogInformation("MigrationStaleCache_22 started");
        try
        {
            var staleCacheRepository = serviceProvider.GetRequiredService<IRepository<CacheKeyCorrelation>>();
            database.CreateIndex<CacheKeyCorrelation>(staleCacheRepository, OrderBuilder<CacheKeyCorrelation>.Create().Ascending(x => x.CorrelationId), "IX_CacheKeyCorrelation_CorrelationId", true).GetAwaiter().GetResult();
            logger.LogInformation("MigrationStaleCache_22 completed");
            return true;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "MigrationStaleCache_22 failed");
            return false;
        }
    }
}
