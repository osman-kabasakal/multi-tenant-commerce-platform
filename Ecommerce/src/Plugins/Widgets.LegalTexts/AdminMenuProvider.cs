using Grand.Business.Core.Utilities.Common.Security;
using Grand.Web.Common.Menu;
using System;

namespace Widgets.LegalTexts;

public class AdminMenuProvider : IAdminMenuProvider
{
    public string ConfigurationUrl => "/Admin/ContractManagement/Index";

    public string SystemName => LegalTextDefaults.LegalTextsSystemName;

    public string FriendlyName => LegalTextDefaults.LegalTextsSystemName;

    public int Priority => 100;

    public IList<string> LimitedToStores => [];

    public IList<string> LimitedToGroups => [];

    public Task ManageSiteMap(SiteMapNode rootNode)
    {
        var legalTextNode = new SiteMapNode {
            SystemName = LegalTextDefaults.LegalTextsSystemName,
            ResourceName = "LegalTexts.Plugin.LegalTextMessageTemplate.Title",
            Url = ConfigurationUrl,
            IconClass = "icon-briefcase",
            Visible = true,
            ControllerName = "ContractManagement",
            ActionName = "Index",
            PermissionNames = [PermissionSystemName.CheckoutAttributes, PermissionSystemName.MessageTemplates],
            AllPermissions = false,
        };
        try
        {
            var contentNode = rootNode.ChildNodes.FirstOrDefault(x => x.SystemName == "Content");
            if (contentNode == null)
            {
                rootNode.ChildNodes.Add(legalTextNode);
                return Task.CompletedTask;
            }
            else
            {
                var index = contentNode.ChildNodes.IndexOf(contentNode.ChildNodes.FirstOrDefault(x => x.SystemName == "Message templates") ?? new SiteMapNode());
                rootNode.ChildNodes.First(x => x.SystemName == "Content").ChildNodes.Insert(index < 0 ? contentNode.ChildNodes.Count : index, legalTextNode);
            }
        }
        catch (System.Exception)
        {
            rootNode.ChildNodes.Add(legalTextNode);
        }
        return Task.CompletedTask;
    }
}
