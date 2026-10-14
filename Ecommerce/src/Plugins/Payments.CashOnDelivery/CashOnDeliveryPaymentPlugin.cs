using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Infrastructure.Plugins;

namespace Payments.CashOnDelivery;

/// <summary>
///     CashOnDelivery payment processor
/// </summary>
public class CashOnDeliveryPaymentPlugin : BasePlugin, IPlugin
{
    #region Ctor

    public CashOnDeliveryPaymentPlugin(
        ISettingService settingService,
        ITranslationService translationService,
        ILanguageService languageService)
    {
        _settingService = settingService;
        _translationService = translationService;
        _languageService = languageService;
    }

    #endregion

    #region Fields

    private readonly ISettingService _settingService;
    private readonly ITranslationService _translationService;
    private readonly ILanguageService _languageService;

    #endregion

    #region Methods

    /// <summary>
    ///     Gets a configuration page URL
    /// </summary>
    public override string ConfigurationUrl()
    {
        return CashOnDeliveryPaymentDefaults.ConfigurationUrl;
    }

    public override async Task Install()
{
    var settings = new CashOnDeliveryPaymentSettings {
        DescriptionText =
            "<p>Sipariş verildiğinde yetkili temsilcimiz siparişi teyit etmek için şahsen veya telefonla sizinle iletişime geçecektir.<br />Sipariş onaylandıktan sonra işleme alınacaktır.<br />Onaylanan siparişler iptal edilemez.</p>"
    };
    await _settingService.SaveSetting(settings);
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Payments.CashOnDelivery.FriendlyName", "Cash on delivery");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Payment.CashOnDelivery.DescriptionText", "Description");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Payment.CashOnDelivery.DescriptionText.Hint",
        "Enter info that will be shown to customers during checkout");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Payment.CashOnDelivery.PaymentMethodDescription", "Cash On Delivery");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Payment.CashOnDelivery.AdditionalFee", "Additional fee");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Payment.CashOnDelivery.AdditionalFee.Hint", "The additional fee.");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Payment.CashOnDelivery.AdditionalFeePercentage", "Additional fee. Use percentage");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Payment.CashOnDelivery.AdditionalFeePercentage.Hint",
        "Determines whether to apply a percentage additional fee to the order total. If not enabled, a fixed value is used.");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Payment.CashOnDelivery.ShippableProductRequired", "Shippable product required");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Payment.CashOnDelivery.ShippableProductRequired.Hint",
        "An option indicating whether shippable products are required in order to display this payment method during checkout.");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Payment.CashOnDelivery.SkipPaymentInfo", "Skip payment info");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.Payment.CashOnDelivery.DisplayOrder", "Display order");

    //Turkish translations
    var turkish = await _languageService.GetLanguageByCode("tr");
    if (turkish != null)
    {
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Payments.CashOnDelivery.FriendlyName", "Kapıda ödeme (Nakit)", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Payments.CashOnDelivery.FriendlyName.CreditCard", "Kapıda ödeme (Kredi Kartı)", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.DescriptionText", "Açıklama", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.DescriptionText.Hint",
            "Ödeme sırasında müşterilere gösterilecek bilgileri girin", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.PaymentMethodDescription", "Kapıda Ödeme (Nakit)", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.PaymentMethodDescription.CreditCard", "Kapıda Ödeme (Kredi Kartı)", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.AdditionalFee", "Ek ücret", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.AdditionalFee.Hint", "Ek ücret.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.AdditionalFeePercentage", "Ek ücret. Yüzde kullan", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.AdditionalFeePercentage.Hint",
            "Sipariş toplamına yüzdelik ek ücret uygulanıp uygulanmayacağını belirler. Etkin değilse, sabit bir değer kullanılır.", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.ShippableProductRequired", "Kargolanabilir ürün gerekli", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.ShippableProductRequired.Hint",
            "Ödeme sırasında bu ödeme yöntemini görüntülemek için kargolanabilir ürünlerin gerekli olup olmadığını belirten bir seçenek.", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.SkipPaymentInfo", "Ödeme bilgilerini atla", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.DisplayOrder", "Görüntüleme sırası", 
            languageCulture: turkish.LanguageCulture);
    }

    await base.Install();
}

    public override async Task Uninstall()
    {
        //settings
        await _settingService.DeleteSetting<CashOnDeliveryPaymentSettings>();

        //locales
        //CreditCard
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.DescriptionText");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.DescriptionText.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.PaymentMethodDescription");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.AdditionalFee");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.AdditionalFee.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.AdditionalFeePercentage");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.AdditionalFeePercentage.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.ShippableProductRequired");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.ShippableProductRequired.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.Payment.CashOnDelivery.SkipPaymentInfo");

        await base.Uninstall();
    }

    #endregion
}