using Grand.Business.Core.Enums.Checkout;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Checkout.Payments;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Core.Utilities.Checkout;
using Grand.Domain.Common;
using Grand.Domain.Customers;
using Grand.Domain.Orders;
using Grand.Domain.Payments;
using Grand.Infrastructure;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Payments.Iyzico.Services;

namespace Payments.Iyzico;

public class IyzicoPaymentProvider : IPaymentProvider
{
    private readonly ITranslationService _translationService;
    private readonly ICustomerService _customerService;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IyzicoPaymentSettings _iyzicoPaymentSettings;
    private readonly IUserFieldService _userFieldService;
    private readonly ICountryService _countryService;
    private readonly IWorkContext _workContext;
    private readonly ICurrencyService _currencyService;
    private IIyzicoPayService _iyzicoPayService;
    private IPaymentTransactionService _paymentTransactionService;

    public IyzicoPaymentProvider(
        ITranslationService translationService,
        ICustomerService customerService,
        IHttpContextAccessor httpContextAccessor,
        IyzicoPaymentSettings iyzicoPaymentSettings,
        IUserFieldService userFieldService,
        ICountryService countryService,
        IWorkContext workContext,
        ICurrencyService currencyService,
        IIyzicoPayService iyzicoPayService,
        IPaymentTransactionService paymentTransactionService
    )
    {
        _translationService = translationService;
        _customerService = customerService;
        _httpContextAccessor = httpContextAccessor;
        _iyzicoPaymentSettings = iyzicoPaymentSettings;
        _userFieldService = userFieldService;
        _countryService = countryService;
        _workContext = workContext;
        _currencyService = currencyService;
        _iyzicoPayService = iyzicoPayService;
        _paymentTransactionService = paymentTransactionService;
    }
    string? scopePorcessPaymenTransactionId = null;
    public async Task CancelPayment(PaymentTransaction paymentTransaction)
    {
        await _iyzicoPayService.Void(paymentTransaction);
        return;
    }

    public Task<bool> CanRePostRedirectPayment(PaymentTransaction paymentTransaction)
    {
        return Task.FromResult(false);
    }

    public Task<CapturePaymentResult> Capture(PaymentTransaction paymentTransaction)
    {
        return Task.FromResult(new CapturePaymentResult());
    }

    public Task<string> Description()
    {
        return Task.FromResult(_translationService.GetResource("Plugins.Payments.Iyzico.Description"));
    }

    public async Task<double> GetAdditionalHandlingFee(IList<ShoppingCartItem> cart)
    {
       if (_iyzicoPaymentSettings.AdditionalFee <= 0)
            return _iyzicoPaymentSettings.AdditionalFee;

        double result;
        if (_iyzicoPaymentSettings.AdditionalFeePercentage)
        {
            //percentage
            var orderTotalCalculationService = _httpContextAccessor.HttpContext!.RequestServices
                .GetRequiredService<IOrderCalculationService>();
            var subtotal = await orderTotalCalculationService.GetShoppingCartSubTotal(cart, true);
            result = (float)subtotal.subTotalWithDiscount *
                (float)_iyzicoPaymentSettings.AdditionalFee / 100f;
        }
        else
        {
            //fixed value
            result = _iyzicoPaymentSettings.AdditionalFee;
        }

        if (!(result > 0)) return await Task.FromResult(result);
        var currencyService = _httpContextAccessor.HttpContext!.RequestServices.GetRequiredService<ICurrencyService>();
        var workContext = _httpContextAccessor.HttpContext!.RequestServices.GetRequiredService<IWorkContext>();
        result = await currencyService.ConvertFromPrimaryStoreCurrency(result, workContext.WorkingCurrency);

        //return result;
        return await Task.FromResult(result);
    }

    public Task<string> GetControllerRouteName()
    {
        return Task.FromResult(IyzicoDefaults.PaymentInfoRouteName);
    }

    public Task<bool> HidePaymentMethod(IList<ShoppingCartItem> cart)
    {
        return Task.FromResult(false);
    }

    public Task<PaymentTransaction> InitPaymentTransaction()
    {
        return Task.FromResult(new PaymentTransaction());
    }

    public Task PostProcessPayment(PaymentTransaction paymentTransaction)
    {
        scopePorcessPaymenTransactionId = paymentTransaction.Id;
        return Task.CompletedTask;
    }

    public Task PostRedirectPayment(PaymentTransaction paymentTransaction)
    {
        scopePorcessPaymenTransactionId = paymentTransaction.Id;
        return _iyzicoPayService.ProcessThreeDsPayment(paymentTransaction);
    }

    public async Task<ProcessPaymentResult> ProcessPayment(PaymentTransaction paymentTransaction)
    {
        scopePorcessPaymenTransactionId = paymentTransaction.Id;
        return await _iyzicoPayService.ProcessPayment(paymentTransaction);
    }

    public Task<RefundPaymentResult> Refund(RefundPaymentRequest refundPaymentRequest)
    {
        return _iyzicoPayService.Refund(refundPaymentRequest);
    }

    public Task<PaymentTransaction> SavePaymentInfo(IDictionary<string, string> model)
    {
        return _iyzicoPayService.SavePaymentInfo(model);
    }

    public Task<bool> SkipPaymentInfo()
    {
        return Task.FromResult(false);
    }

    public Task<bool> SupportCapture()
    {
        return Task.FromResult(false);
    }

    public Task<bool> SupportPartiallyRefund()
    {
        return Task.FromResult(true);
    }

    public Task<bool> SupportRefund()
    {
        return Task.FromResult(true);
    }

    public Task<bool> SupportVoid()
    {
        return Task.FromResult(false);
    }

    public Task<IList<string>> ValidatePaymentForm(IDictionary<string, string> model)
    {
        return _iyzicoPayService.ValidatePaymentForm(model);
    }

    public Task<VoidPaymentResult> Void(PaymentTransaction paymentTransaction)
    {
        return _iyzicoPayService.Void(paymentTransaction);
    }

    public PaymentMethodType PaymentMethodType {
        get {
            var paymentTransactionId = _workContext.CurrentCustomer.GetUserField<string>(_userFieldService,SystemCustomerFieldNames.PaymentTransaction,
                    _workContext.CurrentStore.Id).GetAwaiter().GetResult()??scopePorcessPaymenTransactionId;
            if (!string.IsNullOrEmpty(paymentTransactionId))
            {
                var transaction = _paymentTransactionService.GetById(paymentTransactionId).ConfigureAwait(false).GetAwaiter().GetResult();
                if (transaction != null && transaction.CustomValues.ContainsKey("use3d") && ((transaction.CustomValues["use3d"] as bool?) ?? false))
                {
                    return PaymentMethodType.Redirection;
                }
            }else if((_httpContextAccessor.HttpContext?.Request.Path.Value.Contains("CompleteRedirectionPayment", StringComparison.InvariantCultureIgnoreCase)??false) && 
            _httpContextAccessor.HttpContext!.Request.Query.TryGetValue("paymentTransactionId", out var paymentTransactionIdValue)
            ){
                var transaction = _paymentTransactionService.GetById(paymentTransactionIdValue).ConfigureAwait(false).GetAwaiter().GetResult();
                if (transaction != null && transaction.CustomValues.ContainsKey("use3d") && ((transaction.CustomValues["use3d"] as bool?) ?? false))
                {
                    return PaymentMethodType.Redirection;
                }
            }

            return PaymentMethodType.Standard;
        }
    }

    public string LogoURL => "/Plugins/Payments.Iyzico/logo.jpg";

    public string ConfigurationUrl => IyzicoDefaults.ConfigurationUrl;

    public string SystemName => IyzicoDefaults.ProviderSystemName;

    public string FriendlyName => _translationService.GetResource(IyzicoDefaults.FriendlyName);

    public int Priority => 0;

    public IList<string> LimitedToStores => new List<String>();

    public IList<string> LimitedToGroups => new List<String>();
}
