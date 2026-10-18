using Platform.Security;
using Azure;
using Azure.Identity;
using Azure.ResourceManager;
using Azure.ResourceManager.AppService;
using Azure.ResourceManager.AppService.Models;
using Azure.Security.KeyVault.Secrets;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using CloudFlare.Client.Enumerators;
using Grand.Business.Core.Dto;
using Grand.Business.Core.Enums.Messages;
using Grand.Business.Core.Interfaces.Authentication;
using Grand.Business.Core.Interfaces.Catalog.Tax;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Common.Addresses;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Interfaces.Common.Stores;
using Grand.Infrastructure.Plugins;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Core.Interfaces.Checkout.Payments;
using Grand.Business.Core.Interfaces.Checkout.Shipping;
using Grand.Business.Core.Interfaces.Cms;
using Grand.Domain.Payments;
using Grand.Business.Core.Interfaces.ExportImport;
using Grand.Business.Core.Interfaces.Messages;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Business.Core.Interfaces.System.Installation;
using Grand.Business.Core.Utilities.Authentication;
using Grand.Business.System.Services.Installation;
using Grand.Data;
using Grand.Domain.Catalog;
using Grand.Domain.Common;
using Grand.Domain.Customers;
using Grand.Domain.Directory;
using Grand.Domain.Localization;
using Grand.Domain.Media;
using Grand.Domain.Messages;
using Grand.Domain.Orders;
using Grand.Domain.PushNotifications;
using Grand.Domain.Shipping;
using Grand.Domain.Stores;
using Grand.Domain.Tax;
using Grand.Infrastructure;
using Grand.Infrastructure.Extensions;
using Grand.Installer.Cli.Extensions;
using Grand.Installer.Cli.Models;
using Grand.Installer.Cli.Models.CaludeAi;
using Grand.Installer.Cli.Models.Cloudflare;
using Grand.Installer.Cli.Services;
using Grand.Installer.Cli.Services.CaludeAi;
using Grand.Installer.Cli.Services.CloudFlare;
using Grand.Installer.Cli.Services.RemoteUserManagement;
using Grand.SharedKernel.Extensions;
using Grand.Web.Common.Extensions;
using Grand.Web.ExternalSettings.Extensions;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;
using System.Diagnostics;
using System.Reflection;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using Grand.Web.Common.Extensions;
using MongoDB.Driver.Linq;

if (args.Length == 3 && args[0] == "--verify-plugins")
{
    ManagedPluginProbe.Verify(args[1], args[2]);
    return;
}

var loadedAssemblies = AppDomain.CurrentDomain.GetAssemblies().ToList();
var loadedPath = loadedAssemblies.Where(a => !a.IsDynamic).Select(x => x.Location);

var referencedAssemblyPath = Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll");
var deltaLoad = referencedAssemblyPath.Where(r => !loadedPath.Contains(r, StringComparer.InvariantCultureIgnoreCase));

foreach (var referencePath in deltaLoad)
{
    if (referencePath.StartsWith(AppDomain.CurrentDomain.BaseDirectory + "Grand.Business")
        || referencePath.StartsWith(AppDomain.CurrentDomain.BaseDirectory + "Grand.Api"))
    {
        loadedAssemblies.Add(AppDomain.CurrentDomain.Load(AssemblyName.GetAssemblyName(referencePath.ToString())));
    }
}

var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddEnvironmentVariables();

if (builder.Environment.IsDevelopment() && !builder.Configuration.GetValue<bool>("LocalDemo:Enabled"))
{
    CommonPath.WebHostEnvironment =
        Path.Combine(Directory.GetParent(builder.Environment.ContentRootPath).Parent.Parent.FullName, "wwwroot");
    CommonPath.BaseDirectory = Directory.GetParent(builder.Environment.ContentRootPath).Parent.Parent.FullName;
    builder.Environment.ContentRootPath = CommonPath.BaseDirectory;
    builder.Environment.WebRootPath = CommonPath.WebHostEnvironment;
}
else
{
    CommonPath.WebHostEnvironment =
        Path.Combine(builder.Environment.ContentRootPath, "wwwroot");
    CommonPath.BaseDirectory = builder.Environment.ContentRootPath;
    builder.Environment.ContentRootPath = CommonPath.BaseDirectory;
    builder.Environment.WebRootPath = CommonPath.WebHostEnvironment;
}

var managedPortable = builder.Configuration.GetValue<bool>("Provisioning:ManagedInstaller") &&
    builder.Configuration["Provisioning:ManagedInstallerProfile"] == "Portable";
if (managedPortable && builder.Configuration.GetValue<bool>("LocalDemo:Enabled"))
    throw new InvalidOperationException("A portable managed installer cannot use LocalDemo.");
var tenantStatusMessage = new TenantStatusMessage();
builder.Configuration.GetSection("TenantMessage").Bind(tenantStatusMessage);
builder.Services.AddScoped<InstallerService>();
builder.AddServiceDefaults(tenantStatusMessage.MongoConnectionString);
if (managedPortable)
{
    await Grand.Installer.Cli.Services.ManagedTenantDomain.VerifyAsync(builder.Configuration,tenantStatusMessage);

}

builder.Host.UseDefaultServiceProvider((_, options) =>
{
    options.ValidateScopes = false;
    options.ValidateOnBuild = false;
});

// HTTP istemci yapılandırması
builder.Services.AddHttpClient();
                    
// Servis entegrasyonları
builder.Services.AddTransient<IWelcomePageService, WelcomePageService>();
builder.Services.AddTransient<IClaudeAIService, ClaudeAIService>();
builder.Services.AddTransient<IPageTypeDetector, PageTypeDetector>();


// Scheduled tasks use this release's code while retaining the tenant's writable content root.
if (managedPortable && builder.Configuration.GetValue<bool>("Provisioning:RunScheduledTasks"))
{
    var plugins = Path.Combine(AppContext.BaseDirectory, "Plugins");
    if (!Directory.Exists(plugins)) throw new DirectoryNotFoundException("The published Installer plugin directory is required.");
    CommonPath.PluginSourceDirectory = plugins;
    builder.Configuration["Extensions:PluginShadowCopy"] = "false";
}

//add services
StartupBase.ConfigureServices(builder.Services, builder.Configuration);
builder.Services.AddRedisCache(builder.Configuration);

// var sa = new Grand.Business.Common.Startup.StartupApplication();

// sa.ConfigureServices(builder.Services, builder.Configuration);

builder.ConfigureApplicationSettings();

if (!builder.Configuration.GetValue<bool>("LocalDemo:Enabled") && !managedPortable)
    ((ConfigurationManager)builder.Configuration).AddJsonFile(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "appsettings.multitenant.json"));

if (!managedPortable)
{
var conf = new KeycloakSettings();
builder.Configuration.GetSection("KeyCloakServiceClient").Bind(conf);
conf.ClientSecret = builder.Services.BuildServiceProvider().GetRequiredService<ISecretStore>()
    .GetAsync("system", $"ClientSecret-{conf.ClientId}").GetAwaiter().GetResult();
builder.Services.AddSingleton(conf);
builder.Services.Configure<KeycloakSettings>(builder.Configuration.GetSection("KeyCloakServiceClient"));

builder.Services.AddScoped<IKeycloakService, KeycloakService>();
builder.Services.AddScoped<IKeycloakUserService, KeycloakUserService>();

 }

builder.Services.AddScoped<IInstallationLocalizedService, InstallationLocalizedService>();
builder.Services.AddScoped<IInstallationService, InstallationService>();


var serviceProvider = builder.Services.BuildServiceProvider();
using (var scope = serviceProvider.CreateScope())
{
    
    // var welcomePageService = scope.ServiceProvider.GetRequiredService<IWelcomePageService>();
    //
    // var pageService = scope.ServiceProvider.GetRequiredService<IMessageTemplateService>();
    // var messageTokenProvider = scope.ServiceProvider.GetRequiredService<IMessageTokenProvider>();
    // var pageStore = (scope.ServiceProvider.GetService<IStoreService>()).GetAll().First();
    // var pages = await pageService.GetAllMessageTemplates(pageStore.Id);
    // foreach (var page in pages)
    // {
    //     var translatedPage = await welcomePageService.GenerateTurkishWelcomePageAsync(new WelcomePage() {
    //         SystemName = page.Name,
    //         Title = page.Subject,
    //         Content = page.Body,
    //         LiquidTokens = string.Join(",",messageTokenProvider.GetListOfAllowedTokens())
    //     });
    //     if (!Directory.Exists(Path.Combine(CommonPath.BaseDirectory, "App_Data/MessageTemplates")))
    //     {
    //         Directory.CreateDirectory(Path.Combine(CommonPath.BaseDirectory, "App_Data/MessageTemplates"));
    //     }
    //         
    //     File.WriteAllText(
    //         Path.Combine(CommonPath.BaseDirectory,"App_Data/MessageTemplates",page.Name+".json"), 
    // JsonSerializer.Serialize(translatedPage));
    //
    //     await Task.Delay(TimeSpan.FromSeconds(60));
    //
    //     // page.Published = false;
    //     // await pageService.UpdatePage(page);
    // }
    //
    // return; 
    
    if (managedPortable && builder.Configuration.GetValue<bool>("Provisioning:RunScheduledTasks"))
    {
        // IScheduleTask has no cancellation API. Exit the isolated child on lease loss, without
        // releasing the lease while a plugin callback could still execute in another thread.
        try { await ManagedScheduledTasks.RunAsync(scope, builder.Services, builder.Configuration, tenantStatusMessage); }
        catch { Console.Error.WriteLine("Tenant schedule batch stopped safely."); Environment.Exit(75); }
        return;
    }

    var managedTask = builder.Configuration["Provisioning:ManagedInstallerTask"];
    if (managedPortable && !string.IsNullOrEmpty(managedTask))
    {
        await ManagedTenantTasks.RunAsync(managedTask, scope, builder.Configuration, tenantStatusMessage);
        return;
    }

    var installerService = scope.ServiceProvider.GetRequiredService<InstallerService>();
    var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();
    Stopwatch stopwatch = new Stopwatch();

// Zamanlayıcıyı başlat
    stopwatch.Start();
    if (managedPortable && (!Guid.TryParseExact(tenantStatusMessage.TenantId, "N", out var installationTenant) || installationTenant == Guid.Empty))
        throw new InvalidOperationException("The base installer requires a canonical owned tenant.");
    // Store.Id is created during installation. Its earlier cache work uses the owned tenant key.
    using (var bootstrapContext = managedPortable ? new InstallerTenantContext(
        scope.ServiceProvider.GetRequiredService<Grand.Infrastructure.MultiTenant.ITenantIdentityAccessor>(), tenantStatusMessage.TenantId!) : null)
    {
    await installerService.Install(new InstallModel {
        UserFields = null,
        SelectedLanguage = "tr-TR",
        AdminEmail = tenantStatusMessage.OwnerEmail,
        AdminPassword = tenantStatusMessage.Password,
        ConfirmPassword = tenantStatusMessage.Password,
        DatabaseConnectionString = tenantStatusMessage.MongoConnectionString,
        DataProvider = DbProvider.MongoDB,
        ConnectionInfo = true,
        MongoDBServerName = null,
        MongoDBDatabaseName = null,
        MongoDBUsername = null,
        MongoDBPassword = null,
        DisableSampleDataOption = false,
        InstallSampleData = false,
        Installed = false,
        Collation = "tr",
        AvailableLanguages = null,
        AvailableCollation = null,
        AvailableProviders = null,
        CompanyName = tenantStatusMessage.CompanyName,
        CompanyAddress = tenantStatusMessage.CompanyAddress,
        CompanyPhoneNumber = tenantStatusMessage.CompanyPhoneNumber,
        CompanyEmail = tenantStatusMessage.CompanyEmail,
        StoreHostScheme = builder.Configuration.GetValue<bool>("LocalDemo:Enabled") ? "http" : "https",
        StoreHost = managedPortable ? new Uri(builder.Configuration["Provisioning:StoreUrl"]!).Authority
            : $"{tenantStatusMessage.StoreSubDomain}.{builder.Configuration["Web:Host"]}"
    });

    }

    stopwatch.Stop();

// Sonuçları görüntüle
    logger.LogInformation($"Migration İşlem süresi: {stopwatch.Elapsed.TotalMinutes} milisaniye");
    var storeService = scope.ServiceProvider.GetService<IStoreService>();
    var store = (managedPortable
        ? scope.ServiceProvider.GetRequiredService<IRepository<Store>>().Table.SingleOrDefault()
        : (await storeService.GetAllStores()).FirstOrDefault())
        ?? throw new InvalidOperationException("The installed tenant store is missing.");
    using var tenantContext = new InstallerTenantContext(
        scope.ServiceProvider.GetRequiredService<Grand.Infrastructure.MultiTenant.ITenantIdentityAccessor>(), store.Id);
    if (managedPortable) ManagedBaseInstallation.RequireComplete(scope, tenantStatusMessage.OwnerEmail!);
    var tenantSecrets = scope.ServiceProvider.GetRequiredService<ITenantSecrets>();
    await tenantSecrets.ProvisionAsync(tenantStatusMessage.TenantId ?? tenantStatusMessage.StoreSubDomain!, tenantStatusMessage.StoreSubDomain!);
    tenantStatusMessage.TenantId = await tenantSecrets.ResolveAsync(tenantStatusMessage.StoreSubDomain!);
    await tenantSecrets.BindAliasAsync(tenantStatusMessage.StoreSubDomain!, store.Id);
    await tenantSecrets.SetAsync(tenantStatusMessage.StoreSubDomain!, TenantSecretNames.DatabaseConnection, tenantStatusMessage.MongoConnectionString!);

    store.Name = tenantStatusMessage.StoreName;
    // A previous attempt may have saved the store before a cache/event failure.
    foreach (var field in store.UserFields.Where(field => field.Key == "EncryptionKey" && field.StoreId == store.Id).ToArray())
        store.UserFields.Remove(field);
    store.UserFields.Add(new UserField {
        Key = "EncryptionKey",
        Value = tenantStatusMessage.StoreSubDomain,
        StoreId = store.Id
    });
    await storeService.UpdateStore(store);
    if (managedPortable)
    {
        if (!Guid.TryParseExact(tenantStatusMessage.TenantId,"N",out var businessId) || businessId==Guid.Empty ||
            builder.Configuration["PlatformSecurity:Provider"] is not ("AesGcm" or "Azure"))
            throw new InvalidOperationException("Portable installation requires canonical tenant ownership and a configured encryption provider.");
        var outputPath=builder.Configuration["Provisioning:TenantOutput"];
        if (string.IsNullOrWhiteSpace(outputPath) || !Path.IsPathFullyQualified(outputPath))
            throw new InvalidOperationException("Configure an absolute private installer metadata output.");
        var temporaryPath=outputPath+"."+Guid.NewGuid().ToString("N")+".tmp";
        try
        {
            var fileOptions=new FileStreamOptions {Mode=FileMode.CreateNew,Access=FileAccess.Write,Share=FileShare.None};
            if (!System.OperatingSystem.IsWindows()) fileOptions.UnixCreateMode=UnixFileMode.UserRead|UnixFileMode.UserWrite;
            await using(var stream=new FileStream(temporaryPath,fileOptions))
                await JsonSerializer.SerializeAsync(stream,new {profile="Portable",tenantId=tenantStatusMessage.TenantId,slug=tenantStatusMessage.StoreSubDomain,storeId=store.Id,baseInstallationVerified=true});
            File.Move(temporaryPath,outputPath,false);
        }
        finally { if(File.Exists(temporaryPath))File.Delete(temporaryPath); }
        logger.LogInformation("Managed tenant {TenantId} database installation completed.",tenantStatusMessage.TenantId);
        return;
    }
    if (builder.Configuration.GetValue<bool>("LocalDemo:Enabled"))
    {
        var products = scope.ServiceProvider.GetRequiredService<IRepository<Product>>();
        var urls = scope.ServiceProvider.GetRequiredService<IRepository<Grand.Domain.Seo.EntityUrl>>();
        var layouts = scope.ServiceProvider.GetRequiredService<IRepository<ProductLayout>>();
        var isCoffee = tenantStatusMessage.StoreSubDomain == "demo-a";
        var names = isCoffee ? new[] { "Demo Espresso", "Demo Filter Coffee", "Demo Mug" }
            : new[] { "Demo Architecture Book", "Demo Notebook", "Demo Pencil Set" };
        for (var i = 0; i < names.Length; i++)
        {
            var sku = tenantStatusMessage.StoreSubDomain + "-" + i;
            var existing = products.Table.FirstOrDefault(x => x.Sku == sku);
            if (existing != null)
            {
                if (existing.SeName != sku) { existing.SeName = sku; await products.UpdateAsync(existing); }
                continue;
            }
            var product = new Product {
                Name = names[i], Sku = sku, SeName = sku, ProductTypeId = ProductType.SimpleProduct,
                VisibleIndividually = true, Published = true, ShowOnHomePage = true,
                ProductLayoutId = layouts.Table.First().Id,
                Price = 10 + i * 5, StockQuantity = 100, StockAvailability = true,
                ManageInventoryMethodId = ManageInventoryMethod.ManageStock,
                OrderMinimumQuantity = 1, OrderMaximumQuantity = 10,
                IsShipEnabled = true, IsFreeShipping = true,
                ShortDescription = "Synthetic local demo product.",
                FullDescription = "<p>This sample belongs only to " + tenantStatusMessage.StoreSubDomain + ".</p>"
            };
            await products.InsertAsync(product);
            await urls.InsertAsync(new Grand.Domain.Seo.EntityUrl {
                EntityId = product.Id, EntityName = "Product", Slug = sku, IsActive = true,
                LanguageId = "", Controller = "Product", Action = "ProductDetails"
            });
        }
        var encryption = scope.ServiceProvider.GetRequiredService<ITenantEncryptionService>();
        var demo = new {
            tenantId = tenantStatusMessage.TenantId,
            slug = tenantStatusMessage.StoreSubDomain, storeId = store.Id,
            connectionString = tenantStatusMessage.MongoConnectionString,
            encryptedStoreId = await encryption.EncryptAsync(store.Id, tenantStatusMessage.StoreSubDomain),
            encryptedConnection = await encryption.EncryptAsync(tenantStatusMessage.MongoConnectionString, tenantStatusMessage.StoreSubDomain)
        };
        var outputPath = builder.Configuration["LocalDemo:TenantOutput"]!;
        var temporaryPath = outputPath + ".tmp";
        var fileOptions = new FileStreamOptions {Mode=FileMode.Create,Access=FileAccess.Write,Share=FileShare.None};
        if (!System.OperatingSystem.IsWindows()) fileOptions.UnixCreateMode=UnixFileMode.UserRead|UnixFileMode.UserWrite;
        await using (var stream=new FileStream(temporaryPath,fileOptions))
            await JsonSerializer.SerializeAsync(stream,demo);
        File.Move(temporaryPath,outputPath,true);
        logger.LogInformation("Local tenant {Slug} seeded successfully.", tenantStatusMessage.StoreSubDomain);
        return;
    }

    var customerService = scope.ServiceProvider.GetRequiredService<ICustomerService>();
    var customerRepository = scope.ServiceProvider.GetRequiredService<IRepository<Customer>>();
    var customer = await customerService.GetCustomerByEmail(tenantStatusMessage.OwnerEmail);

    await customerRepository.UpdateToSet(customer.Id, x => x.UserFields,
        x => x.Key == SystemCustomerFieldNames.FirstName, new UserField {
            Key = SystemCustomerFieldNames.FirstName,
            Value = tenantStatusMessage.FirstName,
            StoreId = store.Id
        });

    await customerRepository.UpdateToSet(customer.Id, x => x.UserFields,
        x => x.Key == SystemCustomerFieldNames.LastName, new UserField {
            Key = SystemCustomerFieldNames.LastName,
            Value = tenantStatusMessage.Lastname,
            StoreId = store.Id
        });

    var externalAuthanticationService =
        scope.ServiceProvider.GetService<IExternalAuthenticationService>();

    var keycloakService = scope.ServiceProvider.GetService<IKeycloakUserService>();
    var superAdminKeycloakUser = await keycloakService.GetUserAsync("1ee9b00f-d682-4ca1-a559-b82a5ddac511");

    var superAdminUser =
        await installerService.InsertSuperUser(superAdminKeycloakUser?.Email,
            PasswordGenerator.GenerateRandomPassword());

    var userId = await keycloakService.CreateUserAsync(
        tenantStatusMessage.OwnerEmail,
        tenantStatusMessage.OwnerEmail,
        tenantStatusMessage.FirstName,
        tenantStatusMessage.Lastname,
        tenantStatusMessage.Password,
        store.Id
    );

    var subscriber = scope.ServiceProvider.GetRequiredService<ISubscriber>();
    if (!string.IsNullOrEmpty(userId))
    {
        var group = await keycloakService.CreateGroupIfNotExistsAsync(
            tenantStatusMessage.StoreSubDomain,
            store.Id,
            store.Name,
            tenantStatusMessage.MongoConnectionString);

        await keycloakService.AssignUserToGroupAsync(tenantStatusMessage.OwnerEmail,
            group.Id);

        await keycloakService.AssignUserToGroupAsync(superAdminKeycloakUser.Email,
            group.Id);

        await keycloakService.AssignRoleToUserAsync(userId, tenantStatusMessage.Role);
        await keycloakService.AssignRoleToUserAsync(userId, superAdminKeycloakUser.Email);

        var storeFrontendClient = await keycloakService.CreateClientWithMappersAsync(tenantStatusMessage.StoreSubDomain,
            tenantStatusMessage.MongoConnectionString, store.Id, group.Id);

        await subscriber.PublishAsync(RedisChannel.Literal("FRONTEND_CREDENTIAL"), JsonSerializer.Serialize(
            new ResponseWithCredentialsModel() {
                IsSuccess = true,
                Message = tenantStatusMessage,
                FrontEndCredentialInfo = new FrontEndCredentialInfo() {
                    ClientId = storeFrontendClient.ClientId,
                    ClientSecret = storeFrontendClient.ClientSecret,
                }
            }));
        await externalAuthanticationService.AssociateCustomer(customer, new ExternalAuthParam {
            ProviderSystemName = "ExternalAuth.Keycloak",
            AccessToken = "",
            Email = customer.Email,
            Identifier = userId,
            Name = $"{tenantStatusMessage.FirstName} {tenantStatusMessage.Lastname}",
            Claims = new List<Claim>()
        });

        await externalAuthanticationService.AssociateCustomer(superAdminUser, new ExternalAuthParam {
            ProviderSystemName = "ExternalAuth.Keycloak",
            AccessToken = "",
            Email = superAdminKeycloakUser.Email,
            Identifier = superAdminKeycloakUser.Id,
            Name = $"Osman Kabasakal",
            Claims = new List<Claim>()
        });
    }

    var cloudFlareClient = new CustomClodFlareApiConnection(builder.Configuration["CloudFlareApiKey"]!);
    var zoneList = await cloudFlareClient.GetAsync<List<DnsZoneModel>>("zones", default);
    if (zoneList == null || !zoneList.Success || zoneList.Result.Count > 1)
    {
        logger.LogWarning(
            "Domain kaydı gerçekleştirilemedi:\n zone list isnull:{0} \n zoneList.Success:{1} \n zoneList.Result.Count:{2}",
            zoneList == null, zoneList?.Success, zoneList?.Result?.Count);
        return;
    }

    var storeFullUrl = $"{tenantStatusMessage.StoreSubDomain}.{builder.Configuration["Web:Host"]}";

    var webHostZone = zoneList.Result.First();

    var zoneRecords =
        await cloudFlareClient.GetAsync<List<DnsRecordModel>>($"zones/{webHostZone.Id}/dns_records", default);

    var _armClient = new ArmClient(new DefaultAzureCredential());
    var sub = _armClient.GetDefaultSubscription();
    var rsGroup = (await sub.GetResourceGroupAsync("local-business")).Value;
    var webSite = rsGroup.GetWebSite("dukkan").Value;

    if (!zoneRecords.Result.Any(x => x.Name == storeFullUrl && x.Type == "CNAME"))
    {
        await cloudFlareClient.PostAsync<DnsRecordModel>($"zones/{webHostZone.Id}/dns_records", new DnsRecordModel {
                Comment = String.Empty,
                Content = webSite.Data.DefaultHostName,
                Name = tenantStatusMessage.StoreSubDomain,
                Proxied = false,
                Ttl = 3600,
                Type = "CNAME"
            },
            default);

        await Task.Delay(TimeSpan.FromSeconds(30));
    }

    if (!zoneRecords.Result.Any(x => x.Name == storeFullUrl && x.Type == "TXT"))
    {
        await cloudFlareClient.PostAsync<DnsRecordModel>($"zones/{webHostZone.Id}/dns_records", new DnsRecordModel {
                Comment = String.Empty,
                Name = $"asuid.{tenantStatusMessage.StoreSubDomain}",
                Content = $"\"{webSite.Data.CustomDomainVerificationId}\"",
                Ttl = 3600,
                Type = "TXT"
            },
            default);
        await Task.Delay(TimeSpan.FromSeconds(30));
    }


    if (!webSite.Data.EnabledHostNames.Contains(
            $"{storeFullUrl}"))
    {
        var hostnameBindingResource = await webSite.GetSiteHostNameBindings().CreateOrUpdateAsync(WaitUntil.Completed,
            $"{storeFullUrl}",
            new HostNameBindingData {
                SiteName = webSite.Data.Name,
                CustomHostNameDnsRecordType = CustomHostNameDnsRecordType.CName,
                HostNameType = AppServiceHostNameType.Verified,
                SslState = HostNameBindingSslState.Disabled,
                // ThumbprintString = mangedSsl.Value.Data.ThumbprintString
            });
        await Task.Delay(TimeSpan.FromSeconds(30));


        var mangedSsl = await rsGroup.GetAppCertificates().CreateOrUpdateAsync(WaitUntil.Completed,
            $"{storeFullUrl}-{webSite.Data.Name}",
            new AppCertificateData(rsGroup.Data.Location) {
                ServerFarmId = webSite.Data.AppServicePlanId,
                Password = PasswordGenerator.GenerateRandomPassword(),
                // DomainValidationMethod = "CNAME",
                HostNames = { $"{storeFullUrl}" },
                CanonicalName = $"{storeFullUrl}"
            });
        await Task.Delay(TimeSpan.FromSeconds(30));


        hostnameBindingResource.Value.Data.ThumbprintString = mangedSsl.Value.Data.ThumbprintString;
        hostnameBindingResource.Value.Data.SslState = HostNameBindingSslState.SniEnabled;

        await webSite.GetSiteHostNameBindings().CreateOrUpdateAsync(WaitUntil.Completed,
            $"{storeFullUrl}",
            hostnameBindingResource.Value.Data);
        await Task.Delay(TimeSpan.FromSeconds(30));
    }

    var apiCustomerService = scope.ServiceProvider.GetRequiredService<IUserApiService>();
    var encryptionService = scope.ServiceProvider.GetService<IEncryptionService>();
    var key = CommonHelper.GenerateRandomDigitCode(24);
    var backendApiPassword = PasswordGenerator.GenerateRandomPassword();
    var passwordHash = encryptionService.EncryptText(backendApiPassword, key);
    await apiCustomerService.InsertUserApi(new UserApi {
        CreatedOnUtc = DateTime.UtcNow,
        CreatedBy = customer.Id,
        Email = customer.Email,
        Password = passwordHash,
        PrivateKey = key,
        Token = Guid.NewGuid().ToString()
    });
    
    var emailAccount = scope.ServiceProvider.GetRequiredService<IEmailAccountService>();
    var emailAccounts= await emailAccount.GetAllEmailAccounts();
    
    var mailSettings = scope.ServiceProvider.GetRequiredService<EmailAccountSettings>();
    var emailAccountSettings = new EmailAccount {
        Email = "donotreply@commerce.test",
        DisplayName = tenantStatusMessage.CompanyName,
        Host = "smtp-relay.gmail.com",
        Port = 587,
        Username = "maintainer@example.invalid",
        Password = builder.Configuration["Email:Password"],
        UseServerCertificateValidation = true,
        SecureSocketOptionsId = (int)SecureSocketOptions.StartTls,
    };

    await emailAccount.InsertEmailAccount(emailAccountSettings);
    var mailAccounts = await emailAccount.GetAllEmailAccounts();
    var lastEditedMailAccount = mailAccounts.FirstOrDefault(x => x.Username == emailAccountSettings.Username);
    mailSettings.DefaultEmailAccountId = lastEditedMailAccount?.Id;

    var settingservice = scope.ServiceProvider.GetRequiredService<ISettingService>();
    await settingservice.SaveSetting(mailSettings);

    
    if (emailAccounts != null && emailAccounts.Count > 0)
    {
        foreach (var email in emailAccounts)
        {
            if(email.Id != lastEditedMailAccount?.Id)
                await emailAccount.DeleteEmailAccount(email);
        }
    }
    
    

    await StoreBusinessDefaults.ApplyAsync(scope, tenantStatusMessage, store, customer, $"https://{tenantStatusMessage.StoreSubDomain}.{builder.Configuration["Web:Host"]}");
    var clientCredentials = await keycloakService.GetClientCredentials(tenantStatusMessage.StoreSubDomain!);

    var messageTemplateService = scope.ServiceProvider.GetRequiredService<IMessageTemplateService>();
    var allMessageTemplates = await messageTemplateService.GetAllMessageTemplates(store.Id);
    foreach (var messageTemplate in allMessageTemplates)
    {
        messageTemplate.BccEmailAddresses = customer.Email;
        messageTemplate.EmailAccountId = lastEditedMailAccount?.Id;
        await messageTemplateService.UpdateMessageTemplate(messageTemplate);
    }
    
    // Configure Firebase for Push Notifications if Firebase settings exist
    if (tenantStatusMessage.Firebase != null && !string.IsNullOrEmpty(tenantStatusMessage.Firebase.ProjectId))
    {
        
        // Create and configure push notification settings
        var pushNotificationSettings = new PushNotificationsSettings {
            Enabled = true,
            ProjectId = tenantStatusMessage.Firebase.ProjectId,
            UseHttpV1Api = true,
            AllowGuestNotifications = true,
            PublicApiKey = "CHANGE_ME",
            PrivateApiKey = "CHANGE_ME",
            PictureId = tenantStatusMessage.LogoId,
            ClickUrl = $"https://{tenantStatusMessage.StoreSubDomain}.{builder.Configuration["Web:Host"]}"
        };
        var blobServiceClient = new BlobServiceClient(new Uri("https://storage.example.invalid"), new DefaultAzureCredential());
        var containerClient = blobServiceClient.GetBlobContainerClient("service-accounts");
        await containerClient.CreateIfNotExistsAsync(PublicAccessType.None);
        var blobClient = containerClient.GetBlobClient($"{tenantStatusMessage.Firebase.ProjectId}-service-account.json");
        var blobExists = await blobClient.ExistsAsync();
        if (blobExists)
        {
            pushNotificationSettings.ServiceAccountJson =
                Encoding.UTF8.GetString(blobClient.DownloadContent().Value.Content.ToArray());
        }
        
        
        await settingservice.SaveSetting(pushNotificationSettings);
    }

    


    await tenantSecrets.SetAsync(tenantStatusMessage.TenantId!, TenantSecretNames.BackendUserPassword, backendApiPassword);
    if (!string.IsNullOrEmpty(clientCredentials?.Value))
        await tenantSecrets.SetAsync(tenantStatusMessage.TenantId!, TenantSecretNames.KeycloakClient, clientCredentials.Value);
    await subscriber.PublishAsync(RedisChannel.Literal("COMPLETED_MIGRATION"), JsonSerializer.Serialize(
        new ResponseWithCredentialsModel() {
            IsSuccess = true,
            Message = tenantStatusMessage,
            FrontEndCredentialInfo = new FrontEndCredentialInfo() {
                ClientId = tenantStatusMessage.StoreSubDomain!,
                ClientSecret = clientCredentials?.Value,
            },
            BackendCredential = new BackendCredential() {
                ApiUserName = customer.Email,
                ApiPassword = backendApiPassword
            }
        }));
}


Console.WriteLine("Hello, World!");

public class ResponseWithCredentialsModel
{
    [JsonPropertyName("isSuccess")] public bool IsSuccess { get; set; }

    [JsonPropertyName("message")] public TenantStatusMessage Message { get; set; }

    [JsonPropertyName("frontEndCredentialInfo")]
    public FrontEndCredentialInfo FrontEndCredentialInfo { get; set; }

    [JsonPropertyName("backendCredential")]
    public BackendCredential BackendCredential { get; set; }
}

public class FrontEndCredentialInfo
{
    [JsonPropertyName("clientId")] public string ClientId { get; set; }

    [JsonIgnore] public string? ClientSecret { get; set; }
}

public class BackendCredential
{
    [JsonPropertyName("apiUserName")] public string ApiUserName { get; set; }

    [JsonIgnore] public string? ApiPassword { get; set; }
}

public class BasicResponseModel
{
    [JsonPropertyName("isSuccess")] public bool IsSuccess { get; set; }

    [JsonPropertyName("message")] public TenantStatusMessage Message { get; set; }
}