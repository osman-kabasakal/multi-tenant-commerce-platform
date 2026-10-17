using System.Security.Cryptography;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Interfaces.Messages;
using Grand.Domain.Customers;
using Grand.Domain.Messages;
using MailKit.Security;
using System.Text.Json;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Catalog.Tax;
using Grand.Business.Core.Utilities.Catalog;
using Grand.Domain.Localization;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Data;
using Grand.Domain.Common;
using Grand.Domain.Directory;
using Grand.Domain.Stores;
using Grand.Domain.Tax;
using Grand.Infrastructure.Migrations;
using Grand.Infrastructure.Plugins;
using Grand.Installer.Cli.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using MongoDB.Bson;
using MongoDB.Driver;
using Platform.Security;

namespace Grand.Installer.Cli.Services;

public static class ManagedTenantTasks
{
    public static readonly string[] Names = ["tenant-plugins", "tenant-migrations", "tenant-settings", "tenant-domain"];
    public static readonly string[] AddressFields = ["lat", "long", "bno", "dno", "kno", "adres_tarifi"];

    private static int VerifyOriginalSettings(IServiceScope scope)
    {
        using var baseline=JsonDocument.Parse(File.ReadAllText(Path.Combine(AppContext.BaseDirectory,"App_Data","BusinessDefaults.json")));
        var settings=scope.ServiceProvider.GetRequiredService<ISettingService>();
        var domain=typeof(Store).Assembly;
        var count=0;
        foreach(var group in baseline.RootElement.GetProperty("settings").EnumerateObject())
        {
            var type=domain.GetTypes().Single(x=>x.Name==group.Name);
            var current=settings.LoadSetting(type);
            foreach(var expected in group.Value.EnumerateObject())
            {
                var property=type.GetProperty(expected.Name)!;
                var actual=property.GetValue(current);
                if(expected.Value.ValueKind==JsonValueKind.Object)
                {
                    if(!Equals(actual,Enum.Parse(property.PropertyType,expected.Value.GetProperty("enum").GetString()!)))
                        throw new InvalidOperationException("Original business setting mismatch: "+group.Name+"."+expected.Name);
                }
                else
                {
                    var wanted=JsonSerializer.Deserialize(expected.Value.GetRawText(),property.PropertyType);
                    if(!Equals(actual,wanted))throw new InvalidOperationException("Original business setting mismatch: "+group.Name+"."+expected.Name);
                }
                count++;
            }
        }
        Console.WriteLine("Verified original business settings from the tenant database: "+count);
        return count;
    }

    public static async Task RunAsync(string task, IServiceScope scope, IConfiguration config, TenantStatusMessage message)
    {
        if (!Names.Contains(task) || !Guid.TryParseExact(message.TenantId, "N", out var tenant) || tenant == Guid.Empty)
            throw new InvalidOperationException("Choose an owned managed tenant task.");
        var verifiedSettings=0;
        var output = config["Provisioning:TenantOutput"]!;
        using var metadata = JsonDocument.Parse(await File.ReadAllTextAsync(output));
        if (metadata.RootElement.GetProperty("profile").GetString() != "Portable" ||
            metadata.RootElement.GetProperty("tenantId").GetString() != message.TenantId ||
            metadata.RootElement.GetProperty("slug").GetString() != message.StoreSubDomain)
            throw new InvalidOperationException("Managed task metadata belongs to another tenant.");
        var mongo = new MongoUrl(message.MongoConnectionString);
        if (mongo.DatabaseName != "tenant_" + message.TenantId)
            throw new InvalidOperationException("Managed tasks cannot select a foreign tenant database.");
        var store = scope.ServiceProvider.GetRequiredService<IRepository<Store>>().Table.Single();
        if (store.Id != metadata.RootElement.GetProperty("storeId").GetString() ||
            await scope.ServiceProvider.GetRequiredService<ITenantSecrets>().ResolveAsync(store.Id) != message.TenantId)
            throw new InvalidOperationException("Managed task store ownership changed.");
        var database = new MongoClient(mongo).GetDatabase(mongo.DatabaseName);
        var plugins = (PluginManager.ReferencedPlugins ?? []).Where(x => x.Installed).OrderBy(x => x.SystemName, StringComparer.Ordinal).ToArray();
        var expected=(config["Extensions:InstalledPlugins"] ?? "").Split(',',StringSplitOptions.RemoveEmptyEntries|StringSplitOptions.TrimEntries);
        if (expected.Length == 0 || expected.Except(plugins.Select(x=>x.SystemName),StringComparer.Ordinal).Any() ||
            !plugins.Any(x => x.SystemName == "Tax.FixedRate") || !plugins.Any(x => x.SystemName == "Payments.CashOnDelivery"))
            throw new InvalidOperationException("The committed required tenant plugins were not packaged or loaded.");
        if (task != "tenant-plugins")
        {
            var installed=database.GetCollection<BsonDocument>("InstalledPlugin");
            foreach(var plugin in plugins)
                if(await installed.CountDocumentsAsync(Builders<BsonDocument>.Filter.Eq("SystemName",plugin.SystemName) & Builders<BsonDocument>.Filter.Eq("Version",plugin.Version))==0)
                    throw new InvalidOperationException("Install every owned tenant plugin before migrations or settings.");
        }
        if (task == "tenant-plugins")
        {
            var installed = database.GetCollection<BsonDocument>("InstalledPlugin");
            foreach (var plugin in plugins)
            {
                var filter = Builders<BsonDocument>.Filter.Eq("SystemName", plugin.SystemName) & Builders<BsonDocument>.Filter.Eq("Version", plugin.Version);
                if (await installed.CountDocumentsAsync(filter) != 0) continue;
                await plugin.Instance(scope.ServiceProvider).Install();
                await PluginExtensions.MarkPluginAsInstalled(plugin.SystemName);
                await installed.InsertOneAsync(new BsonDocument { ["SystemName"] = plugin.SystemName, ["Version"] = plugin.Version });
            }
        }
        else if (task == "tenant-migrations")
        {
            var migrations = scope.ServiceProvider.GetRequiredService<IMigrationProcess>();
            var recorded=scope.ServiceProvider.GetRequiredService<IRepository<Grand.Domain.MigrationDb>>().Table
                .Select(x=>x.Identity).ToHashSet();
            // MigrationManager includes installed plugin migrations and preserves version/priority ordering.
            foreach (var migration in new MigrationManager().GetCurrentMigrations())
            {
                if (recorded.Contains(migration.Identity)) continue;
                if (!migrations.RunProcess(migration).Success)
                    throw new InvalidOperationException("A required tenant migration did not complete successfully.");
                recorded.Add(migration.Identity);
            }
        }
        else if(task=="tenant-domain")
        {
            var selected=await ManagedTenantDomain.VerifyAsync(config,message)??throw new InvalidOperationException("A verified domain selection is required.");
            await ManagedTenantDomain.UpdateAsync(store,scope.ServiceProvider.GetRequiredService<Grand.Business.Core.Interfaces.Common.Stores.IStoreService>(),selected);
        }
        else
        {
            var customer = await scope.ServiceProvider.GetRequiredService<ICustomerService>().GetCustomerByEmail(message.OwnerEmail);
            if (customer == null) throw new InvalidOperationException("The original tenant owner is missing.");
            var fields = new[] { (SystemCustomerFieldNames.FirstName, message.FirstName), (SystemCustomerFieldNames.LastName, message.Lastname) };
            foreach (var (key, value) in fields)
            {
                var existing = customer.UserFields.FirstOrDefault(x => x.Key == key);
                if (existing == null) customer.UserFields.Add(new UserField { Key = key, Value = value, StoreId = store.Id });
                else existing.Value = value;
            }
            await scope.ServiceProvider.GetRequiredService<IRepository<Grand.Domain.Customers.Customer>>().UpdateAsync(customer);
            await StoreBusinessDefaults.ApplyAsync(scope, message, store, customer, config["Provisioning:StoreUrl"]!);
            var secrets=scope.ServiceProvider.GetRequiredService<ITenantSecrets>();
            var api=scope.ServiceProvider.GetRequiredService<IUserApiService>();
            var encryption=scope.ServiceProvider.GetRequiredService<IEncryptionService>();
            var existingApi=await api.GetUserByEmail(customer.Email);
            if(existingApi==null)
            {
                var password=await secrets.GetOrCreateAsync(message.TenantId,TenantSecretNames.BackendUserPassword,()=>Convert.ToBase64String(RandomNumberGenerator.GetBytes(32)));
                var key=Convert.ToHexString(RandomNumberGenerator.GetBytes(12));
                await api.InsertUserApi(new UserApi {CreatedOnUtc=DateTime.UtcNow,CreatedBy=customer.Id,Email=customer.Email,
                    Password=encryption.EncryptText(password,key),PrivateKey=key,Token=Guid.NewGuid().ToString()});
            }
            else
                await secrets.GetOrCreateAsync(message.TenantId,TenantSecretNames.BackendUserPassword,()=>encryption.DecryptText(existingApi.Password,existingApi.PrivateKey));
            var emailService=scope.ServiceProvider.GetRequiredService<IEmailAccountService>();
            var mailSettings=scope.ServiceProvider.GetRequiredService<ISettingService>().LoadSetting<EmailAccountSettings>();
            var smtp=config.GetSection("Provisioning:StoreEmail");
            if(smtp.Exists())
            {
                if(!int.TryParse(smtp["port"],out var port) || port is <1 or >65535 || string.IsNullOrWhiteSpace(smtp["host"]) ||
                    !System.Net.Mail.MailAddress.TryCreate(smtp["from"],out _) || string.IsNullOrWhiteSpace(smtp["user"]) || string.IsNullOrEmpty(smtp["password"]) ||
                    (smtp["ssl"]!="true" && smtp["starttls"]!="true"))
                    throw new InvalidOperationException("Managed store email requires explicit authenticated TLS SMTP settings.");
                await secrets.SetAsync(message.TenantId,TenantSecretNames.StoreSmtpPassword,smtp["password"]!);
                var accounts=await emailService.GetAllEmailAccounts();
                var account=accounts.FirstOrDefault(x=>x.Host==smtp["host"] && x.Username==smtp["user"] && x.Email==smtp["from"]);
                var isNew=account==null;account ??= new EmailAccount();
                account.Email=smtp["from"];account.DisplayName=message.CompanyName;account.Host=smtp["host"];account.Port=port;
                account.Username=smtp["user"];account.Password="platform-secret:"+TenantSecretNames.StoreSmtpPassword;
                account.UseServerCertificateValidation=true;account.SecureSocketOptionsId=(int)(smtp["ssl"]=="true"?SecureSocketOptions.SslOnConnect:SecureSocketOptions.StartTls);
                if(isNew)await emailService.InsertEmailAccount(account);else await emailService.UpdateEmailAccount(account);
                mailSettings.DefaultEmailAccountId=account.Id;
                await scope.ServiceProvider.GetRequiredService<ISettingService>().SaveSetting(mailSettings);
            }
            var templates=scope.ServiceProvider.GetRequiredService<IMessageTemplateService>();
            foreach(var template in await templates.GetAllMessageTemplates(store.Id))
            {
                template.BccEmailAddresses=customer.Email;
                if(!string.IsNullOrEmpty(mailSettings.DefaultEmailAccountId))template.EmailAccountId=mailSettings.DefaultEmailAccountId;
                await templates.UpdateMessageTemplate(template);
            }
            verifiedSettings=VerifyOriginalSettings(scope);
            var provider=scope.ServiceProvider.GetServices<ITaxProvider>().Single(x=>x.SystemName=="Tax.FixedRate");
            var categories=scope.ServiceProvider.GetRequiredService<IRepository<TaxCategory>>();
            foreach(var (name,rate) in new[]{("Temel Gıda Ürünleri",1d),("Mobilya, Tekstil ve Temizlik Ürünleri",10d),("Lüks Tüketim Ürünleri",20d)})
            {
                var category=categories.Table.Single(x=>x.Name==name);
                if((await provider.GetTaxRate(new TaxRequest{TaxCategoryId=category.Id})).TaxRate!=rate)
                    throw new InvalidOperationException("The tenant tax provider returned an incorrect category rate.");
            }
            var currencies = scope.ServiceProvider.GetRequiredService<IRepository<Currency>>();
            var address = scope.ServiceProvider.GetRequiredService<IRepository<AddressAttribute>>();
            var settings = scope.ServiceProvider.GetRequiredService<ISettingService>();
            if (!currencies.Table.Any(x => x.Id == store.DefaultCurrencyId && x.CurrencyCode == "TRY") ||
                settings.LoadSetting<CurrencySettings>().PrimaryStoreCurrencyId!=store.DefaultCurrencyId ||
                settings.LoadSetting<CurrencySettings>().PrimaryExchangeRateCurrencyId!=store.DefaultCurrencyId ||
                settings.LoadSetting<LanguageSettings>().DefaultAdminLanguageId!=store.DefaultLanguageId ||
                string.IsNullOrEmpty(store.DefaultCountryId) || string.IsNullOrEmpty(store.DefaultLanguageId) ||
                AddressFields.Any(name => !address.Table.Any(x => x.Name == name && x.IsRequired)) ||
                settings.LoadSetting<TaxProviderSettings>().ActiveTaxProviderSystemName != "Tax.FixedRate")
                throw new InvalidOperationException("Managed tenant business defaults did not pass their readiness check.");
        }
        var domainSelection=task=="tenant-domain"?await ManagedTenantDomain.VerifyAsync(config,message):null;
        var target = Path.Combine(Path.GetDirectoryName(output)!, message.StoreSubDomain + "." + task + (domainSelection==null?"":"."+domainSelection.Id.ToString("N")) + ".json");
        var result = new { version = 1, profile = "Portable", task, tenantId = message.TenantId, slug = message.StoreSubDomain, storeId = store.Id, verifiedBusinessSettings=verifiedSettings,domainRequestId=domainSelection?.Id.ToString("N"),storeUrl=domainSelection==null?null:"https://"+domainSelection.StoreHost };
        var temporary = target + "." + Guid.NewGuid().ToString("N") + ".tmp";
        try
        {
            var options = new FileStreamOptions { Mode = FileMode.CreateNew, Access = FileAccess.Write, Share = FileShare.None };
            if (!OperatingSystem.IsWindows()) options.UnixCreateMode = UnixFileMode.UserRead | UnixFileMode.UserWrite;
            await using (var stream = new FileStream(temporary, options)) await JsonSerializer.SerializeAsync(stream, result);
            File.Move(temporary, target, true);
        }
        finally { if (File.Exists(temporary)) File.Delete(temporary); }
        Console.WriteLine("Managed tenant task completed: " + task);
    }
}
