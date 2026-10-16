using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Data;
using Grand.Domain.Media;
using Grand.Domain.Tenants;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.MultiTenant;
using Grand.Web.MultiTenant.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Primitives;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using System.Text.Json;

namespace Grand.Web.MultiTenant.MiddleWares;

public class DeepLinksMiddleWare
{
    private readonly RequestDelegate _next;
    public DeepLinksMiddleWare(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context,
        ICacheBase cacheBase,
        ILogger<DeepLinksMiddleWare> logger,
        ITenantScopedServiceProvider<IMongoDatabase> tenantScopedServiceProvider
    )
    {
        var path = context.Request.Path.Value?.ToLower();
        if (path != null && (path.StartsWith("/.well-known/apple-app-site-association") ||
                             path.StartsWith("/.well-known/assetlinks.json")))
        {
            var keycloakSettings = context.RequestServices.GetRequiredService<KeycloakSettings>();
            var keycloakService = context.RequestServices.GetRequiredService<IKeycloakClientService>();
            var keycloakClient = keycloakService.GetKeycloakClientAsync();
            var groups = await cacheBase.GetAsync("groups", async () =>
            {
                //TODO: bu listeyi tenant managerdan çekmem lazım
                return await keycloakClient.GetGroupHierarchyAsync(keycloakSettings.Realm);
            });
            var host= context.Request.Host.Host.ToLower();
            if (string.IsNullOrEmpty(host))
            {
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                await context.Response.WriteAsJsonAsync(new { error = "x-store-token header is required" });
                return;
            }
            
            var groupName = host.Split(".").FirstOrDefault();
            var tenantGroup = groups.FirstOrDefault(x =>
                x.Attributes.ContainsKey("StoreMongoConnectionString") &&
                x.Attributes["StoreMongoConnectionString"].Count() > 0 && x.Name == groupName);
            if (tenantGroup == null)
            {
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                await context.Response.WriteAsJsonAsync(new { error = "x-store-token header is required" });
                return;
            }

            var tenantDb = new DataSettings() {
                ConnectionString = tenantGroup.Attributes["StoreMongoConnectionString"].First(),
                DbProvider = DbProvider.MongoDB
            };
            
            var mongourl = new MongoUrl(tenantDb.ConnectionString);
            var databaseName = mongourl.DatabaseName;
            if (string.IsNullOrEmpty(databaseName))
            {
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                await context.Response.WriteAsJsonAsync(new { error = "x-store-token header is required" });
                return;
            }
            
            try
            {
                var database = new MongoClient(tenantDb.ConnectionString).GetDatabase(databaseName);
                
                using (var scope = tenantScopedServiceProvider
                           .CreateScopeWithReplacement(database,tenantGroup.Attributes["StoreId"].FirstOrDefault()))
                {
                    var tenantIdentityAccessor = scope.ServiceProvider.GetRequiredService<ITenantIdentityAccessor>();
                    tenantIdentityAccessor.TenantId = tenantGroup.Attributes["StoreId"].FirstOrDefault();
                    var dbContext = scope.ServiceProvider.GetRequiredService<IDatabaseContext>();
                    dbContext.SetConnection(tenantDb.ConnectionString);
                    if (!await dbContext.DatabaseExist())
                    {
                        context.Response.StatusCode = StatusCodes.Status400BadRequest;
                        await context.Response.WriteAsJsonAsync(new { error = "x-store-token header is required" });
                        return;
                    }
                    
                    var downloadRepository = scope.ServiceProvider.GetRequiredService<IRepository<Download>>();
                    var fileName= Path.GetFileNameWithoutExtension(path.Substring(path.LastIndexOf("/") + 1));
                    var download = await downloadRepository.Table.FirstOrDefaultAsync(x => x.Filename==fileName && 
                        x.Extension==".json" && x.DownloadType == DownloadType.None);
                    if (download == null)
                    {
                        context.Response.StatusCode = StatusCodes.Status404NotFound;
                        await context.Response.WriteAsync("Dosya bulunamadı!");
                        return;
                    }

                    var downloadService = scope.ServiceProvider.GetRequiredService<IDownloadService>();
                    context.Response.ContentType = "application/json";
                    var jsonContent = System.Text.Encoding.UTF8.GetString(
                        (await downloadService.GetDownloadById(download.Id)).DownloadBinary);
                    var jsonType = fileName == "assetlinks" ? typeof(List<object>) : typeof(Dictionary<string, object>);
                    await context.Response.WriteAsJsonAsync(JsonSerializer.Deserialize(jsonContent,jsonType));
                    return;
                    
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, "Error during deeplink middleware");
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                await context.Response.WriteAsJsonAsync(new { error = "x-store-token header is required" });
                return;
            }
        }
        
        await _next(context);
    }
}