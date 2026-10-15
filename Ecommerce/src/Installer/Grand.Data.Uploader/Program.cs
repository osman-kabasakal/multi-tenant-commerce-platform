using Platform.Security;
using Azure.Identity;
using Azure.Security.KeyVault.Keys;
using Grand.Infrastructure;
using Grand.SharedKernel.Extensions;
using Grand.Web.ExternalSettings.Extensions;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using System.Reflection;
using Grand.Web.Common.Extensions;
using Microsoft.Extensions.DependencyInjection;
using Grand.Data;
using MongoDB.Driver;
using Grand.Domain.Catalog;
using Grand.Domain.Shipping;
using Grand.Domain.Customers;
using Grand.Domain.Tax;
using Grand.Business.Core.Interfaces.Storage;
using System.Text.Json.Serialization;
using System.Text.Json;
using Keycloak.Net;
using Azure.Security.KeyVault.Secrets;
using Flurl;
using Grand.Api.Commands.Models.Catalog;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Grand.Domain.Media;
using Grand.Business.Core.Interfaces.Catalog.Categories;
using Microsoft.OpenApi.Writers;
using Grand.Business.Core.Interfaces.Catalog.Products;
using MongoDB.Driver.Linq;
using Grand.Domain.Stores;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Checkout.Commands.Handlers.Orders;
using Grand.Business.Common.Services.ExportImport;
using Grand.Business.Core.Commands.Checkout.Orders;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Authentication;
using Grand.Business.Core.Interfaces.ExportImport;
using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Business.Core.Utilities.Authentication;
using Grand.Business.Tenants.Services.KeycloakUsers;
using Grand.Data.Uploader.Extensions;
using Grand.Data.Uploader.ImportDataObjects.NodeImport;
using Grand.Data.Uploader.Models;
using Grand.Data.Uploader.mongo;
using Grand.Domain.Common;
using Grand.Domain.Directory;
using Grand.Domain.Seo;
using Grand.Infrastructure.Extensions;
using Grand.Infrastructure.MultiTenant;
using HtmlAgilityPack;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using System.Collections;
using System.Drawing;
using System.Globalization;
using System.Net;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Web;

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

if (builder.Environment.IsDevelopment())
{
    CommonPath.WebHostEnvironment =
        Path.Combine(Directory.GetParent(builder.Environment.ContentRootPath).FullName, "wwwroot");
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

builder.AddServiceDefaults();
builder.Host.UseDefaultServiceProvider((_, options) =>
{
    options.ValidateScopes = false;
    options.ValidateOnBuild = false;
});

((ConfigurationManager)builder.Configuration).AddJsonFile(Path.Combine(AppDomain.CurrentDomain.BaseDirectory,
    "appsettings.multitenant.json"));

var conf = new KeycloakSettings();
builder.Configuration.GetSection("KeyCloakServiceClient").Bind(conf);
conf.ClientSecret = builder.Services.BuildServiceProvider().GetRequiredService<ISecretStore>()
    .GetAsync("system", $"ClientSecret-{conf.ClientId}").GetAwaiter().GetResult();

//add services
StartupBase.ConfigureServices(builder.Services, builder.Configuration);
builder.Services.AddRedisCache(builder.Configuration);
// var sa = new Grand.Business.Common.Startup.StartupApplication();

// sa.ConfigureServices(builder.Services, builder.Configuration);

builder.ConfigureApplicationSettings();


builder.Services.Configure<KeycloakSettings>(builder.Configuration.GetSection("KeyCloakServiceClient"));

builder.Services.AddScoped<IKeycloakClientService, KeycloakClientService>();
builder.Services.AddScoped<IKeycloakUserService, KeycloakUserService>();


builder.Services.AddScoped<IMongoDigestAuthenticationHandler, DigestAuthenticationHandler>();

builder.Services.AddHttpClient("MongoAtlasClient", (_httpClient) =>
{
    string _baseUrl =
        $"https://cloud.mongodb.com/api/atlas/v2/groups/{builder.Configuration["MongoAtlas:ProjectId"]}/";
    var authString = Convert.ToBase64String(Encoding.ASCII.GetBytes(
        $"{builder.Configuration["MongoAtlas:ClientPublicKey"]}:{builder.Configuration["MongoAtlas:ClientSecret"]}"));
    _httpClient.BaseAddress = new Uri(_baseUrl);
    _httpClient.Timeout = TimeSpan.FromSeconds(30);
    _httpClient.DefaultRequestHeaders.Accept.Add(
        new MediaTypeWithQualityHeaderValue("application/vnd.atlas.2024-08-05+json"));
});

builder.Services.AddScoped<IMongoAtlasClientService, MongoAtlasClientService>();



var serviceProvider = builder.Services.BuildServiceProvider();
var clientId = "saray-pastanesi";
using var _scope = serviceProvider.CreateScope();
var _serviceProvider = _scope.ServiceProvider;
var keycloakClient = new KeycloakClient(conf.Authority, conf.ClientSecret,
    new KeycloakOptions(adminClientId: conf.ClientId,
        authenticationRealm: conf.Realm));

var groups = await keycloakClient.GetGroupHierarchyAsync(conf.Realm);
//
// var _mongoAtlasClientService = _serviceProvider.GetRequiredService<IMongoAtlasClientService>();
// var _configuration = _serviceProvider.GetRequiredService<IConfiguration>();
// var _culustureName = _configuration["MongoAtlas:ClusterName"];
//
// var keyCloakUserService = _serviceProvider.GetRequiredService<IKeycloakUserService>();
// var grNames = groups.Select(x => x.Name).ToList();
// foreach (var gr in groups)
// {
//     if (!(gr.Attributes.ContainsKey("StoreMongoConnectionString") &&
//           gr.Attributes["StoreMongoConnectionString"].Count() > 0) )
//     {
//         continue;
//     }
//
//     try
//     {
//         var keyClient = new KeyClient(new Uri(_configuration["KeyVault:Url"]), new DefaultAzureCredential());
//         var deleteKeyOperation = keyClient.StartDeleteKey(gr.Name);
//         var deleteKeyOperationCompelteResult = await deleteKeyOperation.WaitForCompletionAsync();
//         var purgeDeletedKey = await keyClient.PurgeDeletedKeyAsync(deleteKeyOperationCompelteResult.Value.Name);
//     }
//     catch (Exception e)
//     {
//         var debug=true;
//     }
//    
//     var tenant = new DataSettings() {
//         ConnectionString = gr.Attributes["StoreMongoConnectionString"].First(),
//         DbProvider = DbProvider.MongoDB
//     };
//     var userPassword = PasswordGenerator.GenerateRandomPassword(includeSpecial:false);
//     var mongoUrl = new MongoUrl(tenant.ConnectionString);
//     var mongoUserName = mongoUrl.Username;
//     var mongourlDatabaseName = mongoUrl.DatabaseName;
//     try
//     {
//         var userExist = await _mongoAtlasClientService.DeleteAsync<MongoDatabaseUser>($"databaseUsers/admin/{mongoUserName}",CancellationToken.None);
//     }
//     catch (Exception)
//     {
//         // ignored
//     }
//
//     var response =
//         await _mongoAtlasClientService.PostAsync<CreateMongoDatabaseUserRequest, MongoDatabaseUser>($"databaseUsers",
//             new CreateMongoDatabaseUserRequest
//             {
//                 AwsIAMType ="NONE",
//                 DatabaseName = "admin",
//                 GroupId = _configuration["MongoAtlas:ProjectId"],
//                 Password = userPassword,
//                 Roles = new List<Role>()
//                 {
//                     new Role()
//                     {
//                         DatabaseName = mongourlDatabaseName,
//                         RoleName = "readWrite"
//                     }
//                 },
//                 Scopes = new List<Grand.Data.Uploader.Models.Scope>()
//                 {
//                     new Grand.Data.Uploader.Models.Scope()
//                     {
//                         Name = _culustureName,
//                         Type = "CLUSTER"
//                     }
//                 },
//                 Username = mongoUserName
//             }, CancellationToken.None);
//
//     var cluster =
//         await _mongoAtlasClientService.GetAsync<MongoAtlasClusterDetail>($"clusters/{_culustureName}", CancellationToken.None);
//     
//     string GetConnectionString(MongoAtlasClusterDetail mongoAtlasClusterDetail, string userName,
//         string password,
//         string databaseName,
//         string clusterName)
//     {
//         var connectionStringFormat = "mongodb+srv://{0}:{1}@{2}/{3}?retryWrites=true&w=majority&appName={4}";
//
//         return string.Format(connectionStringFormat, userName, password,
//             mongoAtlasClusterDetail.ConnectionStrings?.StandardSrv!.Replace("mongodb+srv://", String.Empty),
//             databaseName,
//             clusterName
//         );
//     }
//     
//     var connectionString = GetConnectionString(cluster!, mongoUserName, userPassword, mongourlDatabaseName,
//         _culustureName!);
//     
//     gr.Attributes["StoreMongoConnectionString"] = new List<string> { connectionString };
//     var froupUpdateResponse = await keycloakClient.UpdateGroupAsync(conf.Realm,gr.Id,gr);
//     if (!froupUpdateResponse)
//     {
//         var debug = true;
//     }
//     var existingClients = await keyCloakUserService.CreateClientWithMappersAsync(
//         gr.Name,
//         connectionString,
//         storeId: gr.Attributes["StoreId"].First(),
//         gr.Id
//         );
//     // foreach (var existingClient in existingClients)
//     // {
//     //     await keycloakClient.GenerateClientSecretAsync(conf.Realm, existingClient.Id);
//     // }
// }
//
// return;


var tenantDbs = groups.Where(x =>
    x.Attributes.ContainsKey("StoreMongoConnectionString") &&
    x.Attributes["StoreMongoConnectionString"].Count() > 0 &&
    x.Name == clientId).Select(x =>
    new DataSettings() {
        ConnectionString = x.Attributes["StoreMongoConnectionString"].First(),
        DbProvider = DbProvider.MongoDB
    }).ToList();

var taskContext = new {
    TenantDbSettings = tenantDbs.First(),
    ScopedServiceProvider = _serviceProvider.GetRequiredService<ITenantScopedServiceProvider<IMongoDatabase>>()
};

var mongourl = new MongoUrl(taskContext.TenantDbSettings.ConnectionString);
var databaseName = mongourl.DatabaseName;
var database = new MongoClient(taskContext.TenantDbSettings.ConnectionString).GetDatabase(databaseName);
var storeRepository = database.GetCollection<Store>(nameof(Store));
var storeContext = await storeRepository.AsQueryable()
    .FirstOrDefaultAsync();
using (var scope = taskContext.ScopedServiceProvider!.CreateScopeWithReplacement(database,storeContext.Id))
{
    var tenantIdentityAccessor = scope.ServiceProvider.GetRequiredService<ITenantIdentityAccessor>();
    tenantIdentityAccessor.TenantId = storeContext.Id;
    var workContext = scope.ServiceProvider.GetRequiredService<IWorkContextSetter>();
    var storeHelper = scope.ServiceProvider.GetRequiredService<IStoreHelper>();
    //
    var customerRepository = scope.ServiceProvider.GetRequiredService<IRepository<Customer>>();
    var customerGroupRepository = scope.ServiceProvider.GetRequiredService<IRepository<CustomerGroup>>();
    var adminGroup =
        await customerGroupRepository.GetOneAsync(x => x.SystemName == SystemCustomerGroupNames.Administrators);
    
    var customer = await customerRepository.Table.FirstOrDefaultAsync(x => x.Groups.Contains(adminGroup.Id));
    
    await workContext.SetCurrentCustomer(customer);
    await storeHelper.SetCurrentStore(scope.ServiceProvider.GetRequiredService<IRepository<Store>>().Table.First().Id);
    
    var deleteProductService = scope.ServiceProvider.GetRequiredService<ICategoryService>();
    var deleteProductRepository = scope.ServiceProvider.GetRequiredService<IRepository<Category>>();
    var allExistingProducts = deleteProductRepository.Table
        .Where(p => string.IsNullOrEmpty(p.ExternalId))
        .ToList();
    foreach (var product in allExistingProducts)
    {
        await deleteProductService.DeleteCategory(product);
    }

    return;
    // var dbContext = scope.ServiceProvider.GetRequiredService<IDatabaseContext>();
    // dbContext.SetConnection(taskContext.TenantDbSettings.ConnectionString);
    // if (!await dbContext.DatabaseExist())
    // {
    //     return;
    // }
    //
    // foreach (var group in groups.ToList())
    // {
    //     if (group.Attributes.ContainsKey("StoreId"))
    //     {
    //         var storeId = group.Attributes["StoreId"].FirstOrDefault();
    //         if (storeId != null)
    //         {
    //             try {
    //                 var frontendApiSecret = PasswordGenerator.GenerateRandomPassword(length: 128, includeSpecial: true);
    //                 var backendApiSecret = PasswordGenerator.GenerateRandomPassword(length: 128, includeSpecial: true);
    //                 // SecretClient servisi alınıyor
    //                 var secretClient = scope.ServiceProvider.GetRequiredService<ISecretStore>();
    //     
    //                 // FrontendAPI-Secret-{tenantId} için secret oluştur ve kaydet
    //                 await secretClient.SetSecretAsync($"FrontendAPI-Secret-{storeId}", frontendApiSecret);
    //     
    //                 // BackendAPI-Secret-{tenantId} için secret oluştur ve kaydet
    //                 await secretClient.SetSecretAsync($"BackendAPI-Secret-{storeId}", backendApiSecret);
    //             }
    //             catch (Exception ex) {
    //             }
    //         }
    //     }
    // }
    //
    // return;
    //
    // async Task<Customer> InsertSuperUser(string superUserEmail, string superUserPassword)
    // {
    //     var _customerGroupRepository = scope.ServiceProvider.GetRequiredService<IRepository<CustomerGroup>>();
    //     var crAdministrators = _customerGroupRepository.Table.FirstOrDefault(cg => cg.SystemName == SystemCustomerGroupNames.Administrators);
    //     var crRegistered = _customerGroupRepository.Table.FirstOrDefault(cg => cg.SystemName == SystemCustomerGroupNames.Registered);
    //     var _countryRepository = scope.ServiceProvider.GetRequiredService<IRepository<Country>>();
    //     var _customerRepository = scope.ServiceProvider.GetRequiredService<IRepository<Customer>>();
    //     var adminUser = new Customer {
    //         CustomerGuid = Guid.NewGuid(),
    //         Email = superUserEmail,
    //         Username = superUserEmail,
    //         Password = superUserPassword,
    //         PasswordFormatId = PasswordFormat.Clear,
    //         PasswordSalt = "",
    //         Active = true,
    //         LastActivityDateUtc = DateTime.UtcNow,
    //         PasswordChangeDateUtc = DateTime.UtcNow
    //     };
    //     
    //     var country = _countryRepository.Table.FirstOrDefault(c => c.ThreeLetterIsoCode == "TR");
    //     var defaultAdminUserAddress = new Address {
    //         FirstName = "Emre",
    //         LastName = "Özmen",
    //         PhoneNumber = "12345678",
    //         Email = superUserEmail,
    //         FaxNumber = "",
    //         Company = "Yasemin Döner",
    //         Address1 = "Yasemin D\\u00F6ner-Bah\\u00E7elievler Mah. \\u015Eht. \\u0130brahim Er Sk. No 79/1 Kar\\u015F\\u0131yaka / \\u0130zmir",
    //         Address2 = "",
    //         City = "İzmir",
    //         StateProvinceId = country?.StateProvinces.FirstOrDefault(sp => sp.Name.ToLowerInvariant() == "izmir")?.Id,
    //         CountryId = country?.Id,
    //         ZipPostalCode = "10021"
    //     };
    //     adminUser.Addresses.Add(defaultAdminUserAddress);
    //     adminUser.BillingAddress = defaultAdminUserAddress;
    //     adminUser.ShippingAddress = defaultAdminUserAddress;
    //     adminUser.Groups.Add(crAdministrators.Id);
    //     adminUser.Groups.Add(crRegistered.Id);
    //     adminUser.UserFields.Add(new UserField
    //         { Key = SystemCustomerFieldNames.FirstName, Value = "Emre", StoreId = "" });
    //     adminUser.UserFields.Add(new UserField
    //         { Key = SystemCustomerFieldNames.LastName, Value = "Özmen", StoreId = "" });
    //     await _customerRepository.InsertAsync(adminUser);
    //
    //     return adminUser;
    // } 
    //
    //
    
    //
    // var keycloakService = scope.ServiceProvider.GetService<IKeycloakUserService>();
    // var superAdminKeycloakUser = await keycloakService.GetUserAsync("64de11cb-dc8f-4a7b-9a36-0e1199738da9");
    // if (superAdminKeycloakUser == null)
    // {
    //     Console.WriteLine("Super admin user not found in Keycloak.");
    //     return;
    // }
    //
    //
    // await InsertSuperUser("emreozcelik10@gmail.com",PasswordGenerator.GenerateRandomPassword());
    // var externalCustomer = customerRepository.Table.Single(x => x.Email == "emreozcelik10@gmail.com");
    // var externalAuthanticationService = scope.ServiceProvider.GetRequiredService<IExternalAuthenticationService>();
    // await externalAuthanticationService.AssociateCustomer(externalCustomer, new ExternalAuthParam {
    //     ProviderSystemName = "ExternalAuth.Keycloak",
    //     AccessToken = "",
    //     Email = externalCustomer.Email,
    //     Identifier = "64de11cb-dc8f-4a7b-9a36-0e1199738da9",
    //     Name = $"Emre Özmen",
    //     Claims = new List<Claim>()
    // });
    //
    // return;
    //
    
    var productService = scope.ServiceProvider.GetRequiredService<IProductService>();
    // var allProducts = await productService.SearchProducts(showHidden:true);
    //
    // async Task<byte[]> DownloadImage(string url)
    // {
    //     if (url.StartsWith("data:image"))
    //     {
    //         // Base64 resmi
    //         string base64Data = url.Split(',')[1];
    //         return Convert.FromBase64String(base64Data);
    //     }
    //     else
    //     {
    //         // Normal URL
    //         using (HttpClient client = new HttpClient())
    //         {
    //             var imageArray = await client.GetByteArrayAsync(url);
    //             return imageArray;
    //         }
    //     }
    // }
    // ChromeOptions options = new ChromeOptions {
    //         
    // };
    // IWebDriver driver = new ChromeDriver(options);
    //
    // Actions actions = new Actions(driver);
    // foreach (var product in allProducts.products.ToList())
    // {
    //     string searchTerm = product.Name;
    //     
    //     // Google Images URL'si (örnek amaçlı)
    //     string url = $"https://www.google.com/search?q={WebUtility.UrlEncode(searchTerm + " yemek sepeti")}&tbm=isch";
    //     
    //     await driver.Navigate().GoToUrlAsync(url);
    //     await Task.Delay(TimeSpan.FromSeconds(5));
    //     
    //     // Resim etiketlerini bul
    //     var imageNodes = driver.FindElements(By.CssSelector("#rso a"));
    //
    //     if (imageNodes != null)
    //     {
    //         // var img = imageNodes.FirstOrDefault();
    //         foreach (var img in imageNodes)
    //         {
    //             if (img!=null)
    //             {
    //                 
    //                 actions.MoveToElement(img).Perform();
    //                 await Task.Delay(TimeSpan.FromSeconds(1));
    //                 var link = img.GetAttribute("href");
    //                 if (!string.IsNullOrEmpty(link) && Uri.TryCreate(HttpUtility.UrlDecode(link), UriKind.Absolute, out var uri))
    //                 {
    //                     var queryNameValue= HttpUtility.ParseQueryString(uri.Query);
    //                     var imgUrl = queryNameValue.Get("imgurl");
    //                     if (imgUrl != null && imgUrl.Contains("images.deliveryhero.io"))
    //                     {
    //                         // Base64 veya geçerli bir URL olup olmadığını kontrol et
    //                         if (!string.IsNullOrEmpty(imgUrl) && (imgUrl.StartsWith("http")))
    //                         {
    //                             try
    //                             {
    //                                 // Resmi indir ve kaydet
    //                                 Uri.TryCreate(imgUrl, UriKind.RelativeOrAbsolute, out var  fullSizeUri);
    //                                 var fullSizeUrl = fullSizeUri.RemoveQueryParam("height").RemoveQueryParam("width").SetQueryParam("width", 1920);
    //                                 await UpdateProductPictureWithUrl(scope.ServiceProvider, product, fullSizeUrl.ToString());
    //                                 break;
    //                             }
    //                             catch (Exception ex)
    //                             {
    //                                 Console.WriteLine($"Hata: {ex.Message}");
    //                             }
    //                         }
    //                     }
    //                 }
    //                 
    //             }
    //         }
    //     }
    // }
    //
    // return;

    // using (var categoryStream = File.OpenRead("Upload/davetiyen/categories_davetiyen.xlsx"))
    // {
    //     var categoryImport = new ImportManager<NodeCategory>(new ExcelImportProvider(), ActivatorUtilities.CreateInstance<NodeCategoryImportObject>(scope.ServiceProvider)); 
    //     await categoryImport.Import(categoryStream);
    // }

    // using (var categoryStream = File.OpenRead("Upload/davetiyen/products_davetiyen_yeni_1.xlsx"))
    // {
    //     var categoryImport = new ImportManager<NodeProduct>(new ExcelImportProvider(), ActivatorUtilities.CreateInstance<NodeProductImport>(scope.ServiceProvider)); 
    //     await categoryImport.Import(categoryStream);
    // }
    //
    // return;

    // var allProducts= (await productService.SearchProducts()).products.ToList();
    // var orderService = scope.ServiceProvider.GetRequiredService<IOrderService>();
    // var orders = await orderService.SearchOrders(pageIndex:0);
    //
    // // foreach(var pr in allProducts){
    // //     pr.Price = Random.Shared.Next(15,2000);
    // //     pr.OldPrice= pr.Price * (1 + Random.Shared.NextDouble());
    // //     await productService.UpdateProduct(pr);
    // // }
    //
    //
    // foreach (var order in orders)
    // {
    //     foreach (var orderItem in order.OrderItems)
    //     {
    //         orderItem.ProductId= allProducts[Random.Shared.Next(0,allProducts.Count)].Id;
    //     }
    //
    //     await orderService.UpdateOrder(order);
    // }
    // return;

    var pictureService = scope.ServiceProvider.GetRequiredService<IPictureService>();
    var pictureRepository = scope.ServiceProvider.GetRequiredService<IRepository<Picture>>();
    var downloadService = scope.ServiceProvider.GetRequiredService<IDownloadService>();

    var _productLayoutRepository = scope.ServiceProvider.GetRequiredService<IRepository<ProductLayout>>();
    var _deliveryDateRepository = scope.ServiceProvider.GetRequiredService<IRepository<DeliveryDate>>();
    var _customerRepository = scope.ServiceProvider.GetRequiredService<IRepository<Customer>>();
    var _taxCategoryRepository = scope.ServiceProvider.GetRequiredService<IRepository<TaxCategory>>();

    var specificationRepository = scope.ServiceProvider.GetRequiredService<IRepository<SpecificationAttribute>>();

    // if (!_taxCategoryRepository.Table.Any(x => x.Name == "Temel Gıda Ürünleri"))
    // {
    //     await _taxCategoryRepository.InsertAsync(new TaxCategory
    //     {
    //         Name = "Temel Gıda Ürünleri",
    //         DisplayOrder = 1
    //     });
    //
    //     await _taxCategoryRepository.InsertAsync(new TaxCategory
    //     {
    //         Name = "Mobilya, Tekstil ve Temizlik Ürünleri",
    //         DisplayOrder = 2
    //     });
    //
    //     await _taxCategoryRepository.InsertAsync(new TaxCategory
    //     {
    //         Name = "Lüks Tüketim Ürünleri",
    //         DisplayOrder = 3
    //     });
    // }
    var store = scope.ServiceProvider.GetRequiredService<IRepository<Store>>().Table.First();
    var productrepository = scope.ServiceProvider.GetRequiredService<IRepository<Product>>();

    await workContext.SetCurrentCustomer();
    await storeHelper.SetCurrentStore(store.Id);

    var _categoryService = scope.ServiceProvider.GetRequiredService<ICategoryService>();
    await productrepository.DeleteManyAsync(x => true);


    // var cats = await _categoryService.GetAllCategories(showHidden: true);
    // foreach (var cat in cats)
    // {
    //     if (cat.ParentCategoryId != null && cats.All(x => x.ParentCategoryId != cat.Id))
    //     {
    //         var products = await scope.ServiceProvider.GetRequiredService<IRepository<Product>>().Table.CountAsync(x => x.ProductCategories.Any(y => y.CategoryId == cat.Id));
    //         if (products == 0)
    //         {
    //             await _categoryService.DeleteCategory(cat);
    //         }
    //     }
    // }
    // return;
    var _categoryRepository = scope.ServiceProvider.GetRequiredService<IRepository<Category>>();

    var jsonData = await File.ReadAllTextAsync("Upload/Yasemindoner/menu.json");
    var productModel = JsonSerializer.Deserialize<TrendyolMenuModel>(jsonData);
    var httpClient = scope.ServiceProvider.GetRequiredService<IHttpClientFactory>().CreateClient();
    var newSectionId = 2079102;
    var bestSellerSectionId = 1154277;

    var productLayoutSimple = _productLayoutRepository.Table.FirstOrDefault(pt => pt.Name == "Simple product");

    var seoSettings = scope.ServiceProvider.GetRequiredService<SeoSettings>();
    var specificationService = scope.ServiceProvider.GetRequiredService<ISpecificationAttributeService>();
    var ingredientSeName = SeoExtensions.GetSeName("Malzemeler", seoSettings.ConvertNonWesternChars,
        seoSettings.AllowUnicodeCharsInUrls, seoSettings.SeoCharConversion);
    var savedIngredient = await specificationService.GetSpecificationAttributeBySeName(ingredientSeName);

    var attributeService = scope.ServiceProvider.GetRequiredService<IProductAttributeService>();
    if (savedIngredient == null)
    {
        savedIngredient = new SpecificationAttribute {
            Name = "Malzemeler",
            SeName = ingredientSeName,
            DisplayOrder = 0,
            LimitedToStores = false,
        };

        await specificationService.InsertSpecificationAttribute(savedIngredient);
    }

    TrendyolProduct? getTrendyolProduct(int id) => productModel.products.FirstOrDefault(x => x.id == id);
    ModifierGroup? getTrendyolModifierGroup(int id) => productModel.modifierGroups.FirstOrDefault(x => x.id == id);

    foreach (var option in savedIngredient.SpecificationAttributeOptions.ToList())
    {
        savedIngredient.SpecificationAttributeOptions.Remove(option);
    }

    string getOptionNameFromTrendyol(string trendyolOptionName) => string.Join(' ',
        trendyolOptionName.ToLowerInvariant().Split(' ').Where(n => !string.IsNullOrEmpty(n))
            .Select((n) => string.Join("", n[0].ToString().ToUpper(), string.Join("", n[1..]))).ToList());

    var ingredientsToSpecifications = productModel.ingredients.Where(x => (x.price ?? 0) <= 0).Select(x =>
    {
        x.name = getOptionNameFromTrendyol(x.name);
        return x;
    }).DistinctBy(x => new { x.name, x.price }).Select(x => new KeyValuePair<int, SpecificationAttributeOption>(x.id,
        new SpecificationAttributeOption {
            Name = x.name,
            SeName = SeoExtensions.GenerateSlug(x.name, false, false, false),
        })
    ).ToList();
    foreach (var attributeOption in ingredientsToSpecifications)
    {
        savedIngredient.SpecificationAttributeOptions.Add(attributeOption.Value);
    }

    await specificationService.UpdateSpecificationAttribute(savedIngredient);

    var modifierGroups = productModel.modifierGroups;
    var allAttributes = await attributeService.GetAllProductAttributes();
    var modiferGroupAttributeMApping = new Dictionary<int, ProductAttribute>();
    foreach (var modifierGroup in modifierGroups)
    {
        var productAttributeSename = SeoExtensions.GetSeName($"{modifierGroup.name} {modifierGroup.id}",
            seoSettings.ConvertNonWesternChars,
            seoSettings.AllowUnicodeCharsInUrls,
            seoSettings.SeoCharConversion);
        var savedModifierGroup = allAttributes.FirstOrDefault(x => x.SeName == productAttributeSename);
        if (savedModifierGroup == null)
        {
            savedModifierGroup = new ProductAttribute {
                Name = modifierGroup.name,
                SeName = productAttributeSename,
                LimitedToStores = false,
                PredefinedProductAttributeValues = new List<PredefinedProductAttributeValue>()
            };
            await attributeService.InsertProductAttribute(savedModifierGroup);
        }
        else
        {
            foreach (var option in savedModifierGroup.PredefinedProductAttributeValues.ToList())
            {
                savedModifierGroup.PredefinedProductAttributeValues.Remove(option);
            }
        }

        foreach (var option in modifierGroup.modifierProducts)
        {
            var tProduct = getTrendyolProduct(option.id);
            if (tProduct == null)
                continue;
            var savedOption = new PredefinedProductAttributeValue() {
                Name = getOptionNameFromTrendyol(tProduct.name),
                PriceAdjustment = Convert.ToDouble(option.price ?? 0),
                DisplayOrder = option.position,
            };
            savedModifierGroup.PredefinedProductAttributeValues.Add(savedOption);
        }

        await attributeService.UpdateProductAttribute(savedModifierGroup);
        modiferGroupAttributeMApping.Add(modifierGroup.id, savedModifierGroup);
    }

    var extraIngredientAttrName = "Ekstra Malzeme";
    var extraIngredientAttrSeName = SeoExtensions.GetSeName(extraIngredientAttrName, seoSettings.ConvertNonWesternChars,
        seoSettings.AllowUnicodeCharsInUrls,
        seoSettings.SeoCharConversion);
    var extraIngredientAttr = allAttributes.FirstOrDefault(x => x.SeName == extraIngredientAttrSeName);
    if (extraIngredientAttr == null)
    {
        extraIngredientAttr = new ProductAttribute {
            Name = extraIngredientAttrName,
            SeName = extraIngredientAttrSeName,
            PredefinedProductAttributeValues = new List<PredefinedProductAttributeValue>(),
            LimitedToStores = false,
        };
        await attributeService.InsertProductAttribute(extraIngredientAttr);
    }
    else
    {
        extraIngredientAttr.PredefinedProductAttributeValues ??= new List<PredefinedProductAttributeValue>();
        foreach (var option in (extraIngredientAttr.PredefinedProductAttributeValues?.ToList() ?? []))
        {
            extraIngredientAttr.PredefinedProductAttributeValues!.Remove(option);
        }
    }

    var ingredientAttr = productModel.ingredients.Where(x => (x.price ?? 0) > 0).Select(x =>
    {
        x.name = getOptionNameFromTrendyol(x.name);
        return x;
    }).DistinctBy(x => new { x.name, x.price }).Select(x => new KeyValuePair<int, PredefinedProductAttributeValue>(x.id,
        new PredefinedProductAttributeValue {
            Name = getOptionNameFromTrendyol(x.name),
            PriceAdjustment = Convert.ToDouble(x.price ?? 0),
            DisplayOrder = 0,
        })
    ).ToList();

    foreach (var extraAttr in ingredientAttr)
    {
        extraIngredientAttr.PredefinedProductAttributeValues!.Add(extraAttr.Value);
    }

    await attributeService.UpdateProductAttribute(extraIngredientAttr);

    PredefinedProductAttributeValue? getExtraAttributeValue(int id) =>
        extraIngredientAttr.PredefinedProductAttributeValues!.FirstOrDefault(a =>
            a.Name == getOptionNameFromTrendyol(productModel.ingredients.FirstOrDefault(x => x.id == id)?.name ?? "") &&
            a.PriceAdjustment ==
            Convert.ToDouble(productModel.ingredients!.FirstOrDefault(x => x.id == id)?.price ?? 0));

    SpecificationAttributeOption? GetIngredientSpecificationAttributeOption(int id) =>
        savedIngredient.SpecificationAttributeOptions.FirstOrDefault(a =>
            a.Name == getOptionNameFromTrendyol(productModel.ingredients.FirstOrDefault(x => x.id == id)?.name ?? ""));


    var tempProducts = productModel.products.ToList();
    var sections = productModel.sections.ToList();
    foreach (var section in sections)
    {
        var catName = getOptionNameFromTrendyol(section.name);
        var sectionCategory = await _categoryRepository.GetOneAsync(x => x.Name == catName);
        if (sectionCategory == null)
        {
            var categoryEntity = new Category {
                Name = catName,
                Published = section.status == "ACTIVE",
                DefaultSort = 0,
                AllowCustomersToSelectPageSize = true,
                PageSizeOptions = "6,3,9,18,20",
                FeaturedProductsOnHomePage = true,
            };

            await _categoryService.InsertCategory(categoryEntity);
            sectionCategory = categoryEntity;
        }

        var sectionProducts = await productService.SearchProducts(categoryIds: [sectionCategory.Id]);
        foreach (var p in sectionProducts.products.ToList())
        {
            await productService.DeleteProduct(p);
        }

        await AddCategoryProducts(section, sectionCategory);
    }

    tempProducts.RemoveAll(tp =>
        productModel.modifierGroups.SelectMany(x => x.modifierProducts.Select(a => a.id)).Contains(tp.id));
    tempProducts.RemoveAll(tp =>
        productModel.sections.SelectMany(x => x.products.Select(a => a.id)).Contains(tp.id));

    if (tempProducts.Count > 0)
    {
        var section = new Section {
            id = 0,
            name = "Kategorisiz Ürünler",
            position = 0,
            products = tempProducts,
            status = "PASSIVE",
        };
        var catName = getOptionNameFromTrendyol(section.name);
        var sectionCategory = await _categoryRepository.GetOneAsync(x => x.Name == catName);
        if (sectionCategory == null)
        {
            var categoryEntity = new Category {
                Name = catName,
                Published = section.status == "ACTIVE",
                DefaultSort = 0,
                AllowCustomersToSelectPageSize = true,
                PageSizeOptions = "6,3,9,18,20",
                FeaturedProductsOnHomePage = true,
                ExternalId = section.id.ToString(),
                ShowOnHomePage = section.id != newSectionId && section.id != bestSellerSectionId,
            };

            await _categoryService.InsertCategory(categoryEntity);
            sectionCategory = categoryEntity;
        }

        var sectionProducts = await productService.SearchProducts(categoryIds: [sectionCategory.Id]);
        foreach (var p in sectionProducts.products.ToList())
        {
            await productService.DeleteProduct(p);
        }

        await AddCategoryProducts(section, sectionCategory, true);
    }

    return;

    var categories = productModel.sections.ToList();
    foreach (var category in categories)
    {
        var savedCategory = await _categoryRepository.GetOneAsync(x => x.Name == category.name);
        if (savedCategory == null)
        {
            var categoryEntity = new Category {
                Name = category.name,
                Published = true,
                DefaultSort = 0,
                AllowCustomersToSelectPageSize = true,
                PageSizeOptions = "6,3,9,18,20"
            };

            await _categoryService.InsertCategory(categoryEntity);
            savedCategory = categoryEntity;
        }

        // else if (!savedCategory.Published ||savedCategory.DefaultSort != 0)
        // {
        //     savedCategory.Published = true;
        //     savedCategory.DefaultSort = 0;
        //     await _categoryRepository.UpdateAsync(savedCategory);
        // }

        // if (!string.IsNullOrEmpty(category.image_url) && savedCategory.PictureId == null)
        // {
        //     try
        //     {
        //         var url = new Uri(category.image_url, UriKind.Absolute);
        //         var u = url.RemoveQueryParam("width").SetQueryParam("width", 1920);
        //         var imageResponse = await httpClient.GetByteArrayAsync(u.ToString());
        //
        //         var picture = await pictureService.InsertPicture(imageResponse, getMimeTypes(category.image_url),
        //             pictureService.GetPictureSeName(category.name), reference: Reference.Category, objectId: savedCategory.Id);
        //         savedCategory.PictureId = picture.Id;
        //         await _categoryService.UpdateCategory(savedCategory);
        //     }
        //     catch (Exception e)
        //     {
        //         
        //     }
        // }
        // else if (!string.IsNullOrEmpty(category.image_url))
        // {
        //     await pictureService.SetSeoFilename(await pictureRepository.GetOneAsync(x => x.Id == savedCategory.PictureId), pictureService.GetPictureSeName(category.name));
        // }

        // await AddSubCategoriesWithProducts(scope.ServiceProvider, category.products.Select(x=>new Subcategory {
        //     id = x.id,
        //     name = x.name,
        //     url = "",
        //     price = x.price,
        //     image_url = x.image_url,
        //     images = x.images,
        //     attributes = [],
        //     products = [],
        //     subCategories = []
        // }).ToList(), savedCategory);
    }

    async Task AddCategoryProducts(Section section, Category sectionCategory, bool showOnHomePage = false)
    {
        foreach (var tSectionProd in section.products)
        {
            var tProd = getTrendyolProduct(tSectionProd.id);
            if (tProd == null)
                continue;
            
            if (productrepository.Table.Any(x => x.ExternalId == tProd.id.ToString()))
                continue;
            
            var product = new Product() {
                ProductTypeId = ProductType.SimpleProduct,
                VisibleIndividually = true,
                ShortDescription =
                    tProd.description,
                FullDescription =
                    "",
                ProductLayoutId = productLayoutSimple.Id,
                ExternalId = tProd.id.ToString(),
                AllowCustomerReviews = true,
                IsShipEnabled = true,
                ShowOnHomePage = showOnHomePage,
                Weight = 2,
                Length = 2,
                Width = 2,
                Height = 3,
                TaxCategoryId = _taxCategoryRepository.Table.Single(tc => tc.Name == "Temel Gıda Ürünleri").Id,
                ManageInventoryMethodId = ManageInventoryMethod.DontManageStock,
                StockQuantity = 10000,
                NotifyAdminForQuantityBelow = 1,
                AllowOutOfStockSubscriptions = false,
                StockAvailability = true,
                LowStockActivityId = LowStockActivity.DisableBuyButton,
                BackorderModeId = BackorderMode.NoBackorders,
                OrderMinimumQuantity = 1,
                OrderMaximumQuantity = 10000,
                Published = tProd.status == "ACTIVE",
                ProductCategories = {
                    new ProductCategory() {
                        CategoryId = sectionCategory.Id,
                        IsFeaturedProduct = true
                    }
                },
                BestSeller = bestSellerSectionId == section.id,
                MarkAsNew = newSectionId == section.id,
                Name = tProd.name,
                Price = Convert.ToDouble(tProd.sellingPrice ?? 0),
                OldPrice = (Convert.ToDouble(tProd.sellingPrice ?? 0) * (1 + Random.Shared.NextDouble())),
            };

            await productService.InsertProduct(product);

            foreach (var ingredient in tProd.ingredients)
            {
                var ingredientOption = GetIngredientSpecificationAttributeOption(ingredient);
                if (ingredientOption == null)
                    continue;
                var specificationATtribute =
                    await specificationService.GetSpecificationAttributeByOptionId(ingredientOption.Id);
                await specificationService.InsertProductSpecificationAttribute(new ProductSpecificationAttribute {
                    AttributeTypeId = SpecificationAttributeType.Option,
                    SpecificationAttributeId = specificationATtribute.Id,
                    SpecificationAttributeOptionId = specificationRepository.Table.Single(x=>x.Id==specificationATtribute.Id).SpecificationAttributeOptions
                        .Single(x => x.SeName == ingredientOption.SeName).Id,
                    AllowFiltering = true,
                    ShowOnProductPage = true,
                    DisplayOrder = 0
                }, product.Id);
            }

            foreach (var prodModifierGroup in tProd.modifierGroups)
            {
                var prodModifierGroupDetail = getTrendyolModifierGroup(prodModifierGroup.id);
                if (prodModifierGroupDetail == null)
                    continue;
                var modifierGroupAttr = modiferGroupAttributeMApping[prodModifierGroup.id];
                var productAttributeMapping = new ProductAttributeMapping {
                    ProductAttributeId = modifierGroupAttr.Id,
                    TextPrompt = modifierGroupAttr.Name,
                    IsRequired = prodModifierGroupDetail.min > 0,
                    ShowOnCatalogPage = true,
                    Combination = true,

                    AttributeControlTypeId = prodModifierGroupDetail switch {
                        {
                            min: 1,
                            max: 1,
                            modifierProducts.Count: > 1
                        } => AttributeControlType.RadioList,
                        {
                            min: 1,
                            max: 1,
                            modifierProducts.Count: 1
                        } => AttributeControlType.ReadonlyCheckboxes,
                        {
                            min: 0,
                            max: 1,
                            modifierProducts.Count: > 1
                        } => AttributeControlType.DropdownList,
                        {
                            min: 0,
                            max: 1,
                            modifierProducts.Count: 1
                        } => AttributeControlType.ReadonlyCheckboxes,
                        _ => AttributeControlType.Checkboxes
                    },
                    DisplayOrder = 1,
                };

                await attributeService.InsertProductAttributeMapping(productAttributeMapping, product.Id);

                foreach (var option in prodModifierGroupDetail.modifierProducts)
                {
                    var tProduct = getTrendyolProduct(option.id);
                    if (tProduct == null)
                        continue;
                    var predefinedAttribute =
                        modifierGroupAttr.PredefinedProductAttributeValues.FirstOrDefault(x =>
                            x.Name == getOptionNameFromTrendyol(tProduct.name));
                    if (predefinedAttribute == null)
                        continue;
                    var savedOption = new ProductAttributeValue {
                        AttributeValueTypeId = AttributeValueType.Simple,
                        Name = predefinedAttribute.Name,
                        PriceAdjustment = predefinedAttribute.PriceAdjustment,
                        IsPreSelected = prodModifierGroupDetail switch {
                            {
                                min: 1,
                                max: 1,
                                modifierProducts.Count: > 1
                            } => !prodModifierGroupDetail.modifierProducts.Any(x => x.position < option.position),
                            {
                                min: 1,
                                max: 1,
                                modifierProducts.Count: 1
                            } => true,
                            {
                                min: 0,
                                max: 1,
                                modifierProducts.Count: > 1
                            } => false,
                            {
                                min: 0,
                                max: 1,
                                modifierProducts.Count: 1
                            } => true,
                            _ => false
                        },
                        DisplayOrder = option.position,
                    };
                    await attributeService.InsertProductAttributeValue(savedOption, product.Id,
                        productAttributeMapping.Id);
                }
            }

            if (tProd.extraIngredients.Count > 0)
            {
                var productAttributeMapping = new ProductAttributeMapping {
                    ProductAttributeId = extraIngredientAttr.Id,
                    TextPrompt = extraIngredientAttr.Name,
                    IsRequired = false,
                    ShowOnCatalogPage = true,
                    Combination = true,

                    AttributeControlTypeId = AttributeControlType.Checkboxes,
                    DisplayOrder = 1,
                };
                await attributeService.InsertProductAttributeMapping(productAttributeMapping, product.Id);

                foreach (var extraIngredient in tProd.extraIngredients)
                {
                    var tProduct = getTrendyolProduct(extraIngredient);
                    if (tProduct == null)
                        continue;

                    var extraIngredientOption = getExtraAttributeValue(extraIngredient);

                    if (extraIngredientOption != null)
                    {
                        var savedOption = new ProductAttributeValue {
                            AttributeValueTypeId = AttributeValueType.Simple,
                            Name = extraIngredientOption.Name,
                            PriceAdjustment = extraIngredientOption.PriceAdjustment,
                            IsPreSelected = false,
                            DisplayOrder = extraIngredientOption.DisplayOrder,
                        };
                        await attributeService.InsertProductAttributeValue(savedOption, product.Id,
                            productAttributeMapping.Id);
                    }
                }
            }
        }
    }
}
//
// Task AddSectionProductsWithAttributes( IServiceProvider serviceProvider, Section section, TrendyolProduct[] products )
// {
//     
// }

Task AddSubCategoriesWithProducts(IServiceProvider serviceProvider, List<Subcategory> subcategories,
    Category savedCategory)
{
    var _categoryService = serviceProvider.GetRequiredService<ICategoryService>();
    var _categoryRepository = serviceProvider.GetRequiredService<IRepository<Category>>();
    var _productRepository = serviceProvider.GetRequiredService<IRepository<Product>>();
    var _pictureService = serviceProvider.GetRequiredService<IPictureService>();
    var _downloadService = serviceProvider.GetRequiredService<IDownloadService>();

    var productService = serviceProvider.GetRequiredService<IProductService>();
    var _productLayoutRepository = serviceProvider.GetRequiredService<IRepository<ProductLayout>>();
    var _taxCategoryRepository = serviceProvider.GetRequiredService<IRepository<TaxCategory>>();
    var productRepository = serviceProvider.GetRequiredService<IRepository<Product>>();

    var httpClient = serviceProvider.GetRequiredService<IHttpClientFactory>().CreateClient();
    return Task.Run(async () =>
    {
        var productLayoutSimple = _productLayoutRepository.Table.FirstOrDefault(pt => pt.Name == "Simple product");

        foreach (var subcategory in subcategories)
        {
            // var productName = "";
            // var names = subcategory.name.Split("-");
            // if (names.Length>1)
            // {
            //     productName = string.Join("",names.Where(x=> x != names.Last()).ToList());
            // }
            // else
            // {
            //     productName = subcategory.name;
            // }

            if ((subcategory.subCategories == null || subcategory.subCategories.Count == 0) &&
                (subcategory.products == null || subcategory.products.Count == 0))
            {
                if (productRepository.Table.Any(x => x.Name == subcategory.name))
                {
                    // await UpdateProductPictures(serviceProvider, subcategory);
                    continue;
                }

                var product = new Product() {
                    ProductTypeId = ProductType.SimpleProduct,
                    VisibleIndividually = true,
                    ShortDescription =
                        "",
                    FullDescription =
                        "",
                    ProductLayoutId = productLayoutSimple.Id,
                    AllowCustomerReviews = true,
                    IsShipEnabled = true,
                    Weight = 2,
                    Length = 2,
                    Width = 2,
                    Height = 3,
                    TaxCategoryId = _taxCategoryRepository.Table.Single(tc => tc.Name == "Temel Gıda Ürünleri").Id,
                    ManageInventoryMethodId = ManageInventoryMethod.ManageStock,
                    StockQuantity = 10000,
                    NotifyAdminForQuantityBelow = 1,
                    AllowOutOfStockSubscriptions = false,
                    StockAvailability = true,
                    LowStockActivityId = LowStockActivity.DisableBuyButton,
                    BackorderModeId = BackorderMode.NoBackorders,
                    OrderMinimumQuantity = 1,
                    OrderMaximumQuantity = 10000,
                    Published = true,
                    ProductCategories = {
                        new ProductCategory() {
                            CategoryId = savedCategory.Id,
                            IsFeaturedProduct = false
                        }
                    },
                    Name = subcategory.name,
                    Price = ConvertCurrencyToDouble(subcategory.price.Replace("\u20ba", "").Trim().Trim('0')
                        .Replace(",", ".")),
                    OldPrice = (ConvertCurrencyToDouble(subcategory.price.Replace("\u20ba", "").Trim().Trim('0')
                        .Replace(",", ".")) * (1 + Random.Shared.NextDouble())),
                };
                await productService.InsertProduct(product);


                if (!string.IsNullOrEmpty(subcategory.image_url))
                {
                    foreach (var image in subcategory.images)
                    {
                        try
                        {
                            var url = new Uri(image);
                            var u = url.RemoveQueryParam("width");
                            u.SetQueryParam("width", 1920);
                            var imageResponse = await httpClient.GetByteArrayAsync(u.ToString());

                            var picture = await _pictureService.InsertPicture(imageResponse,
                                getMimeTypes(subcategory.image_url),
                                _pictureService.GetPictureSeName(subcategory.name), reference: Reference.Product,
                                objectId: product.Id);

                            await productRepository.AddToSet(product.Id, x => x.ProductPictures, new ProductPicture() {
                                PictureId = picture.Id,
                                DisplayOrder = 1
                            });

                            product.ProductPictures.Add(new ProductPicture() {
                                PictureId = picture.Id,
                                DisplayOrder = subcategory.images.IndexOf(image) + 1
                            });
                        }
                        catch (Exception e)
                        {
                        }
                    }
                }

                await productService.UpdateProduct(product);

                var attributesService = serviceProvider.GetRequiredService<IProductAttributeService>();
                if (subcategory != null && subcategory.attributes.Count > 0)
                {
                    foreach (var attribute in subcategory.attributes.GroupBy(x => x.type))
                    {
                        var pAttribute = await attributesService.GetAllProductAttributes();
                        var savedAttribute = pAttribute.FirstOrDefault(x => x.Name ==
                                                                            (attribute.Key == "color"
                                                                                ? "Renk"
                                                                                : "Beden"));
                        if (savedAttribute == null)
                        {
                            var productAttribute = new ProductAttribute {
                                Name = attribute.Key == "color" ? "Renk" : "Beden",
                                SeName = attribute.Key == "color" ? "renk" : "beden",
                                Description = attribute.Key == "color"
                                    ? "Renk Seçeneklerinden birini seçiniz!"
                                    : "Lütfen bedeninizi seçiniz!",
                            };
                            await attributesService.InsertProductAttribute(productAttribute);
                            savedAttribute = productAttribute;
                        }

                        var attributeMapping = new ProductAttributeMapping {
                            ProductAttributeId = savedAttribute.Id,
                            TextPrompt = attribute.Key == "color" ? "Renk Seçiniz" : "Beden Seçiniz",
                            IsRequired = true,
                            AttributeControlTypeId = attribute.Key == "color"
                                ? AttributeControlType.ColorSquares
                                : AttributeControlType.RadioList,
                            DisplayOrder = 1,
                        };

                        await attributesService.InsertProductAttributeMapping(attributeMapping, product.Id);

                        foreach (var attrValue in attribute.ToList())
                        {
                            if (attribute.Key == "color")
                            {
                                var productAttributeValue = new ProductAttributeValue {
                                    AttributeValueTypeId = AttributeValueType.Simple,
                                    Name = GetColor(attrValue.value).ToString(),
                                    ColorSquaresRgb = attrValue.value,
                                    PriceAdjustment = 0,
                                    WeightAdjustment = 0,
                                    Cost = 0,
                                    Quantity = 0,
                                    IsPreSelected = false,
                                    DisplayOrder = 1,
                                };

                                await attributesService.InsertProductAttributeValue(productAttributeValue,
                                    product.Id,
                                    attributeMapping.Id);
                            }
                            else
                            {
                                var productAttributeValue = new ProductAttributeValue {
                                    AttributeValueTypeId = AttributeValueType.Simple,
                                    Name = attrValue.value,
                                    PriceAdjustment = 0,
                                    WeightAdjustment = 0,
                                    Cost = 0,
                                    Quantity = 0,
                                    IsPreSelected = false,
                                    DisplayOrder = 1,
                                };

                                await attributesService.InsertProductAttributeValue(productAttributeValue,
                                    product.Id,
                                    attributeMapping.Id);
                            }
                        }
                    }
                }
            }
            else
            {
                var savedSubCategory = await _categoryRepository.GetOneAsync(x => x.Name == subcategory.name);
                if (savedSubCategory == null)
                {
                    var subCategoryEntity = new Category {
                        Name = subcategory.name,
                        ParentCategoryId = savedCategory.Id,
                        Published = true,
                        DefaultSort = 0,
                        AllowCustomersToSelectPageSize = true,
                        PageSizeOptions = "6,3,9,18,20"
                    };

                    await _categoryService.InsertCategory(subCategoryEntity);

                    savedSubCategory = subCategoryEntity;
                }
                // else if (!savedCategory.Published || savedCategory.DefaultSort != 0)
                // {
                //     savedCategory.Published = true;
                //     savedCategory.DefaultSort = 0;
                //     await _categoryRepository.UpdateAsync(savedCategory);
                // }

                List<JsonProduct> products = new List<JsonProduct>();
                if (subcategory.subCategories is { Count: > 0 })
                {
                    products = subcategory.subCategories;
                }

                if (subcategory.products is { Count: > 0 })
                {
                    products = subcategory.products;
                }

                await AddSubCategoriesWithProducts(serviceProvider, products.Select(x => new Subcategory() {
                    name = x.name,
                    products = x.products,
                    subCategories = (x.subcategories ?? []).Select(xx => new JsonProduct {
                        id = xx.id,
                        name = xx.name,
                        image_url = xx.image_url,
                        images = xx.images,
                        products = xx.products,
                        subcategories =
                            JsonSerializer.Deserialize<List<Subcategory>>(JsonSerializer.Serialize(xx.subCategories)),
                        price = xx.price,
                    }).ToList(),
                    price = x.price,
                    image_url = x.image_url,
                    images = x.images,
                    attributes = x.attributes,
                }).ToList(), savedSubCategory);
            }
        }
    });
}

System.Drawing.Color GetSystemDrawingColorFromHexString(string hexString)
{
    if (!System.Text.RegularExpressions.Regex.IsMatch(hexString, @"[#]([0-9]|[a-f]|[A-F]){6}\b"))
        throw new ArgumentException();
    int red = int.Parse(hexString.Substring(1, 2), NumberStyles.HexNumber);
    int green = int.Parse(hexString.Substring(3, 2), NumberStyles.HexNumber);
    int blue = int.Parse(hexString.Substring(5, 2), NumberStyles.HexNumber);
    return Color.FromArgb(red, green, blue);
}

KnownColor GetColor(string colorCode)
{
    Color color = GetSystemDrawingColorFromHexString(colorCode);
    if (color.IsKnownColor)
        return color.ToKnownColor();

    return KnownColor.Beige;
}

async Task UpdateProductPictures(IServiceProvider serviceProvider, Subcategory subcategory)
{
    var _pictureService = serviceProvider.GetRequiredService<IPictureService>();
    var pictureRepository = serviceProvider.GetRequiredService<IRepository<Picture>>();
    var productRepository = serviceProvider.GetRequiredService<IRepository<Product>>();
    var httpClient = serviceProvider.GetRequiredService<IHttpClientFactory>().CreateClient();

    var product = await productRepository.Table.Where(x => x.Name == subcategory.name).ToListAsync();
    var firstProduct = product.FirstOrDefault();
    if (firstProduct == null)
    {
        return;
    }

    var savedPicture = await pictureRepository.Table.FirstOrDefaultAsync(x => x.ObjectId == firstProduct.Id);
    if (savedPicture == null)
    {
        try
        {
            var imageResponse = await httpClient.GetByteArrayAsync(subcategory.image_url);

            savedPicture = await _pictureService.InsertPicture(imageResponse, getMimeTypes(subcategory.image_url),
                _pictureService.GetPictureSeName(subcategory.name), reference: Reference.Product,
                objectId: firstProduct.Id);
            await productRepository.AddToSet(firstProduct.Id, x => x.ProductPictures, new ProductPicture() {
                PictureId = savedPicture.Id,
                DisplayOrder = 1
            });
        }
        catch (Exception e)
        {
        }
    }
    else
    {
        await _pictureService.SetSeoFilename(savedPicture, _pictureService.GetPictureSeName(subcategory.name));
        var productPictures = await pictureRepository.Table.Where(x => x.ObjectId == firstProduct.Id).ToListAsync();
        foreach (var picture in productPictures)
            await productRepository.AddToSet(firstProduct.Id, x => x.ProductPictures, new ProductPicture() {
                PictureId = picture.Id,
                DisplayOrder = 1
            });
    }
}

async Task UpdateProductPictureWithUrl(IServiceProvider serviceProvider, Product product, string imgUrl)
{
    var _pictureService = serviceProvider.GetRequiredService<IPictureService>();
    var pictureRepository = serviceProvider.GetRequiredService<IRepository<Picture>>();
    var productRepository = serviceProvider.GetRequiredService<IRepository<Product>>();
    var httpClient = serviceProvider.GetRequiredService<IHttpClientFactory>().CreateClient();
    var firstProduct = product;
    

    var savedPicture = await pictureRepository.Table.FirstOrDefaultAsync(x => x.ObjectId == firstProduct.Id);
    if (savedPicture != null)
    {
        await _pictureService.DeletePicture(savedPicture);
        savedPicture=null;
    }
    if (savedPicture == null)
    {
        try
        {
            byte[] imageResponse = [];
            if (imgUrl.StartsWith("data:image"))
            {
                var base64Data = imgUrl.Split(',')[1];
                imageResponse= Convert.FromBase64String(base64Data);
            }
            else
            {
                imageResponse = await httpClient.GetByteArrayAsync(imgUrl);
            }

            savedPicture = await _pictureService.InsertPicture(imageResponse, getMimeTypes(imgUrl),
                _pictureService.GetPictureSeName(product.Name), reference: Reference.Product,
                objectId: firstProduct.Id);
            await productRepository.AddToSet(firstProduct.Id, x => x.ProductPictures, new ProductPicture() {
                PictureId = savedPicture.Id,
                DisplayOrder = 1
            });
        }
        catch (Exception e)
        {
        }
    }
    else
    {
        await _pictureService.SetSeoFilename(savedPicture, _pictureService.GetPictureSeName(product.Name));
        var productPictures = await pictureRepository.Table.Where(x => x.ObjectId == firstProduct.Id).ToListAsync();
        foreach (var picture in productPictures)
            await productRepository.AddToSet(firstProduct.Id, x => x.ProductPictures, new ProductPicture() {
                PictureId = picture.Id,
                DisplayOrder = 1
            });
    }
}

string getMimeTypes(string image_url)
{
    var extension = Path.GetExtension(image_url);
    switch (extension)
    {
        case ".jpg":
        case ".jpeg":
            return "image/jpeg";
        case ".png":
            return "image/png";
        case ".gif":
            return "image/gif";
        case ".bmp":
            return "image/bmp";
        case ".tiff":
            return "image/tiff";
        default:
            return "image/jpeg";
    }
}

double ConvertCurrencyToDouble(string currency)
{
    if (string.IsNullOrWhiteSpace(currency))
    {
        throw new ArgumentException("Invalid currency format", nameof(currency));
    }

    // var normallizeCurrency = currency.Replace(".", "").Replace(",", ".");
    var normallizeCurrency = currency;

    var parts = normallizeCurrency.Split(' ');
    if (parts.Length != 2)
    {
        return double.Parse(normallizeCurrency);
    }

    if (parts.Length != 2 || !double.TryParse(parts[0], out double result))
    {
        throw new ArgumentException("Invalid currency format", nameof(currency));
    }

    return result;
}

// Root myDeserializedClass = JsonSerializer.Deserialize<Root>(myJsonResponse);
public class JsonCategory
{
    [JsonPropertyName("id")] public string id { get; set; }

    [JsonPropertyName("name")] public string name { get; set; }

    [JsonPropertyName("image_url")] public string image_url { get; set; }

    [JsonPropertyName("subcategories")] public List<Subcategory> subcategories { get; set; } = new List<Subcategory>();
    [JsonPropertyName("products")] public List<JsonProduct> products { get; set; } = new List<JsonProduct>();
}

public class JsonProduct
{
    [JsonPropertyName("id")] public string id { get; set; }

    [JsonPropertyName("name")] public string name { get; set; }

    [JsonPropertyName("image_url")] public string image_url { get; set; }

    [JsonPropertyName("images")] public List<string> images { get; set; } = new List<string>();

    [JsonPropertyName("attributes")] public List<Attribute> attributes { get; set; }
    [JsonPropertyName("products")] public List<JsonProduct> products { get; set; } = new List<JsonProduct>();

    [JsonPropertyName("subcategories")] public List<Subcategory>? subcategories { get; set; } = new List<Subcategory>();

    [JsonPropertyName("price")] public string price { get; set; }
}

public class Attribute
{
    [JsonPropertyName("type")] public string type { get; set; }

    [JsonPropertyName("value")] public string value { get; set; }
}

public class Root
{
    [JsonPropertyName("scrape_date")] public DateTime scrape_date { get; set; }

    [JsonPropertyName("categories")] public List<JsonCategory> categories { get; set; }
}

public class Subcategory
{
    [JsonPropertyName("id")] public string id { get; set; }
    [JsonPropertyName("name")] public string name { get; set; }

    [JsonPropertyName("url")] public string url { get; set; }

    [JsonPropertyName("price")] public string price { get; set; }

    [JsonPropertyName("image_url")] public string image_url { get; set; }

    [JsonPropertyName("images")] public List<string> images { get; set; } = new List<string>();

    [JsonPropertyName("attributes")] public List<Attribute> attributes { get; set; }

    [JsonPropertyName("products")] public List<JsonProduct> products { get; set; }

    [JsonPropertyName("subcategories")] public List<JsonProduct> subCategories { get; set; }
}


public class KeycloakSettings
{
    public string Authority { get; set; }
    public string Realm { get; set; }
    public string ClientId { get; set; }
    public string ClientSecret { get; set; }
}

//
// public interface IScopedServiceProvider<T> where T : class
// {
//     IServiceScope CreateScopeWithReplacement(T replacement);
// }
//
// public class ScopedServiceProvider<T> : IScopedServiceProvider<T> where T : class
// {
//     private readonly IServiceProvider _serviceProvider;
//     private readonly IServiceCollection _serviceCollection;
//
//     public ScopedServiceProvider(
//         IServiceProvider serviceProvider,
//         IServiceCollection serviceCollection)
//     {
//         _serviceProvider = serviceProvider;
//         _serviceCollection = serviceCollection;
//     }
//
//     public IServiceScope CreateScopeWithReplacement(T replacement)
//     {
//         // Yeni bir service collection oluştur
//         var scopedServices = new ServiceCollection();
//
//         // Mevcut servisleri kopyala
//         foreach (var service in _serviceCollection)
//         {
//             if (service.ServiceType.IsAssignableTo(typeof(IHostedService)) || (service.ServiceType.Namespace?.StartsWith("Hangfire", StringComparison.InvariantCultureIgnoreCase) ?? false))
//             {
//                 continue;
//             }
//             scopedServices.Add(service);
//         }
//
//         // Değiştirilecek servisi bul ve güncelle
//         var serviceType = typeof(T);
//         var existingDescriptor = scopedServices.FirstOrDefault(d => serviceType.IsAssignableTo(d.ServiceType));
//         if (existingDescriptor != null)
//         {
//             scopedServices.Remove(existingDescriptor);
//             scopedServices.AddScoped(existingDescriptor.ServiceType, _ => replacement);
//         }
//
//         // Yeni service provider oluştur
//         var scopedProvider = scopedServices.BuildServiceProvider();
//
//         // Scope'u oluştur
//         return scopedProvider.CreateScope();
//     }
// }
//
// // Extension method for easy registration
// public static class ServiceCollectionExtensions
// {
//     public static IServiceCollection AddScopedServiceProvider<T>(
//         this IServiceCollection services) where T : class
//     {
//         services.AddSingleton<IScopedServiceProvider<T>>(sp =>
//             new ScopedServiceProvider<T>(sp, services));
//         return services;
//     }
// }