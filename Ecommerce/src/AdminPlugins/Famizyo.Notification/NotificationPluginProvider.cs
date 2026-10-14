using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Cms;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Domain.Cms;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Plugins;

namespace Famizyo.Notification;

public class NotificationPluginProvider: BasePlugin,IPlugin
{
    private readonly IWidgetService _widgetService;
    private readonly WidgetSettings _widgetSettings;
    private readonly ISettingService _settingService;
    private readonly ICacheBase _cacheBase;
    private readonly ITranslationService _translationService;
    private readonly ILanguageService _languageService;

    public NotificationPluginProvider(
        IWidgetService widgetService,
        WidgetSettings widgetSettings,
        ISettingService settingService,
        ICacheBase cacheBase,
        ITranslationService translationService,
        ILanguageService languageService
        )
    {
        _widgetService = widgetService;
        _widgetSettings = widgetSettings;
        _settingService = settingService;
        _cacheBase = cacheBase;
        _translationService = translationService;
        _languageService = languageService;
    }
    public override async Task Install()
    {
        if (!_widgetSettings.ActiveWidgetSystemNames.Contains(NotificationDefaults.ProviderSystemName))
        {
            _widgetSettings.ActiveWidgetSystemNames.Add(NotificationDefaults.ProviderSystemName);
            await _settingService.SaveSetting(_widgetSettings);
            await _cacheBase.Clear();
        }

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            NotificationDefaults.NotificationFriendlyName, "Sipariş Bildirim Modülü");
    }
}