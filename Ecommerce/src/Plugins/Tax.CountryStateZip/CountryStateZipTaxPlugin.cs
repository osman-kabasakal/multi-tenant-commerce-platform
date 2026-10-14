using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Infrastructure.Plugins;

namespace Tax.CountryStateZip;

/// <summary>
///     Fixed rate tax provider
/// </summary>
public class CountryStateZipTaxPlugin : BasePlugin, IPlugin
{
    private readonly ILanguageService _languageService;
    private readonly ITranslationService _translationService;

    public CountryStateZipTaxPlugin(
        ITranslationService translationService,
        ILanguageService languageService)
    {
        _translationService = translationService;
        _languageService = languageService;
    }

    /// <summary>
    ///     Gets a configuration page URL
    /// </summary>
    public override string ConfigurationUrl()
    {
        return CountryStateZipTaxDefaults.ConfigurationUrl;
    }


    /// <summary>
    ///     Install plugin
    /// </summary>
    public override async Task Install()
{
    //locales
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Tax.CountryStateZip.FriendlyName", "Tax by country and state zip");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.Store", "Store");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.Store.Hint",
        "If an asterisk is selected, then this shipping rate will apply to all stores.");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.Country", "Country");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.Country.Hint", "The country.");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.StateProvince", "State / province");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.StateProvince.Hint",
        "If an asterisk is selected, then this tax rate will apply to all customers from the given country, regardless of the state.");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.Zip", "Zip");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.Zip.Hint",
        "Zip / postal code. If zip is empty, then this tax rate will apply to all customers from the given country or state, regardless of the zip code.");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.TaxCategory", "Tax category");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.TaxCategory.Hint", "The tax category.");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.Percentage", "Percentage");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.Fields.Percentage.Hint", "The tax rate.");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.AddRecord", "Add tax rate");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Tax.CountryStateZip.AddRecord.Hint", "Adding a new tax rate");

    //Turkish translations
    var turkish = await _languageService.GetLanguageByCode("tr");
    if (turkish != null)
    {
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Tax.CountryStateZip.FriendlyName", "Ülke ve posta koduna göre vergi", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Store", "Mağaza", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Store.Hint",
            "Eğer yıldız seçiliyse, bu vergi oranı tüm mağazalara uygulanacaktır.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Country", "Ülke", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Country.Hint", "Ülke.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.StateProvince", "Eyalet / bölge", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.StateProvince.Hint",
            "Eğer yıldız seçiliyse, bu vergi oranı belirtilen ülkedeki tüm müşterilere eyalete bakılmaksızın uygulanacaktır.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Zip", "Posta kodu", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Zip.Hint",
            "Posta kodu. Eğer posta kodu boşsa, bu vergi oranı belirtilen ülke veya eyaletteki tüm müşterilere posta koduna bakılmaksızın uygulanacaktır.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.TaxCategory", "Vergi kategorisi", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.TaxCategory.Hint", "Vergi kategorisi.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Percentage", "Yüzde", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Percentage.Hint", "Vergi oranı.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.AddRecord", "Vergi oranı ekle", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.AddRecord.Hint", "Yeni vergi oranı ekleme", languageCulture: turkish.LanguageCulture);
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
            "Plugins.Tax.CountryStateZip.Fields.Store");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Store.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Country");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Country.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.StateProvince");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.StateProvince.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Zip");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Zip.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.TaxCategory");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.TaxCategory.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Percentage");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.Fields.Percentage.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.AddRecord");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Tax.CountryStateZip.AddRecord.Hint");

        await base.Uninstall();
    }
}