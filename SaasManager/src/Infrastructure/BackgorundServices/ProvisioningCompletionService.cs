using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Platform.Provisioning;
using Platform.Security;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Domain.Common;
using SaasManager.Domain.Enums;

namespace SaasManager.Infrastructure.BackgorundServices;

/// <summary>Reconciles persisted completion after SaaS downtime; no transient Redis completion message is required.</summary>
public sealed class ProvisioningCompletionService(IServiceScopeFactory scopes,ILogger<ProvisioningCompletionService> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                using var scope=scopes.CreateScope();
                var db=scope.ServiceProvider.GetRequiredService<IApplicationDbContext>();
                var queue=scope.ServiceProvider.GetRequiredService<IProvisioningQueue>();
                var secrets=scope.ServiceProvider.GetRequiredService<ITenantSecrets>();
                var pending=await db.Businesses.Where(b=>b.Status==BusinessStatus.UnderSetup && !b.IsDeleted).OrderBy(b=>b.CreatedAt).Take(100).ToListAsync(stoppingToken);
                foreach (var business in pending)
                {
                    var tenant=business.Id.ToString("N");
                    var job=await queue.GetAsync(tenant,stoppingToken);
                    if (job?.State!="Succeeded") continue;
                    var metadata=await db.DatabaseConfigs.FirstOrDefaultAsync(d=>d.BusinessId==business.Id,stoppingToken);
                    if (metadata==null)
                    {
                        metadata=MongoConnectionMapper.MapMetadataFromConnectionString(await secrets.GetAsync(tenant,TenantSecretNames.DatabaseConnection,stoppingToken),
                            "tenant-secret:"+tenant+"/"+TenantSecretNames.DatabaseConnection);
                        metadata.SetBusiness(business);db.DatabaseConfigs.Add(metadata);
                    }
                    metadata.MarkAsMigrated();
                    var isTrial=await db.BusinessSubscriptions.AnyAsync(s=>s.BusinessId==business.Id && s.IsActive && s.IsTrial,stoppingToken);
                    business.UpdateStatus(isTrial?BusinessStatus.Trial:BusinessStatus.Active);
                    if (job.Steps.TryGetValue("publication",out var publication) && publication.Resources.TryGetValue("storeUrl",out var storeUrl))
                        foreach(var app in await db.BusinessApps.Where(a=>a.BusinessId==business.Id && !a.IsDeleted).ToListAsync(stoppingToken))
                            app.UpdateStoreUrl(storeUrl);
                    await db.SaveChangesAsync(stoppingToken);
                }
            }
            catch (OperationCanceledException) when(stoppingToken.IsCancellationRequested) {break;}
            catch (Exception exception) {logger.LogWarning("Provisioning completion reconciliation failed ({ErrorType})",exception.GetType().Name);}
            await Task.Delay(TimeSpan.FromSeconds(2),stoppingToken);
        }
    }
}
