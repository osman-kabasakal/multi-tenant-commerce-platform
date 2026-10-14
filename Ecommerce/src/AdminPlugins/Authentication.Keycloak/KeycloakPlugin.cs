using Grand.Business.Core.Interfaces.Cms;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Domain.Cms;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Plugins;

namespace Authentication.Keycloak;

public class KeycloakPlugin: BasePlugin, IPlugin
{
    private readonly IWidgetService _widgetService;
    private readonly WidgetSettings _widgetSettings;
    private readonly ISettingService _settingService;
    private readonly ICacheBase _cacheBase;

    public KeycloakPlugin(
        IWidgetService widgetService,
        WidgetSettings widgetSettings,
        ISettingService settingService,
        ICacheBase cacheBase
        )
    {
        _widgetService = widgetService;
        _widgetSettings = widgetSettings;
        _settingService = settingService;
        _cacheBase = cacheBase;
    }

    public override Task Install()
    {
        if (!_widgetSettings.ActiveWidgetSystemNames.Contains(KeycloakAuthenticationDefaults.ProviderSystemName))
        {
            _widgetSettings.ActiveWidgetSystemNames.Add(KeycloakAuthenticationDefaults.ProviderSystemName);
            _settingService.SaveSetting(_widgetSettings);
            _cacheBase.Clear();
        }
        return base.Install();
    }
}