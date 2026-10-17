using System.Text.Json;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Data;
using Grand.Domain.Customers;
using Grand.Domain.PushNotifications;
using Grand.Infrastructure;
using Grand.Infrastructure.Caching.Redis;
using Microsoft.Extensions.Logging;
using Platform.Notifications;
using Platform.Security;

namespace Grand.Business.Marketing.Services.BackgroundServices;

/// <summary>Runs in the existing leased tenant scheduler, using only that tenant's customers and sender.</summary>
public sealed class ClientCacheNotificationTask(TenantCacheJournal journal, IWorkContext context,
    IRepository<Customer> customers, IRepository<PushRegistration> registrations, ITenantPushSender sender,
    ITenantSecrets secrets, NotificationOptions options, ILogger<ClientCacheNotificationTask> logger) : IScheduleTask
{
    public async Task Execute()
    {
        if (!journal.Enabled || options.Provider == "Disabled") return;
        var store = journal.CurrentStore();
        if (string.IsNullOrEmpty(store) || context.CurrentStore?.Id != store)
            throw new InvalidOperationException("Client cache task requires the current owned tenant store.");
        var tenant = await secrets.ResolveAsync(store);
        if (!Guid.TryParseExact(tenant, "N", out var id) || id == Guid.Empty)
            throw new InvalidOperationException("Client cache task requires a canonical tenant alias.");
        var failed = false;
        foreach (var owner in await journal.NextOwnersAsync(store))
        {
            var customer = customers.Table.FirstOrDefault(x => x.Id == owner && (x.StoreId == store || x.StoreId == null || x.StoreId == "") && x.Active && !x.Deleted);
            if (customer == null) continue;
            var tokens = registrations.Table.Where(x => x.CustomerId == owner && x.Allowed)
                .Select(x => x.Token).ToList().Where(x => !string.IsNullOrWhiteSpace(x) && x != "[DENIED]").Distinct(StringComparer.Ordinal).ToArray();
            if (tokens.Length == 0) continue;
            try
            {
                foreach (var batch in (await journal.PendingAsync(store, owner)).Chunk(20))
                {
                    var message = new TenantPushMessage(null, null, Data: new Dictionary<string, string> {
                        ["Type"] = "cache_invalidation", ["TenantId"] = tenant, ["StoreId"] = store,
                        ["CorrelationIds"] = JsonSerializer.Serialize(batch.Select(x => x.CorrelationId)),
                        ["RefreshCacheTime"] = DateTime.UtcNow.ToString("O")
                    });
                    var complete = true;
                    foreach (var target in tokens.Chunk(500))
                    {
                        var receipt = await sender.SendAsync(tenant, target, message);
                        if (receipt.Accepted != target.Length || receipt.Attempted != target.Length) complete = false;
                    }
                    // A crash or partial provider rejection may repeat an invalidation; it must not lose one.
                    if (complete) await journal.AcknowledgeAsync(store, owner, batch);
                    else failed = true;
                }
            }
            catch (Exception error)
            {
                failed = true;
                logger.LogWarning("Client cache delivery retained for retry ({ErrorType}).", error.GetType().Name);
            }
        }
        if (failed) throw new InvalidOperationException("Some client cache changes remain pending for delivery.");
    }
}
