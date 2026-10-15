using Platform.Security;
using FluentValidation;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Checkout.Payments;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Core.Utilities.Checkout;
using Grand.Domain.Orders;
using Grand.Domain.Payments;
using Grand.Infrastructure;
using Grand.Web.ExternalSettings.TenantToken;
using Iyzipay;
using Iyzipay.Model;
using Iyzipay.Request;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Newtonsoft.Json;
using Payments.Iyzico.Builders;
using Payments.Iyzico.Utilities;
using Payments.Iyzico.Validators;
using System.Globalization;
using System.Security.Cryptography;
using System.Text.Unicode;

namespace Payments.Iyzico.Services;

public class IyzicoPayService : IIyzicoPayService
{
    private readonly Options _iyzicoOptions;
    private readonly IyzicoPaymentRequestBuilder _requestBuilder;
    private readonly ITenantTokenHandler _tenantTokenHandler;
    private readonly ITranslationService _translationService;
    private readonly ICustomerService _customerService;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IUserFieldService _userFieldService;
    private readonly ICountryService _countryService;
    private readonly IWorkContext _workContext;
    private readonly ICurrencyService _currencyService;
    private readonly ITenantEncryptionService _encryptionService;
    private readonly IShoppingCartService _shoppingCartService;
    private readonly IMediator _mediator;
    private readonly LinkGenerator _linkGenerator;
    private readonly IPaymentTransactionService _paymentTransactionService;
    private readonly IOrderService _orderService;
    private readonly IyzicoPaymentSettings _settings;

    public IyzicoPayService(
        IyzicoPaymentSettings settings,
        IyzicoPaymentRequestBuilder requestBuilder,
        ITenantTokenHandler tenantTokenHandler,
        ITranslationService translationService,
        ICustomerService customerService,
        IHttpContextAccessor httpContextAccessor,
        IUserFieldService userFieldService,
        ICountryService countryService,
        IWorkContext workContext,
        ICurrencyService currencyService,
        ITenantEncryptionService encryptionService,
        IShoppingCartService shoppingCartService,
        IMediator mediator,
        LinkGenerator linkGenerator,
        IPaymentTransactionService paymentTransactionService,
        IOrderService orderService
        )
    {
        _iyzicoOptions = new Options {
            ApiKey = settings.PublicKey,
            SecretKey = settings.PrivateKey,
            BaseUrl = settings.UseSandBox ? "https://sandbox-api.iyzipay.com" : "https://api.iyzipay.com"
        };
        _requestBuilder = requestBuilder;
        _tenantTokenHandler = tenantTokenHandler;
        _translationService = translationService;
        _customerService = customerService;
        _httpContextAccessor = httpContextAccessor;
        _userFieldService = userFieldService;
        _countryService = countryService;
        _workContext = workContext;
        _currencyService = currencyService;
        _encryptionService = encryptionService;
        _shoppingCartService = shoppingCartService;
        _mediator = mediator;
        _linkGenerator = linkGenerator;
        _paymentTransactionService = paymentTransactionService;
        _orderService = orderService;
        _settings = settings;
    }

    /// <summary>
    /// Processes a payment transaction.
    /// </summary>
    /// <param name="paymentTransaction">The payment transaction to be processed.</param>
    /// <returns>A task that represents the asynchronous operation. The task result contains the result of the payment processing.</returns>
    public async Task<ProcessPaymentResult> ProcessPayment(PaymentTransaction paymentTransaction)
    {
        if (paymentTransaction.CustomValues.ContainsKey("use3d") &&
            ((paymentTransaction.CustomValues["use3d"] as bool?) ?? false))
        {
            return new ProcessPaymentResult();
        }

        var conversationId = await _tenantTokenHandler.CreateTemporaryToken(paymentTransaction.OrderCode.ToString());
        var requestBuilder = await _requestBuilder
            .WithBaseInfo(paymentTransaction, conversationId)
            .WithCustomerInfo(paymentTransaction, await _customerService.GetCustomerById(paymentTransaction.CustomerId));
        requestBuilder = await requestBuilder.WithPaymentCard(paymentTransaction);
        requestBuilder = await requestBuilder.WithBasketItems();
        var payReq = requestBuilder.Build();
        var payment = await Payment.Create(payReq, _iyzicoOptions);

        return await HandlePaymentResponse(payment);
    }


    public async Task<ProcessPaymentResult> HandlePaymentResponse(PaymentResource payment)
    {
        if (payment.Status != Status.SUCCESS.ToString())
        {
            return new ProcessPaymentResult {
                NewPaymentTransactionStatus = TransactionStatus.Pending,
                Errors = new List<string> { payment.ErrorMessage, "Ödeme gerçekleşmedi." }
                    .Where(x => !string.IsNullOrEmpty(x))
                    .ToList()
            };
        }

        if (string.IsNullOrEmpty(await _tenantTokenHandler.ValidateAndGetTenant(payment.ConversationId)) ||
            !await ValidateSignature(payment))
        {
            await Iyzipay.Model.Cancel.Create(new CreateCancelRequest {
                Locale = Locale.TR.ToString(),
                ConversationId = await _tenantTokenHandler.CreateTemporaryToken(payment.BasketId),
                PaymentId = payment.PaymentId,
                Ip = _httpContextAccessor.HttpContext?.Connection.RemoteIpAddress?.ToString(),
            }, _iyzicoOptions);

            return new ProcessPaymentResult {
                NewPaymentTransactionStatus = TransactionStatus.Voided,
                Errors = new List<string> { "Ödeme doğrulanamadı." }
            };
        }

        var paymentTransaction = await _paymentTransactionService.GetOrderByGuid(Guid.Parse(payment.BasketId));
        if (paymentTransaction == null)
        {
            if (DateTime.Now.ToString("yyyyMMdd") != DateTime.UnixEpoch.AddSeconds(payment.SystemTime).ToString("yyyyMMdd"))
            {
                await Iyzipay.Model.Refund.CreateAmountBasedRefundRequest(new CreateAmountBasedRefundRequest {
                    Locale = Locale.TR.ToString(),
                    ConversationId = await _tenantTokenHandler.CreateTemporaryToken(payment.BasketId),
                    PaymentId = payment.PaymentId,
                    Price = payment.PaidPrice,
                    Ip = _httpContextAccessor.HttpContext?.Connection.RemoteIpAddress?.ToString(),
                }, _iyzicoOptions);
            }
            else
            {
                var voidPayment = await Iyzipay.Model.Cancel.Create(new CreateCancelRequest {
                    Locale = Locale.TR.ToString(),
                    ConversationId = await _tenantTokenHandler.CreateTemporaryToken(payment.BasketId),
                    PaymentId = payment.PaymentId,
                    Ip = _httpContextAccessor.HttpContext?.Connection.RemoteIpAddress?.ToString(),
                }, _iyzicoOptions);
            }

            return new ProcessPaymentResult {
                NewPaymentTransactionStatus = TransactionStatus.Voided,
                Errors = new List<string> { "Payment transaction not found." }
            };
        }

        await StoreCardInformation(payment);
        
        paymentTransaction.AuthorizationTransactionId = payment.PaymentId;

        await _paymentTransactionService.UpdatePaymentTransaction(paymentTransaction);

        return new ProcessPaymentResult {
            NewPaymentTransactionStatus = TransactionStatus.Paid,
            PaidAmount = double.Parse(payment.PaidPrice,CultureInfo.InvariantCulture),
            Errors = payment.ErrorMessage != null ? new List<string> { payment.ErrorMessage } : []
        };
    }

    private async Task StoreCardInformation(PaymentResource payment)
    {
        // Check if card storage is supported before storing card information
        if (!_settings.CardStorageSupported)
            return;
            
        if (!string.IsNullOrEmpty(payment.CardUserKey))
        {
            await _userFieldService.SaveField(_workContext.CurrentCustomer, IyzicoDefaults.IyzicoUserKey, payment.CardUserKey);
        }

        if (!string.IsNullOrEmpty(payment.CardToken))
        {
            await _userFieldService.SaveField(_workContext.CurrentCustomer, IyzicoDefaults.IyzicoSelectedCardTokenKey, payment.CardToken);
        }
    }

    public async Task<Card?> GetUserCard(string v)
    {
        // Check if card storage is supported
        if (!_settings.CardStorageSupported)
            return null;
            
        var userKey = await _workContext.CurrentCustomer.GetUserField<String>(_userFieldService, IyzicoDefaults.IyzicoUserKey);
        if (string.IsNullOrEmpty(userKey))
            return null;
            
        var userCards = await CardList.Retrieve(new RetrieveCardListRequest {
            Locale = Locale.TR.ToString(),
            ConversationId = Guid.NewGuid().ToString(),
            CardUserKey = userKey,
        }, _iyzicoOptions);

        return userCards.CardDetails?.FirstOrDefault(x => x.CardToken == v);
    }

    public async Task<List<InstallmentDetail>> GetInstallmentDetailsByBinBumber(string binNumber, double price)
    {
        if (string.IsNullOrEmpty(binNumber))
            throw new ArgumentNullException(nameof(binNumber));

        var cart = await _shoppingCartService.GetShoppingCart(_workContext.CurrentStore.Id,
            ShoppingCartType.ShoppingCart, ShoppingCartType.Auctions);
        var ConversationId = Guid.NewGuid().ToString();
        var result = await InstallmentInfo.Retrieve(new RetrieveInstallmentInfoRequest {
            Locale = Locale.TR.ToString(),
            ConversationId = await _tenantTokenHandler.CreateTemporaryToken(ConversationId),
            BinNumber = binNumber,
            Price = price.ToString("F2", System.Globalization.CultureInfo.InvariantCulture),
        }, _iyzicoOptions);

        var validateToken = await _tenantTokenHandler.ValidateAndGetTenant(result.ConversationId);

        if (result.Status != Status.SUCCESS.ToString() || string.IsNullOrEmpty(validateToken))
            throw new Exception(result.ErrorMessage);

        return result.InstallmentDetails ?? [];
    }

    public async Task<List<Card>> GetStoredUserCards()
    {
        var userKey = await _workContext.CurrentCustomer.GetUserField<String>(_userFieldService, IyzicoDefaults.IyzicoUserKey);
        if (string.IsNullOrEmpty(userKey) || !_settings.CardStorageSupported)
            return [];

        var userCards = await CardList.Retrieve(new RetrieveCardListRequest {
            Locale = Locale.TR.ToString(),
            ConversationId = Guid.NewGuid().ToString(),
            CardUserKey = userKey,
        }, _iyzicoOptions);

        return (userCards.CardDetails ?? []);
    }

    public async Task ProcessThreeDsPayment(PaymentTransaction paymentTransaction)
    {
        if (!paymentTransaction.CustomValues.ContainsKey("use3d") || !((paymentTransaction.CustomValues["use3d"] as bool?) ?? false))
        {
            return;
        }

        var conversationId = await _tenantTokenHandler.CreateTemporaryToken(paymentTransaction.OrderCode.ToString());
        var requestBuilder = await _requestBuilder
            .WithBaseInfo(paymentTransaction, conversationId)
            .WithCustomerInfo(paymentTransaction, await _customerService.GetCustomerById(paymentTransaction.CustomerId));
        requestBuilder = await requestBuilder.WithPaymentCard(paymentTransaction);
        requestBuilder = await requestBuilder.WithCallbackUrl();
        requestBuilder = await requestBuilder.WithOrderItems(paymentTransaction);

        var payment = await ThreedsInitialize.Create(requestBuilder.Build(), _iyzicoOptions);

        if (payment.Status != Status.SUCCESS.ToString())
        {
            return;
        }

        _httpContextAccessor.HttpContext.Session.SetString("threedshtmlcontent", Convert.ToBase64String(Encoding.UTF8.GetBytes(payment.HtmlContent)));

        _httpContextAccessor.HttpContext.Response.Redirect(_linkGenerator.GetUriByRouteValues(_httpContextAccessor.HttpContext, IyzicoDefaults.PaymentThreeDsFormRenderRouteName, new { }));
        _httpContextAccessor.HttpContext.Items["grand.IsPOSTBeingDone"] = true;
    }

    public async Task<RefundPaymentResult> Refund(RefundPaymentRequest refundPaymentRequest)
    {
        var refund = await Iyzipay.Model.Refund.CreateAmountBasedRefundRequest(new CreateAmountBasedRefundRequest {
            Locale = Locale.TR.ToString(),
            ConversationId = await _tenantTokenHandler.CreateTemporaryToken(refundPaymentRequest.PaymentTransaction.OrderCode.ToString()),
            PaymentId = refundPaymentRequest.PaymentTransaction.AuthorizationTransactionId,
            Price = refundPaymentRequest.AmountToRefund.ToString("F2", System.Globalization.CultureInfo.InvariantCulture),
            Ip = refundPaymentRequest.PaymentTransaction.IPAddress,
        }, _iyzicoOptions);

        if (refund.Status != Status.SUCCESS.ToString() || string.IsNullOrEmpty(await _tenantTokenHandler.ValidateAndGetTenant(refund.ConversationId)))
        {
            return new RefundPaymentResult {
                Errors = (new List<string> { refund.ErrorMessage, "Refund could not be processed." }).Where(x => !string.IsNullOrEmpty(x)).ToList()
            };
        }

        return new RefundPaymentResult {
            NewTransactionStatus = TransactionStatus.Refunded,
        };
    }

    public async Task<VoidPaymentResult> Void(PaymentTransaction paymentTransaction)
    {
        var voidPayment = await Iyzipay.Model.Cancel.Create(new CreateCancelRequest {
            Locale = Locale.TR.ToString(),
            ConversationId = await _tenantTokenHandler.CreateTemporaryToken(paymentTransaction.OrderCode.ToString()),
            PaymentId = paymentTransaction.AuthorizationTransactionId,
            Ip = paymentTransaction.IPAddress,
        }, _iyzicoOptions);

        if (voidPayment.Status != Status.SUCCESS.ToString() || string.IsNullOrEmpty(await _tenantTokenHandler.ValidateAndGetTenant(voidPayment.ConversationId)))
        {
            return new VoidPaymentResult {
                Errors = (new List<string> { voidPayment.ErrorMessage, "Void could not be processed." }).Where(x => !string.IsNullOrEmpty(x)).ToList()
            };
        }

        return new VoidPaymentResult {
            NewTransactionStatus = TransactionStatus.Voided,
        };
    }

    public async Task<IList<string>> ValidatePaymentForm(IDictionary<string, string> model)
    {
        var creditCardFormModel = DynamicFormExtensions.ToDynamicFormModel<CreditCardFormModel>(model.Select(x => new KeyValuePair<string, object>(x.Key, x.Value)).ToDictionary(x => x.Key, x => x.Value));
        var validator = new CreditCardFormModelValidator(this);
        var validatorContext = new ValidationContext<CreditCardFormModel>(creditCardFormModel);
        var validationResult = await validator.ValidateAsync(validatorContext);
        return validationResult.Errors.Select(x => x.ErrorMessage).ToList();
    }

    public async Task<PaymentTransaction> SavePaymentInfo(IDictionary<string, string> model)
    {
        var creditCardFormModel = DynamicFormExtensions.ToDynamicFormModel<CreditCardFormModel>(model.Select(x => new KeyValuePair<string, object>(x.Key, x.Value)).ToDictionary(x => x.Key, x => x.Value));

        var paymentTransaction = new PaymentTransaction();
        
        // Check if Non 3D Secure is supported
        bool use3d;
        if (!_settings.Non3DSecureSupported)
        {
            // Non 3D Secure is not supported, always use 3D secure
            use3d = true;
        }
        else
        {
            // Non 3D Secure is supported, use the user's preference
            use3d = creditCardFormModel.Use3dPayment ?? false;
        }
        paymentTransaction.CustomValues.Add("use3d", use3d);
        
        // Check if card storage is supported
        bool approveCartStore;
        if (!_settings.CardStorageSupported)
        {
            // Card storage is not supported, always set to false
            approveCartStore = false;
        }
        else
        {
            // Card storage is supported, use the user's preference
            approveCartStore = creditCardFormModel.ApproveCartStoreWithIyzico ?? false;
        }
        paymentTransaction.CustomValues.Add("approveCartStoreWithIyzico", approveCartStore);

        if (!string.IsNullOrEmpty(creditCardFormModel.CardToken))
        {
            paymentTransaction.CustomValues.Add(IyzicoDefaults.SelectedCardTokenKey, creditCardFormModel.CardToken);
        }
        else
        {
            paymentTransaction.CustomValues.Add(IyzicoDefaults.EncryptedCartFormKey, await _encryptionService.EncryptWithHybridMethod(Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(creditCardFormModel))), IyzicoDefaults.IyzicoEncryptionKey));
        }

        var transaction = await _paymentTransactionService.GetById(paymentTransaction.Id);
        if (transaction != null)
        {
            await _paymentTransactionService.UpdatePaymentTransaction(paymentTransaction);
        }
        else
        {
            await _paymentTransactionService.InsertPaymentTransaction(paymentTransaction);
        }

        return paymentTransaction;
    }

    public async Task<ThreedsPayment> CompletePayment(string paymentId, string? conversationdata)
    {
        var threedsResponse = await ThreedsPayment.Create(new CreateThreedsPaymentRequest {
            Locale = Locale.TR.ToString(),
            ConversationId = await _tenantTokenHandler.CreateTemporaryToken(Guid.NewGuid().ToString(),isOtt:false),
            PaymentId = paymentId,
            ConversationData = conversationdata,
        }, _iyzicoOptions);

        if (threedsResponse.Status != Status.SUCCESS.ToString() || string.IsNullOrEmpty(await _tenantTokenHandler.ValidateAndGetTenant(threedsResponse.ConversationId)))
        {
            throw new Exception(threedsResponse.ErrorMessage);
        }

        await HandlePaymentResponse(threedsResponse);

        return threedsResponse;
    }

    private async Task<bool> ValidateSignature(PaymentResource payment)
    {
        if (string.IsNullOrEmpty(payment.Signature))
            return true;

        var orderGuid = Guid.Parse(payment.BasketId);
        var paymentTransaction = await _paymentTransactionService.GetOrderByGuid(orderGuid);

        if (paymentTransaction == null)
            return true;

        var paymentRequest = _requestBuilder.WithBaseInfo(paymentTransaction, payment.ConversationId).Build();
        if ((await _orderService.GetOrderByGuid(orderGuid)) != null)
        {
            await _requestBuilder.WithOrderItems(paymentTransaction);
        }
        else
        {
            await _requestBuilder.WithBasketItems();
        }


        List<String> signParams = [
            payment.PaymentId,
            paymentRequest.Currency,
            paymentRequest.BasketId,
            paymentRequest.ConversationId,
            paymentRequest.PaidPrice,
            paymentRequest.Price
        ];

        using var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(_iyzicoOptions.SecretKey));
        var hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(string.Join(":", signParams)));
        var signature = BitConverter.ToString(hash).Replace("-", "").ToLower();// BitConverter.ToString(hash).ToLower();

        return signature.Equals(payment.Signature);
    }
}
