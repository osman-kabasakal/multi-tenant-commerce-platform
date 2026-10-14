using Grand.Business.Core.Utilities.Common.Security;
using Grand.Web.Common.Menu;

namespace Famizyo.TrendyolIntegration;

public class AdminMenu: IAdminMenuProvider
{
    public string ConfigurationUrl => "/Admin/TrendyolIntegration/Configure";
    public string SystemName => TrendyolIntegrationDefaults.ProviderSystemName;
    public string FriendlyName => TrendyolIntegrationDefaults.TrendyolIntegrationFriendlyName;
    public int Priority => 5;
    public IList<string> LimitedToStores => [];
    public IList<string> LimitedToGroups => [];
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
            SystemName = TrendyolIntegrationDefaults.ProviderSystemName + ".menu",
            ResourceName = TrendyolIntegrationDefaults.TrendyolIntegrationFriendlyName,
            Url = ConfigurationUrl,
            IconClass = "fa fa-globe text-warning",
            Visible = true,
            ControllerName = "TrendyolIntegration",
            ActionName = "Configure",
            PermissionNames = [PermissionSystemName.Products],
            AllPermissions = false,
        };

        entegrasyonlarNode.ChildNodes.Add(trendyolIntegrationCode);

        return Task.CompletedTask;
    }
}