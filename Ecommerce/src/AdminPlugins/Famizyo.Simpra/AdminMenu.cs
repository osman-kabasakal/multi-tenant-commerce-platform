using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Utilities.Common.Security;
using Grand.Web.Common.Menu;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;

namespace Famizyo.Simpra;

public class AdminMenu : IAdminMenuProvider
{
    public string ConfigurationUrl { get; }
    public string SystemName { get; }
    public string FriendlyName { get; }
    public int Priority => 100;
    public IList<string> LimitedToStores { get; }
    public IList<string> LimitedToGroups { get; }
    public Task ManageSiteMap(SiteMapNode rootNode)
    {
        var entegrasyonlarNode = rootNode.ChildNodes.FirstOrDefault(x => x.SystemName == "Entegrasyonlar");
        if (entegrasyonlarNode == null)
        {
            entegrasyonlarNode = new SiteMapNode
            {
                SystemName = "Entegrasyonlar",
                ResourceName = "Entegrasyonlar",
                Visible = true,
                IconClass = "fa fa-plug",
            };
            rootNode.ChildNodes.Add(entegrasyonlarNode);
        }
        
        var trendyolIntegrationCode = new SiteMapNode
        {
            SystemName = SimpraDefaults.ProviderSystemName + ".menu",
            ResourceName = SimpraDefaults.SimpraIntegrationFriendlyName,
            Url = ConfigurationUrl,
            IconClass = "fa fa-globe text-warning",
            Visible = true,
            ControllerName = "Simpra",
            ActionName = "Configure",
            PermissionNames = [PermissionSystemName.Products],
            AllPermissions = false,
        };

        entegrasyonlarNode.ChildNodes.Add(trendyolIntegrationCode);

        return Task.CompletedTask;
    }

    public bool Authenticate(HttpContext context)
    {
        var permissionService = context.RequestServices.GetRequiredService<IPermissionService>();
        return permissionService.Authorize(StandardPermission.ManageProducts).Result;
    }
}