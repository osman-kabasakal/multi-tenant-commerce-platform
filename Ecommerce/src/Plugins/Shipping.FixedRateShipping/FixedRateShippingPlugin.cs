using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Infrastructure.Plugins;

namespace Shipping.FixedRateShipping;

/// <summary>
///     Fixed rate shipping computation method
/// </summary>
public class FixedRateShippingPlugin : BasePlugin, IPlugin
{
    #region Ctor

    public FixedRateShippingPlugin(
        ITranslationService translationService,
        ILanguageService languageService)
    {
        _translationService = translationService;
        _languageService = languageService;
    }

    #endregion

    #region Fields

    private readonly ITranslationService _translationService;
    private readonly ILanguageService _languageService;

    #endregion

    #region Methods

    /// <summary>
    ///     Install plugin
    /// </summary>
    public override async Task Install()
    {
        //locales
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Shipping.FixedRate.FriendlyName", "Shipping fixed rate");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.Fields.ShippingMethodName", "Shipping method");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.Fields.Rate", "Rate");

        // Delivery area resources - English
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryAreas", "Delivery Areas");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Add", "Add New Delivery Area");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Edit", "Edit Delivery Area");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.Name", "Name");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.ShippingRate", "Shipping Rate");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.MinimumOrderAmount", "Minimum Order Amount");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.GeoJsonData", "GeoJSON Data");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.GeoJsonData.Hint", "Enter the GeoJSON polygon data for this delivery area. This data defines the boundaries of the delivery area.");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.MinimumOrderAmountNotReached", "The minimum order amount ({0}) for delivery to your location has not been reached.");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.Fields.ShippingMethods", "Shipping Methods");
        
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryAreaNotFound", "{0} method is not within our delivery area!");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.UseFreeShipping", "Use Free Shipping");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.FreeShippingOrderAmount", "Free Shipping Order Amount");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.FreeShippingOrderAmountNotReached", "The free shipping order amount ({0}) for delivery to your location has not been reached.");
        
        //Turkish translations
        var turkish = await _languageService.GetLanguageByCode("tr");
        if (turkish != null)
        {
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Shipping.FixedRate.FriendlyName", "Sabit fiyatlı Gönderi", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.Fields.ShippingMethodName", "Kargo yöntemi", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.Fields.Rate", "Ücret", languageCulture: turkish.LanguageCulture);

            // Delivery area resources - Turkish
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.DeliveryAreas", "Teslimat Alanları", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.DeliveryArea.Add", "Yeni Teslimat Alanı Ekle", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.DeliveryArea.Edit", "Teslimat Alanı Düzenle", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.Name", "Ad", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.ShippingRate", "Kargo Ücreti", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.MinimumOrderAmount", "Minimum Sipariş Tutarı", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.GeoJsonData", "GeoJSON Verisi", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.GeoJsonData.Hint", "Bu teslimat alanı için GeoJSON çokgen verisini girin. Bu veri, teslimat alanının sınırlarını tanımlar.", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.MinimumOrderAmountNotReached", "Konumunuza teslimat için minimum sipariş tutarına ({0}) ulaşılmadı.", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.Fields.ShippingMethods", "Kargo Yöntemleri", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.DeliveryAreaNotFound", "{0} yöntemi teslimat bölgemiz içerisinde değildir!", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.UseFreeShipping", "Ücretsiz Kargo Kullan", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.FreeShippingOrderAmount", "Ücretsiz Kargo Sipariş Tutarı", languageCulture: turkish.LanguageCulture);
            await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
                "Plugins.Shipping.FixedRateShipping.FreeShippingOrderAmountNotReached", "Ücretsiz kargo için sepetinize {0}'lik ürün eklemeniz gerekmektedir.", languageCulture: turkish.LanguageCulture);
            
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
            "Plugins.Shipping.FixedRateShipping.Fields.ShippingMethodName");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.Fields.Rate");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Shipping.FixedRate.FriendlyName");
            
        // Delete delivery area resources
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryAreas");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Add");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Edit");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.Name");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.ShippingRate");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.MinimumOrderAmount");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.GeoJsonData");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.GeoJsonData.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.MinimumOrderAmountNotReached");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.Fields.ShippingMethods");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryAreaNotFound");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.UseFreeShipping");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.FreeShippingOrderAmount");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Shipping.FixedRateShipping.FreeShippingOrderAmountNotReached");

        await base.Uninstall();
    }

    #endregion
}

