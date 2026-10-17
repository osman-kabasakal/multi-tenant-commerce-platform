using Grand.Business.Core.Interfaces.Common.Stores;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Domain.Customers;
using Grand.Domain.Stores;
using Grand.Data;
using Grand.Infrastructure;
using Grand.Infrastructure.MultiTenant;
using Grand.Infrastructure.Plugins;
using Grand.Installer.Cli.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using MongoDB.Bson;
using MongoDB.Driver;
using Platform.Security;

namespace Grand.Installer.Cli.Services;

public static class ManagedScheduledTasks
{
    public static async Task RunAsync(IServiceScope scope, IServiceCollection registrations, IConfiguration config, TenantStatusMessage message)
    {
        if (!Guid.TryParseExact(message.TenantId, "N", out var tenant) || tenant == Guid.Empty || tenant.ToString("N") != message.TenantId)
            throw new InvalidOperationException("Choose a canonical owned tenant.");
        var output = config["Provisioning:TenantOutput"]!;
        var store = scope.ServiceProvider.GetRequiredService<IRepository<Store>>().Table.Single();
        await ManagedTenantInitialization.VerifyAsync(output, message.TenantId, message.StoreSubDomain, store.Id);
        var secrets = scope.ServiceProvider.GetRequiredService<ITenantSecrets>();
        if (await secrets.ResolveAsync(store.Id) != message.TenantId) throw new InvalidOperationException("Store alias ownership changed.");
        var mongo = new MongoUrl(message.MongoConnectionString);
        if (mongo.DatabaseName != "tenant_" + message.TenantId) throw new InvalidOperationException("Foreign tenant database rejected.");
        var settings = MongoClientSettings.FromUrl(mongo);
        settings.ServerSelectionTimeout = settings.ConnectTimeout = settings.SocketTimeout = TimeSpan.FromSeconds(10);
        var database = new MongoClient(settings).GetDatabase(mongo.DatabaseName);
        var plugins = (PluginManager.ReferencedPlugins ?? []).Where(x => x.Installed).ToArray();
        var expected = (config["Extensions:InstalledPlugins"] ?? "").Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
        if (expected.Length == 0 || expected.Except(plugins.Select(x => x.SystemName), StringComparer.Ordinal).Any())
            throw new InvalidOperationException("Every committed task plugin must be loaded.");
        foreach (var plugin in plugins)
            if (await database.GetCollection<BsonDocument>("InstalledPlugin").CountDocumentsAsync(new BsonDocument { ["SystemName"] = plugin.SystemName, ["Version"] = plugin.Version }) != 1)
                throw new InvalidOperationException("Scheduled tasks require the installed plugin version.");
        // Resolve only the selected implementation, rather than every optional integration's constructor.
        var registry = registrations.Where(x => x.ServiceType == typeof(IScheduleTask) && x.ImplementationType != null)
            .Select(x => x.ImplementationType!).Distinct().ToDictionary(x => x.FullName + ", " + x.Assembly.GetName().Name, StringComparer.Ordinal);
        if (!registry.ContainsKey(ManagedClientCacheTaskRegistration.Type)) throw new InvalidOperationException("The client cache task must be registered in this release.");
        await ManagedClientCacheTaskRegistration.EnsureAsync(database, store.Id);
        var batch = new ManagedScheduleBatch(database, store.Id);
        await batch.RunAsync(async task =>
        {
            var type = task.GetValue("Type", "").AsString;
            if (!registry.TryGetValue(type, out var implementation)) throw new InvalidOperationException("Unregistered scheduled task.");
            using var taskScope = scope.ServiceProvider.CreateScope();
            var services = taskScope.ServiceProvider;
            services.GetRequiredService<ITenantIdentityAccessor>().TenantId = store.Id;
            var background = await services.GetRequiredService<ICustomerService>().GetCustomerBySystemName(SystemCustomerNames.BackgroundTask)
                ?? throw new InvalidOperationException("Background customer is missing.");
            await services.GetRequiredService<IWorkContextSetter>().SetCurrentCustomer(background);
            await services.GetRequiredService<IStoreHelper>().SetCurrentStore(store.Id);
            await ((IScheduleTask)ActivatorUtilities.CreateInstance(services, implementation)).Execute();
        }, CancellationToken.None);
    }
}
