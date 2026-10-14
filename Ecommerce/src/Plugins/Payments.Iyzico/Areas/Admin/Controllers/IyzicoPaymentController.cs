using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Utilities.Common.Security;
using Grand.Web.Common.Controllers;
using Grand.Web.Common.Filters;
using Grand.Web.Common.Security.Authorization;
using Microsoft.AspNetCore.Mvc;
using Payments.Iyzico.Models;

namespace Payments.Iyzico.Areas.Admin.Controllers
{
    [AuthorizeAdmin]
    [Area("Admin")]
    [PermissionAuthorize(PermissionSystemName.PaymentMethods)]
    public class IyzicoPaymentController : BasePaymentController
    {
        private readonly ISettingService _settingService;
        private readonly ITranslationService _translationService;
        private readonly IyzicoPaymentSettings _iyzicoPaymentSettings;

        public IyzicoPaymentController(
            ISettingService settingService,
        ITranslationService translationService,
        IyzicoPaymentSettings iyzicoPaymentSettings)
        {
            _settingService = settingService;
            _translationService = translationService;
            _iyzicoPaymentSettings = iyzicoPaymentSettings;
        }
        #region Methods

        public IActionResult Configure()
        {
            var model = new ConfigurationModel {
                UseSandbox = _iyzicoPaymentSettings.UseSandBox,
                ApiKey = _iyzicoPaymentSettings.PublicKey,
                ApiSecretKey = _iyzicoPaymentSettings.PrivateKey,
                AdditionalFee = _iyzicoPaymentSettings.AdditionalFee,
                AdditionalFeePercentage = _iyzicoPaymentSettings.AdditionalFeePercentage,
                CardStorageSupported = _iyzicoPaymentSettings.CardStorageSupported,
                Non3DSecureSupported = _iyzicoPaymentSettings.Non3DSecureSupported
            };

            return View(model);
        }

        [HttpPost]
        public async Task<IActionResult> Configure(ConfigurationModel model)
        {
            if (!ModelState.IsValid)
                return Configure();

            //save settings
            _iyzicoPaymentSettings.UseSandBox = model.UseSandbox;
            _iyzicoPaymentSettings.PublicKey = model.ApiKey;
            _iyzicoPaymentSettings.PrivateKey = model.ApiSecretKey;
            _iyzicoPaymentSettings.AdditionalFee = model.AdditionalFee;
            _iyzicoPaymentSettings.AdditionalFeePercentage = model.AdditionalFeePercentage;
            _iyzicoPaymentSettings.CardStorageSupported = model.CardStorageSupported;
            _iyzicoPaymentSettings.Non3DSecureSupported = model.Non3DSecureSupported;

            await _settingService.SaveSetting(_iyzicoPaymentSettings);

            Success(_translationService.GetResource("Admin.Plugins.Saved"));

            return Configure();
        }

        #endregion

    }
}
