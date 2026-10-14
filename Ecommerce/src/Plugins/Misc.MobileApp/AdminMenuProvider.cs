using Grand.Business.Core.Utilities.Common.Security;
using Grand.Web.Common.Menu;

namespace Misc.MobileApp;

public class AdminMenuProvider:IAdminMenuProvider
{
    public string ConfigurationUrl => "/Admin/CustomerDiscountCoupon/Configure";
    public string SystemName => MobileAppDefault.ProviderSystemName;
    public string FriendlyName => MobileAppDefault.FriendlyName;
    public int Priority => 100;
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
        
        var customerDiscountCouponCode = new SiteMapNode {
            SystemName = MobileAppDefault.ProviderSystemName+".menu",
            ResourceName = MobileAppDefault.FriendlyName,
            Url = ConfigurationUrl,
            IconClass = "icon-screen-smartphone",
            Visible = true,
            ControllerName = "CustomerDiscountCoupon",
            ActionName = "Configure",
            PermissionNames = [PermissionSystemName.Customers, PermissionSystemName.CustomerAttributes],
            AllPermissions = false,
        };
        
        entegrasyonlarNode.ChildNodes.Add(customerDiscountCouponCode);
        
        return Task.CompletedTask;
    }
}