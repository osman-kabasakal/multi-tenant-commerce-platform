using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Infrastructure.Plugins;

namespace Tax.FixedRate;

/// <summary>
///     Fixed rate tax provider
/// </summary>
public class FixedRateTaxPlugin : BasePlugin, IPlugin
{
    private readonly ILanguageService _languageService;
    private readonly ITranslationService _translationService;

    public FixedRateTaxPlugin(ITranslationService translationService, ILanguageService languageService)
    {
        _translationService = translationService;
        _languageService = languageService;
    }


    /// <summary>
    ///     Gets a configuration page URL
    /// </summary>
    public override string ConfigurationUrl()
    {
        return FixedRateTaxDefaults.ConfigurationUrl;
    }

    public override async Task Install()
    {
        //locales in English
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Tax.FixedRate.FriendlyName", "Tax by fixed rate");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.FixedRate.Fields.TaxCategoryName", "Tax category");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.FixedRate.Fields.Rate", "Rate");
    
        //Turkish translations
        var turkish = await _languageService.GetLanguageByCode("tr");
        if (turkish != null)
        {
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Tax.FixedRate.FriendlyName", "Sabit oranlı vergi", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Tax.FixedRate.Fields.TaxCategoryName", "Vergi kategorisi", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Tax.FixedRate.Fields.Rate", "Oran", languageCulture: turkish.LanguageCulture);
        }

        await base.Install();
    }

    /// <summary>
    ///     Uninstall plugin
    /// </summary>
    public override async Task Uninstall()
    {
        //locales
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.FixedRate.Fields.TaxCategoryName");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.FixedRate.Fields.Rate");

        await base.Uninstall();
    }
}