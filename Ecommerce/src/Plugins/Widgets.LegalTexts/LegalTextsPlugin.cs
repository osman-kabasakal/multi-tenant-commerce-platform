using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Infrastructure.Plugins;

namespace Widgets.LegalTexts;

public class LegalTextsPlugin : BasePlugin, IPlugin
{
    private readonly ITranslationService translationService;
    private readonly ILanguageService languageService;
    private readonly ISettingService _settingService;

    public LegalTextsPlugin(
        ITranslationService translationService,
        ILanguageService languageService,
        ISettingService settingService)
    {
        this.translationService = translationService;
        this.languageService = languageService;
        _settingService = settingService;
    }

    override public string ConfigurationUrl()
    {
        return "/Admin/ContractManagement/Index";
    }

    public override async Task Install()
    {

        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Category", "Kategorisi");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Name", "Şablon İsmi");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.IsActive", "Aktif mi");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.IsRequired", "Gerekli mi");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.AllowedTokens", "Şablon için izin verilen belirteçler");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.List.Title", "Yasal metin şablonu listesi");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Title", "Yasal Metin Şablonları");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.EditMessageTemplateDetails", "Yasal mentin şablonunu düzenleme");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.AddNew.Title", "Yeni yasal metin mesaj şablonu ekle");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.BackToList", "Lİsteye geri dön");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "Widgets.LegalTexts", "E-ticaret siteleri için yasal metin yöneticisi");

        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Body", "Şablon");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "legaltexts.plugin.legaltextmessagetemplate.allowedtokens", "Şablon için izin verilen belirteçler");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "legaltexts.plugin.legaltextmessagetemplate.fields.order", "Gösterim Sırası");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderConfirmation", "Sipariş Onay sayfası");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderCancellation", "Sipariş İptal Sayfası");
        await this.AddOrUpdatePluginTranslateResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.ReturnRequest", "Sipariş/ ürün iade sayfası");

        await base.Install();
    }

    public override async Task Uninstall()
    {
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Category");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Name");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.IsActive");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.IsRequired");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.AllowedTokens");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.List.Title");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Title");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.EditMessageTemplateDetails");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.AddNew.Title");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.BackToList");
        await this.DeletePluginTranslationResource(translationService, languageService, "Widgets.LegalTexts");

        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Body");
        await this.DeletePluginTranslationResource(translationService, languageService, "legaltexts.plugin.legaltextmessagetemplate.allowedtokens");
        await this.DeletePluginTranslationResource(translationService, languageService, "legaltexts.plugin.legaltextmessagetemplate.fields.order");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderConfirmation");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderCancellation");
        await this.DeletePluginTranslationResource(translationService, languageService, "LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.ReturnRequest");

        await base.Uninstall();
    }
}
