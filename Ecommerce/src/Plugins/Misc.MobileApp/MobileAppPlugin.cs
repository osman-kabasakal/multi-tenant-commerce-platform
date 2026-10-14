using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Infrastructure.Plugins;

namespace Misc.MobileApp;

public class MobileAppPlugin: BasePlugin, IPlugin
{
    private readonly ITranslationService _translationService;
    private readonly ILanguageService _languageService;

    public MobileAppPlugin(
        ITranslationService translationService,
        ILanguageService languageService)
    {
        _translationService = translationService;
        _languageService = languageService;
    }
    
    public override async Task Install()
    {
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,MobileAppDefault.FriendlyName, "Famizyo Mobile App");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,MobileAppDefault.FriendlyDescriptionName, "Famizyo Mobile App");
    }
    
    public override async Task Uninstall()
    {
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Misc.MobileApp.FriendlyName");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Misc.MobileApp.PluginDescription");
    }
}