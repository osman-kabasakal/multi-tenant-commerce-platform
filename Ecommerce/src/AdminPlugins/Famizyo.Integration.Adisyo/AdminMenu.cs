using Grand.Business.Core.Utilities.Common.Security;
using Grand.Web.Common.Menu;

namespace Famizyo.Integration.Adisyo;

public class AdminMenu: IAdminMenuProvider
{
    public string ConfigurationUrl => "/Admin/AdisyoIntegration/Configure";
    public string SystemName => AdisyoIntegrationDefaults.ProviderSystemName;
    public string FriendlyName => AdisyoIntegrationDefaults.FriendlyName;
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
            SystemName = AdisyoIntegrationDefaults.ProviderSystemName + ".menu",
            ResourceName = AdisyoIntegrationDefaults.FriendlyName,
            Url = ConfigurationUrl,
            IconClass = "fa fa-globe text-warning",
            Visible = true,
            ControllerName = "AdisyoIntegration",
            ActionName = "Configure",
            PermissionNames = [PermissionSystemName.Products],
            AllPermissions = false,
        };

        entegrasyonlarNode.ChildNodes.Add(trendyolIntegrationCode);

        return Task.CompletedTask;
    }
}