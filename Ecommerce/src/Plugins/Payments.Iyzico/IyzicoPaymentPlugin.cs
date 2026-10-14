using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Infrastructure.ModelBinding;
using Grand.Infrastructure.Plugins;
using Payments.Iyzico.Models;
using System.ComponentModel.DataAnnotations;
using System.Reflection;

namespace Payments.Iyzico;

public class IyzicoPaymentPlugin : BasePlugin, IPlugin
{
    private ISettingService _settingService;
    private ITranslationService _translationService;
    private ILanguageService _languageService;
    #region Ctor

    public IyzicoPaymentPlugin(
        ISettingService settingService,
        ILanguageService languageService,
        ITranslationService translationService)
    {
        _settingService = settingService;
        _translationService = translationService;
        _languageService = languageService;
    }

    #endregion

    public override string ConfigurationUrl()
    {
        return IyzicoDefaults.ConfigurationUrl;
    }

    public override async Task Install()
    {
        var setting = new IyzicoPaymentSettings {
            PublicKey = "",
            PrivateKey = "",

        };

        await _settingService.SaveSetting(setting);

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Plugins.Payments.Iyzico.Description", "Iyzico ile taksit seçenekleri ile beraber hızlı, pratik ve güvenli çevrimiçi ödeme.");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, IyzicoDefaults.FriendlyName, "Iyzico online ödeme.");

        await UpdateOrDeleteResources();

        await base.Install();

    }

    public override async Task Uninstall()
    {
        await _settingService.DeleteSetting<IyzicoPaymentSettings>();
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Plugins.Payments.Iyzico.Description");

        await UpdateOrDeleteResources(true);

        await base.Uninstall();
    }

    private async Task UpdateOrDeleteResources(bool delete = false)
    {

        var requiredResources = typeof(ConfigurationModel);
        var props = requiredResources.GetProperties();
        foreach (var prop in props)
        {
            var resourceAttribute = prop.GetCustomAttribute<GrandResourceDisplayNameAttribute>();
            var displayAttribute = prop.GetCustomAttribute<DisplayAttribute>();
            if (resourceAttribute != null && displayAttribute != null)
            {
                if (!delete)
                    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, resourceAttribute.ResourceKey, displayAttribute.Name);
                else
                    await this.DeletePluginTranslationResource(_translationService, _languageService, resourceAttribute.ResourceKey);

                if (displayAttribute.Description != null)
                {
                    if (!delete)
                        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, resourceAttribute.ResourceKey + ".Description", displayAttribute.Description);
                    else
                        await this.DeletePluginTranslationResource(_translationService, _languageService, resourceAttribute.ResourceKey + ".Description");
                }
            }
        }
    }
}
