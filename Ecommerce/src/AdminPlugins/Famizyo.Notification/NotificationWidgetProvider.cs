using Grand.Business.Core.Interfaces.Cms;
using Grand.Business.Core.Interfaces.Common.Localization;

namespace Famizyo.Notification;

public class NotificationWidgetProvider: IWidgetProvider
{
    private readonly ITranslationService _translationService;

    public NotificationWidgetProvider(
        ITranslationService translationService
        )
    {
        _translationService = translationService;
    }
    public string ConfigurationUrl => "../Notification/Configure";
    public string SystemName => NotificationDefaults.ProviderSystemName;
    public string FriendlyName => _translationService.GetResource(NotificationDefaults.NotificationFriendlyName);
    public int Priority => 10;
    public IList<string> LimitedToStores => new List<string>();
    public IList<string> LimitedToGroups => new List<string>() {
    };
    public Task<IList<string>> GetWidgetZones()
    {
        return Task.FromResult<IList<string>>(new List<string>() {
            "admin_header_before"
        });
    }

    public Task<string> GetPublicViewComponentName(string widgetZone)
    {
        return Task.FromResult(NotificationDefaults.NotificationWidgetName);
    }
}