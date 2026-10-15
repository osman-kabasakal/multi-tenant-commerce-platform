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

var tenantStatusMessage = new TenantStatusMessage();
builder.Configuration.GetSection("TenantMessage").Bind(tenantStatusMessage);
builder.Services.AddScoped<InstallerService>();
builder.AddServiceDefaults(tenantStatusMessage.MongoConnectionString);
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


//add services
StartupBase.ConfigureServices(builder.Services, builder.Configuration);
builder.Services.AddRedisCache(builder.Configuration);

// var sa = new Grand.Business.Common.Startup.StartupApplication();

// sa.ConfigureServices(builder.Services, builder.Configuration);

builder.ConfigureApplicationSettings();

if (!builder.Configuration.GetValue<bool>("LocalDemo:Enabled"))
    ((ConfigurationManager)builder.Configuration).AddJsonFile(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "appsettings.multitenant.json"));

var conf = new KeycloakSettings();
builder.Configuration.GetSection("KeyCloakServiceClient").Bind(conf);
conf.ClientSecret = builder.Services.BuildServiceProvider().GetRequiredService<ISecretStore>()
    .GetAsync("system", $"ClientSecret-{conf.ClientId}").GetAwaiter().GetResult();
builder.Services.AddSingleton(conf);
builder.Services.Configure<KeycloakSettings>(builder.Configuration.GetSection("KeyCloakServiceClient"));

builder.Services.AddScoped<IKeycloakService, KeycloakService>();
builder.Services.AddScoped<IKeycloakUserService, KeycloakUserService>();

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
    
    var installerService = scope.ServiceProvider.GetRequiredService<InstallerService>();
    var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();
    Stopwatch stopwatch = new Stopwatch();

// Zamanlayıcıyı başlat
    stopwatch.Start();
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
        StoreHost = $"{tenantStatusMessage.StoreSubDomain}.{builder.Configuration["Web:Host"]}"
    });

    stopwatch.Stop();

// Sonuçları görüntüle
    logger.LogInformation($"Migration İşlem süresi: {stopwatch.Elapsed.TotalMinutes} milisaniye");
    var storeService = scope.ServiceProvider.GetService<IStoreService>();
    var store = (await storeService.GetAllStores()).FirstOrDefault();
    var tenantSecrets = scope.ServiceProvider.GetRequiredService<ITenantSecrets>();
    await tenantSecrets.ProvisionAsync(tenantStatusMessage.TenantId ?? tenantStatusMessage.StoreSubDomain!, tenantStatusMessage.StoreSubDomain!);
    tenantStatusMessage.TenantId = await tenantSecrets.ResolveAsync(tenantStatusMessage.StoreSubDomain!);
    await tenantSecrets.BindAliasAsync(tenantStatusMessage.StoreSubDomain!, store.Id);
    await tenantSecrets.SetAsync(tenantStatusMessage.StoreSubDomain!, TenantSecretNames.DatabaseConnection, tenantStatusMessage.MongoConnectionString!);

    store.Name = tenantStatusMessage.StoreName;
    store.UserFields.Add(new UserField {
        Key = "EncryptionKey",
        Value = tenantStatusMessage.StoreSubDomain,
        StoreId = store.Id
    });
    await storeService.UpdateStore(store);
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
    
    

    var currencyService = scope.ServiceProvider.GetRequiredService<ICurrencyService>();
    var currency = new Currency {
        CurrencyCode = "TRY",
        Name = "Türk Lirası",
        Rate = 1,
        Published = true,
        DisplayLocale = "tr-TR",
        DisplayOrder = 1,
        CreatedOnUtc = DateTime.UtcNow,
        RoundingTypeId = RoundingType.Rounding001,
        MidpointRoundId = MidpointRounding.ToEven,
        NumberDecimal = 0,
    };

    await currencyService.InsertCurrency(currency);
    var countryService = scope.ServiceProvider.GetRequiredService<ICountryService>();
    var turkey = await countryService.GetCountryByTwoLetterIsoCode("TR");
    var languageService = scope.ServiceProvider.GetRequiredService<ILanguageService>();
    var turkish = await languageService.GetLanguageByCode("tr");
    store.DefaultCurrencyId = currency.Id;
    store.DefaultCountryId = turkey?.Id;
    store.DefaultLanguageId = turkish?.Id;

    await storeService.UpdateStore(store);

    var currencySettings = scope.ServiceProvider.GetRequiredService<CurrencySettings>();
    currencySettings.PrimaryStoreCurrencyId = currency.Id;
    await settingservice.SaveSetting(currencySettings);

    if (turkish != null)
    {
        turkish.DefaultCurrencyId = currency.Id;
        await languageService.UpdateLanguage(turkish);
    }

    var customerSettings = scope.ServiceProvider.GetRequiredService<CustomerSettings>();
    customerSettings.UserRegistrationType = UserRegistrationType.Standard;
    customerSettings.UsernamesEnabled = false;
    customerSettings.GeoEnabled = true;
    customerSettings.NotifyNewCustomerRegistration = true;
    customerSettings.HideCoursesTab = true;
    customerSettings.HideSubAccountsTab = true;
    customerSettings.CustomerNameFormat = CustomerNameFormat.FullNames;
    customerSettings.FirstLastNameRequired = true;
    customerSettings.HideDownloadableProductsTab = true;
    customerSettings.DefaultPasswordFormat = PasswordFormat.Hashed;
    customerSettings.HashedPasswordFormat = HashedPasswordFormat.SHA512;
    customerSettings.StreetAddressEnabled = false;
    customerSettings.StreetAddressRequired = false;
    customerSettings.StreetAddress2Enabled = false;
    customerSettings.StreetAddress2Required = false;
    customerSettings.ZipPostalCodeEnabled = false;
    customerSettings.ZipPostalCodeRequired = false;
    customerSettings.CityEnabled = false;
    customerSettings.CityRequired = false;
    customerSettings.CountryEnabled = false;
    customerSettings.CountryRequired = false;
    customerSettings.AllowUsersToChangeEmail = false;
    customerSettings.HideReviewsTab = false;
    customerSettings.HideNotesTab = false;
    customerSettings.HideOutOfStockSubscriptionsTab = false;
    customerSettings.NewsletterBlockAllowToUnsubscribe = true;

    await settingservice.SaveSetting(customerSettings);

    var catalogSetting = scope.ServiceProvider.GetRequiredService<CatalogSettings>();
    catalogSetting.ShowSkuOnProductDetailsPage = true;
    catalogSetting.AllowViewUnpublishedProductPage = false;
    catalogSetting.DisplayDiscontinuedMessageForUnpublishedProducts = true;
    catalogSetting.ShowSkuOnProductDetailsPage = true;
    catalogSetting.ShowSkuOnCatalogPages = true;
    catalogSetting.ShowMpn = false;
    catalogSetting.ShowGtin = false;
    catalogSetting.ShowFreeShippingNotification = true;
    catalogSetting.AllowProductSorting = true;
    catalogSetting.AllowProductViewModeChanging = true;
    catalogSetting.ShowProductsFromSubcategories = true;
    catalogSetting.ShowCategoryProductNumber = true;
    catalogSetting.ShowCategoryProductNumberIncludingSubcategories = true;
    catalogSetting.CategoryBreadcrumbEnabled = true;
    catalogSetting.AskQuestionOnProduct = true;
    catalogSetting.EmailAFriendEnabled = true;
    catalogSetting.AllowAnonymousUsersToEmailAFriend = true;
    catalogSetting.RecentlyViewedProductsEnabled = true;
    catalogSetting.RecentlyViewedProductsNumber = 3;
    catalogSetting.RecommendedProductsEnabled = true;
    catalogSetting.SuggestedProductsEnabled = true;
    catalogSetting.SuggestedProductsNumber = 6;
    catalogSetting.PersonalizedProductsEnabled = true;
    catalogSetting.PersonalizedProductsNumber = 10;
    catalogSetting.NewProductsEnabled = true;
    catalogSetting.NewProductsNumber = 6;
    catalogSetting.NewProductsOnHomePage = true;
    catalogSetting.NewProductsNumberOnHomePage = 10;
    catalogSetting.ShowBestsellersOnHomepage = true;
    catalogSetting.NumberOfBestsellersOnHomepage = 10;
    catalogSetting.BestsellersFromReports = true;
    catalogSetting.PeriodBestsellers = 30;
    catalogSetting.ProductsAlsoPurchasedEnabled = true;
    catalogSetting.ProductsAlsoPurchasedNumber = 5;
    catalogSetting.NumberOfProductTags = 15;
    catalogSetting.ProductsByTagAllowCustomersToSelectPageSize = true;
    catalogSetting.ProductsByTagPageSize = 6;
    catalogSetting.ProductsByTagPageSizeOptions = "6,3,9,18,20";
    catalogSetting.CollectionsBlockItemsToDisplay = 2;
    catalogSetting.ShowSpecAttributeOnCatalogPages = true;
    catalogSetting.SecondPictureOnCatalogPages = true;
    catalogSetting.IncludeFeaturedProductsInNormalLists = true;
    catalogSetting.DisplayTierPricesWithDiscounts = true;
    catalogSetting.DisplayQuantityOnCatalogPages = false;
    catalogSetting.PublishBackProductWhenCancellingOrders = true;
    catalogSetting.ShowProductsFromSubcategoriesInSearchBox = true;
    catalogSetting.DefaultCollectionPageSize = 20;
    catalogSetting.NumberOfReview = 10;
    catalogSetting.LimitOfFeaturedProducts = 30;
    catalogSetting.MaxCatalogPageSize = 10000;
    catalogSetting.SortingByAvailability = true;
    catalogSetting.IgnoreDiscounts = false;
    catalogSetting.IgnoreFeaturedProducts = false;
    catalogSetting.IgnoreFilterableSpecAttributeOption = false;
    catalogSetting.IgnoreFilterableAvailableStartEndDateTime = false;
    catalogSetting.CustomerProductPrice = false;
    catalogSetting.ProductReviewsMustBeApproved = false;
    catalogSetting.AllowAnonymousUsersToReviewProduct = false;
    catalogSetting.NotifyStoreOwnerAboutNewProductReviews = true;
    catalogSetting.ProductReviewPossibleOnlyAfterPurchasing = true;
    catalogSetting.ProductReviewPossibleOnlyOnce = true;
    catalogSetting.DefaultProductRatingValue = 5;
    catalogSetting.FilterProductRating = "4.6,4.7,4.8,4.9,5";
    catalogSetting.SearchPageAllowCustomersToSelectPageSize = true;
    catalogSetting.SearchPageProductsPerPage = 6;
    catalogSetting.SearchPagePageSizeOptions = "6,3,9,18,20";
    catalogSetting.ProductSearchAutoCompleteEnabled = true;
    catalogSetting.ProductSearchAutoCompleteNumberOfProducts = 10;
    catalogSetting.ShowProductImagesInSearchAutoComplete = true;
    catalogSetting.ProductSearchTermMinimumLength = 3;
    catalogSetting.SearchBySku = true;
    catalogSetting.SearchByDescription = true;
    catalogSetting.SaveSearchAutoComplete = true;
    catalogSetting.CompareProductsEnabled = true;
    catalogSetting.IncludeShortDescriptionInCompareProducts = true;
    catalogSetting.IncludeFullDescriptionInCompareProducts = true;
    catalogSetting.ShowShareButton = true;
    catalogSetting.DefaultCategoryPageSizeOptions = "6,3,9,18,20";
    catalogSetting.DefaultCategoryPageSize = 20;
    
    await settingservice.SaveSetting(catalogSetting);

    var salesSetting = scope.ServiceProvider.GetRequiredService<OrderSettings>();

    salesSetting.IsReOrderAllowed = true;
    salesSetting.MinOrderSubtotalAmount = 50;
    salesSetting.MinOrderTotalAmount = 0;
    salesSetting.MinOrderSubtotalAmountIncludingTax = true;
    salesSetting.AnonymousCheckoutAllowed = true;
    salesSetting.TermsOfServiceOnShoppingCartPage = false;
    salesSetting.TermsOfServiceOnOrderConfirmPage = true;
    salesSetting.DisableOrderCompletedPage = false;
    salesSetting.AttachPdfInvoiceToOrderPlacedEmail = true;
    salesSetting.AttachPdfInvoiceToOrderPaidEmail = true;
    salesSetting.AttachPdfInvoiceToOrderCompletedEmail = true;
    salesSetting.DeactivateGiftVouchersAfterCancelOrder = true;
    salesSetting.DeactivateGiftVouchersAfterDeletingOrder = true;
    salesSetting.GiftVouchers_Assign_StoreId = true;
    salesSetting.CompleteOrderWhenDelivered = true;
    salesSetting.AllowCustomerToAddOrderNote = true;
    salesSetting.UserCanCancelUnpaidOrder = true;
    salesSetting.LengthCode = 8;
    salesSetting.MinimumOrderPlacementInterval = 30;
    salesSetting.UnpublishAuctionProduct = true;
    salesSetting.PageSize = 10;
    salesSetting.AttachPdfInvoiceToBinary = true;
    salesSetting.MerchandiseReturnsEnabled = true;
    salesSetting.MerchandiseReturns_AllowToSpecifyPickupAddress = true;
    salesSetting.MerchandiseReturns_AllowToSpecifyPickupDate = true;
    salesSetting.MerchandiseReturns_PickupDateRequired = true;
    salesSetting.NumberOfDaysMerchandiseReturnAvailable = 365;

    await settingservice.SaveSetting(salesSetting);

    var shoppingCartSettings = scope.ServiceProvider.GetRequiredService<ShoppingCartSettings>();

    
    shoppingCartSettings.AllowOutOfStockItemsToBeAddedToWishlist = true;
    shoppingCartSettings.MaximumShoppingCartItems = 1000;
    shoppingCartSettings.MaximumWishlistItems = 1000;
    shoppingCartSettings.MoveItemsFromWishlistToCart = true;
    shoppingCartSettings.ShowProductImagesOnShoppingCart = true;
    shoppingCartSettings.ShowProductImagesOnWishList = true;
    shoppingCartSettings.ShowDiscountBox = true;
    shoppingCartSettings.ShowGiftVoucherBox = true;
    shoppingCartSettings.CrossSellsNumber = 4;
    shoppingCartSettings.EmailWishlistEnabled = true;
    shoppingCartSettings.AllowAnonymousUsersToEmailWishlist = true;
    shoppingCartSettings.MiniShoppingCartEnabled = true;
    shoppingCartSettings.MiniCartProductNumber = 5;
    shoppingCartSettings.ShowImagesInsidebarCart = true;
    shoppingCartSettings.AllowCartItemEditing = true;
    shoppingCartSettings.SharedCartBetweenStores = true;
    shoppingCartSettings.AllowOnHoldCart = false;
    shoppingCartSettings.AllowToSelectWarehouse = false;
    shoppingCartSettings.GroupTierPrices = true;
    shoppingCartSettings.RoundPrices = true;

    await settingservice.SaveSetting(shoppingCartSettings);

    var loyalityPointsSettings = scope.ServiceProvider.GetRequiredService<LoyaltyPointsSettings>();
    loyalityPointsSettings.Enabled = true;
    loyalityPointsSettings.ExchangeRate = 0.005;
    loyalityPointsSettings.MinimumLoyaltyPointsToUse = 0;
    loyalityPointsSettings.PointsForRegistration = 0;
    loyalityPointsSettings.PointsForPurchases_Amount = 10;
    loyalityPointsSettings.PointsForPurchases_Points = 1;
    loyalityPointsSettings.ReduceLoyaltyPointsAfterCancelOrder = true;
    loyalityPointsSettings.DisplayHowMuchWillBeEarned = true;
    loyalityPointsSettings.PointsAccumulatedForAllStores = true;
    
    await settingservice.SaveSetting(loyalityPointsSettings);

    var langSetting = scope.ServiceProvider.GetRequiredService<LanguageSettings>();
    langSetting.DefaultAdminLanguageId = turkish?.Id;
    await settingservice.SaveSetting(langSetting);

    var addressSettings = settingservice.LoadSetting<AddressSettings>();

    addressSettings.CompanyEnabled = false;
    addressSettings.NoteEnabled = true;
    
    await settingservice.SaveSetting(addressSettings);
    
    var storageSettings = scope.ServiceProvider.GetRequiredService<StorageSettings>();
    storageSettings.PictureStoreInDb = true;
    await settingservice.SaveSetting(storageSettings);
    
    var systemSettings = scope.ServiceProvider.GetRequiredService<SystemSettings>();
    systemSettings.DaysToCancelUnpaidOrder = 7;
    await settingservice.SaveSetting(systemSettings);
    
    
    
    var storeInformationSetting = scope.ServiceProvider.GetRequiredService<StoreInformationSettings>();
    var clientCredentials = await keycloakService.GetClientCredentials(tenantStatusMessage.StoreSubDomain!);

    var addressAttributeService = scope.ServiceProvider.GetRequiredService<IAddressAttributeService>();
    
    var latAttribute = new AddressAttribute {
        Name = "lat",
        IsRequired = true,
        DisplayOrder = 0,
        AttributeControlType = AttributeControlType.TextBox,
        CreatedOnUtc = DateTime.UtcNow,
    };
    await addressAttributeService.InsertAddressAttribute(latAttribute);
    
    var longAttribute = new AddressAttribute {
        Name = "long",
        IsRequired = true,
        DisplayOrder = 0,
        AttributeControlType = AttributeControlType.TextBox,
        CreatedOnUtc = DateTime.UtcNow,
    };
    await addressAttributeService.InsertAddressAttribute(longAttribute);
    
    var bnoAttribute = new AddressAttribute {
        Name = "bno",
        IsRequired = true,
        DisplayOrder = 0,
        AttributeControlType = AttributeControlType.TextBox,
        CreatedOnUtc = DateTime.UtcNow,
    };
    await addressAttributeService.InsertAddressAttribute(bnoAttribute);
    
    var dnoAttribute = new AddressAttribute {
        Name = "dno",
        IsRequired = true,
        DisplayOrder = 0,
        AttributeControlType = AttributeControlType.TextBox,
        CreatedOnUtc = DateTime.UtcNow,
    };
    await addressAttributeService.InsertAddressAttribute(dnoAttribute);
    
    var knoAttribute = new AddressAttribute {
        Name = "kno",
        IsRequired = true,
        DisplayOrder = 0,
        AttributeControlType = AttributeControlType.TextBox,
        CreatedOnUtc = DateTime.UtcNow,
    };
    await addressAttributeService.InsertAddressAttribute(knoAttribute);
    
    var adres_tarifiAttribute = new AddressAttribute {
        Name = "adres_tarifi",
        IsRequired = true,
        DisplayOrder = 0,
        AttributeControlType = AttributeControlType.MultilineTextbox,
        CreatedOnUtc = DateTime.UtcNow,
    };
    await addressAttributeService.InsertAddressAttribute(adres_tarifiAttribute);
    
    

    var pictureService = scope.ServiceProvider.GetRequiredService<IPictureService>();
    var storeLogo = await pictureService.GetPictureUrl(storeInformationSetting.LogoPictureId,
        storeLocation: $"https://{tenantStatusMessage.StoreSubDomain}.{builder.Configuration["Web:Host"]}");
    tenantStatusMessage.LogoUrl = storeLogo;
    tenantStatusMessage.LogoId = storeInformationSetting.LogoPictureId;
    
    var _taxCategoryRepository = scope.ServiceProvider.GetRequiredService<IRepository<TaxCategory>>();

    var allRegisteredTaxCategories = await _taxCategoryRepository.Table.ToListAsync();

    if (allRegisteredTaxCategories.Count > 0)
    {
        await  _taxCategoryRepository.DeleteAsync(allRegisteredTaxCategories);
    }

    if (!_taxCategoryRepository.Table.Any(x => x.Name == "Temel Gıda Ürünleri"))
    {
        var taxCategoryOne = new TaxCategory {
            Name = "Temel Gıda Ürünleri",
            DisplayOrder = 1,
        };
        await _taxCategoryRepository.InsertAsync(taxCategoryOne);

        await settingservice.SetSetting($"Tax.TaxProvider.FixedRate.TaxCategoryId{taxCategoryOne.Id}",
            new { Rate = 1 });
        
        var taxCategoryTwo = new TaxCategory
        {
            Name = "Mobilya, Tekstil ve Temizlik Ürünleri",
            DisplayOrder = 2
        };
        await _taxCategoryRepository.InsertAsync(taxCategoryTwo);
        
        await settingservice.SetSetting($"Tax.TaxProvider.FixedRate.TaxCategoryId{taxCategoryTwo.Id}",
            new { Rate = 11 });
        
        var taxCategoryThree = new TaxCategory
        {
            Name = "Lüks Tüketim Ürünleri",
            DisplayOrder = 3
        };

        await _taxCategoryRepository.InsertAsync(taxCategoryThree);
        
        await settingservice.SetSetting($"Tax.TaxProvider.FixedRate.TaxCategoryId{taxCategoryThree.Id}",
            new { Rate = 20 });

        var taxSystemName = "Tax.FixedRate";
        var taxProviderettings = settingservice.LoadSetting<TaxProviderSettings>();
        var taxService = scope.ServiceProvider.GetRequiredService<ITaxService>();
        var taxProvider = taxService.LoadTaxProviderBySystemName(taxSystemName);
        if (taxProvider != null)
        {
            taxProviderettings.ActiveTaxProviderSystemName = taxSystemName;
            await settingservice.SaveSetting(taxProviderettings);
        }
        
        var taxSettings = settingservice.LoadSetting<TaxSettings>(store.Id);
        taxSettings.TaxDisplayType = TaxDisplayType.IncludingTax;
        taxSettings.HideZeroTax = true;
        taxSettings.ForceTaxExclusionFromOrderSubtotal = true;
        taxSettings.PricesIncludeTax = true;
        await settingservice.SaveSetting(taxSettings);
    }

    var stateImportManager = scope.ServiceProvider.GetRequiredService<IImportManager<CountryStatesDto>>();
    await stateImportManager.Import(File.OpenRead(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "App_Data", "turkey_states.xlsx")));
    turkey = await countryService.GetCountryByTwoLetterIsoCode("TR");
    if (turkey != null)
    {
        turkey.Name = "Türkiye";
        await countryService.UpdateCountry(turkey);
    }

    var allCountry = await countryService.GetAllCountries();
    foreach (var country in allCountry)
    {
        if (country.Id != turkey.Id)
        {
            country.Published = false;
            await countryService.UpdateCountry(country);
        }
    }
    
    // Activate only CashOnDelivery and Iyzico payment methods by default
    var paymentSettings = scope.ServiceProvider.GetRequiredService<PaymentSettings>();
    var settingService = scope.ServiceProvider.GetRequiredService<ISettingService>();
    
    // Clear any existing active payment methods
    paymentSettings.ActivePaymentProviderSystemNames.Clear();
    
    // Add only CashOnDelivery and Iyzico to active payment methods
    paymentSettings.ActivePaymentProviderSystemNames.Add("Payments.CashOnDelivery");
    // paymentSettings.ActivePaymentProviderSystemNames.Add("Payments.Iyzico");
    
    // Save the payment settings
    await settingService.SaveSetting(paymentSettings);
    
    var shippingMethodService = scope.ServiceProvider.GetRequiredService<IShippingMethodService>();
    var shippingMethods = await shippingMethodService.GetAllShippingMethods();
    foreach (var shippingMethod in shippingMethods)
    {
        await shippingMethodService.DeleteShippingMethod(shippingMethod);
    }
    
    var courierShippingMethod = new ShippingMethod {
        Name = "Kapına Teslimat",
        Description = "Kurye ile anında kapında",
        DisplayOrder = 1,
        CreatedOnUtc = DateTime.UtcNow,
        CreatedBy = customer.Id,
        UpdatedOnUtc = DateTime.UtcNow,
        UpdatedBy = customer.Id
    };
    
    await shippingMethodService.InsertShippingMethod(courierShippingMethod);

    var merchandiseReturnService = scope.ServiceProvider.GetRequiredService<IMerchandiseReturnService>();
    var merchandisereturnAllReasons = await merchandiseReturnService.GetAllMerchandiseReturnReasons();
    foreach (var merchandiseReturnReason in merchandisereturnAllReasons)
    {
        await merchandiseReturnService.DeleteMerchandiseReturnReason(merchandiseReturnReason);
    }
    var wrongProductReturnReason = new MerchandiseReturnReason {
        Name = "Yanlış ürün gönderimi",
        DisplayOrder = 1,
        CreatedOnUtc = DateTime.UtcNow,
        CreatedBy = customer.Id,
        UpdatedOnUtc = DateTime.UtcNow,
        UpdatedBy = customer.Id
    };
    
    await merchandiseReturnService.InsertMerchandiseReturnReason(wrongProductReturnReason);
    
    var productNotAsDescribedReturnReason = new MerchandiseReturnReason {
        Name = "Ürün açıklamasına uymuyor",
        DisplayOrder = 2,
        CreatedOnUtc = DateTime.UtcNow,
        CreatedBy = customer.Id,
        UpdatedOnUtc = DateTime.UtcNow,
        UpdatedBy = customer.Id
    };
    await merchandiseReturnService.InsertMerchandiseReturnReason(productNotAsDescribedReturnReason);
    
    var defectiveProductReturnReason = new MerchandiseReturnReason {
        Name = "Defolu ürün gönderimi",
        DisplayOrder = 3,
        CreatedOnUtc = DateTime.UtcNow,
        CreatedBy = customer.Id,
        UpdatedOnUtc = DateTime.UtcNow,
        UpdatedBy = customer.Id
    };
    
    await merchandiseReturnService.InsertMerchandiseReturnReason(defectiveProductReturnReason);
    
    var wrongProductOrderedReturnReason = new MerchandiseReturnReason {
        Name = "Yanlış ürün sipariş ettim",
        DisplayOrder = 4,
        CreatedOnUtc = DateTime.UtcNow,
        CreatedBy = customer.Id,
        UpdatedOnUtc = DateTime.UtcNow,
        UpdatedBy = customer.Id
    };
    
    await merchandiseReturnService.InsertMerchandiseReturnReason(wrongProductOrderedReturnReason);

    var returnActions = await merchandiseReturnService.GetAllMerchandiseReturnActions();
    foreach (var returnAction in returnActions)
    {
        await merchandiseReturnService.DeleteMerchandiseReturnAction(returnAction);
    }

    var repairAction = new MerchandiseReturnAction() {
        Name = "Ürününümün Onarılmasını İstiyorum",
        DisplayOrder = 1,
        CreatedOnUtc = DateTime.UtcNow,
        CreatedBy = customer.Id,
        UpdatedOnUtc = DateTime.UtcNow,
        UpdatedBy = customer.Id
    };
    
    await merchandiseReturnService.InsertMerchandiseReturnAction(repairAction);
    
    var replacementAction = new MerchandiseReturnAction() {
        Name = "Ürününümün Değiştirilmesini İstiyorum",
        DisplayOrder = 2,
        CreatedOnUtc = DateTime.UtcNow,
        CreatedBy = customer.Id,
        UpdatedOnUtc = DateTime.UtcNow,
        UpdatedBy = customer.Id
    };
    
    await merchandiseReturnService.InsertMerchandiseReturnAction(replacementAction);
    
    var refundAction = new MerchandiseReturnAction() {
        Name = "Para İadesini İstiyorum",
        DisplayOrder = 3,
        CreatedOnUtc = DateTime.UtcNow,
        CreatedBy = customer.Id,
        UpdatedOnUtc = DateTime.UtcNow,
        UpdatedBy = customer.Id
    };
    await merchandiseReturnService.InsertMerchandiseReturnAction(refundAction);

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