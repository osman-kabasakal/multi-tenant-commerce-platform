using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Core.Models.Configs;
using Core.Utilities;
using Iyzipay;
using Iyzipay.Model;
using Iyzipay.Model.V2;
using Iyzipay.Model.V2.Subscription;
using Iyzipay.Request;
using Iyzipay.Request.V2.Subscription;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SaasManager.Infrastructure.PaymentProviders.IyzicoProvider;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.PaymentProviders;
using SaasManager.Application.Common.Models.PaymentProviders;
using SaasManager.Application.Common.Models.Security;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Enums;
using Options = Iyzipay.Options;

public class IyzicoPaymentProvider : IPaymentProvider
{
    private readonly IyzicoConfiguration _configuration;
    private readonly IApplicationDbContext _context;
    private readonly IWorkContext _workContext;
    private readonly ILogger<IyzicoPaymentProvider> _logger;
    private readonly string _apiKey;
    private readonly string _secretKey;
    private readonly bool _isSandbox;
    private readonly IIyzicoSubscriptionApi _subscriptions;

    private Guid? _providerId { get; set; }

    public Guid Id
    {
        get
        {
            if (_providerId.HasValue) return _providerId.Value;
            var query = _context.PaymentProviders.Where(x => x.Code == Code && x.IsActive && !x.IsDeleted);
            if (!string.IsNullOrEmpty(_configuration.ProviderId))
            {
                var selected = Guid.Parse(_configuration.ProviderId);
                query = query.Where(x => x.Id == selected);
            }
            return (_providerId = query.Select(x => x.Id).First()).Value;
        }
    }

    public string Name => "iyzico";
    public string CardUserKeyName => "ucsToken";
    public string Code => "IYZICO";
    public PaymentProviderType Type => PaymentProviderType.CreditCard;
    public bool IsActive => true;
    public string ConfigurationFingerprint => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(
        "iyzico/v1/" + (_isSandbox ? "sandbox/" : "live/") + _apiKey))).ToLowerInvariant();

    public IyzicoPaymentProvider(
        IApplicationDbContext context,
        IWorkContext workContext,
        IOptions<IyzicoConfiguration> configuration,
        ILogger<IyzicoPaymentProvider> logger,
        IIyzicoSubscriptionApi? subscriptions = null)
    {
        _configuration = configuration.Value;
        _context = context;
        _workContext = workContext;
        _logger = logger;
        _apiKey = _configuration.ApiKey;
        _secretKey = _configuration.SecretKey;
        _isSandbox = _configuration.IsSandbox;
        _subscriptions = subscriptions ?? new IyzicoSubscriptionApi();
    }

    public async Task<CardTokenResponse> CreateCardTokenAsync(CardData request)
    {
        try
        {
            Iyzipay.Options options = new Iyzipay.Options
            {
                ApiKey = _apiKey,
                SecretKey = _secretKey,
                BaseUrl = _isSandbox ? "https://sandbox-api.iyzipay.com" : "https://api.iyzipay.com"
            };

            CreateCardRequest cardRequest = new CreateCardRequest
            {
                Locale = Locale.TR.ToString(),
                Email = _workContext.GuestRegistration!.Email, // Bu email business'dan gelmeli
                ExternalId = Guid.NewGuid().ToString(),
                Card = new CardInformation
                {
                    CardAlias = $"Card_{DateTime.Now:yyyyMMddHHmmss}",
                    CardHolderName = request.CardHolderName,
                    CardNumber = request.Number,
                    ExpireMonth = request.ExpiryMonth,
                    ExpireYear = request.ExpiryYear
                }
            };

            Card card = await Card.Create(cardRequest, options);

            if (card.Status != "success")
            {
                _logger.LogError("Iyzico card creation failed: {ErrorCode} - {ErrorMessage}",
                    card.ErrorCode, card.ErrorMessage);
                throw new Exception($"Card creation failed: {card.ErrorMessage}");
            }

            return new CardTokenResponse
            {
                Token = card.CardToken,
                LastFour = card.LastFourDigits,
                CardBrand = card.CardAssociation,
                CardType = card.CardType,
                ExpiryDate = new DateTime(
                    int.Parse(request.ExpiryYear),
                    int.Parse(request.ExpiryMonth),
                    1).AddMonths(1).AddDays(-1),
                CustomProperties = new Dictionary<string, string>()
                {
                    { CardUserKeyName, card.CardUserKey },
                    { "binNumber", card.BinNumber },
                    { "cardBankName", card.CardBankName },
                    { "cardBankCode", (card.CardBankCode ?? 0).ToString() }
                }
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating card token with iyzico");
            throw new Exception("Error creating card token", ex);
        }
    }

    private Options MerchantOptions()
    {
        if (string.IsNullOrWhiteSpace(_apiKey) || string.IsNullOrWhiteSpace(_secretKey))
            throw new InvalidOperationException("Configure the selected iyzico merchant account.");
        return new Options { ApiKey = _apiKey, SecretKey = _secretKey,
            BaseUrl = _isSandbox ? "https://sandbox-api.iyzipay.com" : "https://api.iyzipay.com" };
    }
    private static bool Success(string? status) => string.Equals(status, "success", StringComparison.OrdinalIgnoreCase);
    private static bool Reference(string? value) => Guid.TryParseExact(value, "D", out var id) && id != Guid.Empty;
    private static PaymentResponse Rejected(PaymentInitializationOutcome outcome = PaymentInitializationOutcome.NotSubmitted) =>
        new() { IsSuccess = false, InitializationOutcome = outcome, ErrorMessage = "Subscription payment could not be verified." };

    public async Task<PaymentResponse> ProcessPaymentAsync(BusinessSubscription subscription, CardData cardModel)
    {
        var submitted = false;
        try
        {
            var options = MerchantOptions();
            var guest = _workContext.GuestRegistration;
            if (guest == null || guest.ConvertedBusinessId != subscription.BusinessId || subscription.Period != PaymentPeriod.Monthly)
                return Rejected();
            var plan = await _context.SubscriptionPlans.SingleOrDefaultAsync(p => p.Id == subscription.PlanId && p.IsActive && !p.IsDeleted);
            var business = await _context.Businesses.SingleOrDefaultAsync(b => b.Id == subscription.BusinessId && b.CreatedByGuestId == guest.Id && !b.IsDeleted);
            // Merchant pricing is configured once. Never invent a provider reference or silently create a differently priced plan at checkout.
            if (business == null || plan == null || !Reference(plan.Code) || plan.Price <= 0 || plan.Price != subscription.Amount)
                return Rejected();
            var pricing = _subscriptions.ReadPlan(new RetrievePlanRequest { Locale = "tr", PricingPlanReferenceCode = plan.Code }, options);
            var remote = pricing.Data;
            if (!Success(pricing.Status) || remote == null || remote.ReferenceCode != plan.Code || remote.Status != "ACTIVE" ||
                remote.CurrencyCode != "TRY" || remote.PaymentInterval != "MONTHLY" || remote.PaymentIntervalCount != 1 ||
                remote.PlanPaymentType != "RECURRING" || (remote.TrialPeriodDays ?? 0) != plan.TrialDays ||
                !decimal.TryParse(remote.Price, NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture, out var price) || price != plan.Price)
                return Rejected();
            var year = cardModel.ExpiryYear;
            if (year.Length == 2) year = "20" + year;
            var request = new SubscriptionInitializeRequest {
                Locale = "tr", ConversationId = subscription.Id.ToString("D"), PricingPlanReferenceCode = plan.Code,
                SubscriptionInitialStatus = "PENDING",
                Customer = new CheckoutFormCustomer {
                    Email = guest.Email, Name = guest.Firstname, Surname = guest.Lastname,
                    GsmNumber = business.Phone, IdentityNumber = business.TaxNumber,
                    BillingAddress = CreateAddress(business), ShippingAddress = CreateAddress(business)
                },
                PaymentCard = new CardInfo { CardNumber = cardModel.Number, CardHolderName = cardModel.CardHolderName,
                    ExpireMonth = cardModel.ExpiryMonth, ExpireYear = year, Cvc = cardModel.Cvv, RegisterConsumerCard = true }
            };
            submitted = true;
            var response = _subscriptions.Initialize(request, options);
            var data = response.Data;
            if (!Success(response.Status)) return Rejected(response.Status == "failure" && string.IsNullOrEmpty(data?.ReferenceCode)
                ? PaymentInitializationOutcome.Rejected : PaymentInitializationOutcome.Unknown);
            if (data == null || !Reference(data.ReferenceCode) || data.PricingPlanReferenceCode != plan.Code ||
                data.SubscriptionStatus != "PENDING" || !Reference(data.CustomerReferenceCode)) return Rejected(PaymentInitializationOutcome.Unknown);
            return new PaymentResponse { IsSuccess = true, InitializationOutcome = PaymentInitializationOutcome.Initialized,
                PaymentId = data.ReferenceCode, RawResult = JsonSerializer.Serialize(data) };
        }
        catch (Exception error)
        {
            _logger.LogError("Iyzico subscription initialization failed ({ErrorType}).", error.GetType().Name);
            return Rejected(submitted ? PaymentInitializationOutcome.Unknown : PaymentInitializationOutcome.NotSubmitted);
        }
    }

    public async Task<RefundResponse> ProcessRefundAsync(SaasManager.Domain.Entities.Financial.Payment payment)
    {
        try
        {
            Options options = new Options
            {
                ApiKey = _apiKey,
                SecretKey = _secretKey,
                BaseUrl = _isSandbox ? "https://sandbox-api.iyzipay.com" : "https://api.iyzipay.com"
            };

            CreateRefundRequest refundRequest = new CreateRefundRequest
            {
                Locale = Locale.TR.ToString(),
                ConversationId = Guid.NewGuid().ToString(),
                PaymentTransactionId = payment.ProviderTransactionId,
                Price = payment.Amount.ToString(CultureInfo.InvariantCulture),
                Currency = Currency.TRY.ToString(),
                Ip = _workContext.GetClientIpAddress() // IP adresi request'ten alınmalı
            };

            Refund refund = await Refund.Create(refundRequest, options);

            return new RefundResponse { IsSuccess = refund.Status == "success" };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing refund with iyzico");
            return new RefundResponse { IsSuccess = false };
        }
    }

    public async Task<bool> ValidateCardAsync(CardData request)
    {
        try
        {
            if (request.Number == null || request.Number.Length < 6) return false;
            var bin = await _subscriptions.ReadBinAsync(new RetrieveBinNumberRequest {
                Locale = "tr", ConversationId = Guid.NewGuid().ToString("D"), BinNumber = request.Number[..6]
            }, MerchantOptions());
            return Success(bin.Status);
        }
        catch (Exception error)
        {
            _logger.LogError("Iyzico card validation failed ({ErrorType}).", error.GetType().Name);
            return false;
        }
    }

    public Task<bool> ActivateSubscriptionAsync(PaymentResponse payment)
    {
        try
        {
            if (!payment.IsSuccess || !Reference(payment.PaymentId) || string.IsNullOrWhiteSpace(payment.RawResult))
                return Task.FromResult(false);
            var expected = JsonSerializer.Deserialize<SubscriptionCreatedResource>(payment.RawResult);
            if (expected == null || expected.ReferenceCode != payment.PaymentId || !Reference(expected.PricingPlanReferenceCode) ||
                !Reference(expected.CustomerReferenceCode) || expected.SubscriptionStatus != "PENDING") return Task.FromResult(false);
            var options = MerchantOptions();
            var query = new RetrieveSubscriptionRequest { Locale = "tr", SubscriptionReferenceCode = payment.PaymentId };
            bool Matches(ResponseData<SubscriptionResource> value) => Success(value.Status) && value.Data != null &&
                value.Data.ReferenceCode == payment.PaymentId && value.Data.PricingPlanReferenceCode == expected.PricingPlanReferenceCode &&
                value.Data.CustomerReferenceCode == expected.CustomerReferenceCode;
            var before = _subscriptions.ReadSubscription(query, options);
            if (!Matches(before)) return Task.FromResult(false);
            if (before.Data.SubscriptionStatus == "ACTIVE") return Task.FromResult(true);
            if (before.Data.SubscriptionStatus != "PENDING") return Task.FromResult(false);
            var activation = _subscriptions.Activate(new ActivateSubscriptionRequest { Locale = "tr", SubscriptionReferenceCode = payment.PaymentId }, options);
            if (!Success(activation.Status)) return Task.FromResult(false);
            var after = _subscriptions.ReadSubscription(query, options);
            return Task.FromResult(Matches(after) && after.Data.SubscriptionStatus == "ACTIVE");
        }
        catch (Exception error)
        {
            _logger.LogError("Iyzico subscription activation failed ({ErrorType}).", error.GetType().Name);
            return Task.FromResult(false);
        }
    }

    private Buyer CreateBuyerInfo(Business business)
    {
        return new Buyer
        {
            Id = business.Id.ToString(),
            Name = business.OwnerName,
            Surname = business.OwnerName,
            Email = business.Email,
            GsmNumber = business.Phone,
            IdentityNumber = business.TaxNumber,
            RegistrationAddress = business.Address,
            City = business.City,
            Country = "Turkey",
            Ip = "127.0.0.1" // IP adresi request'ten alınmalı
        };
    }

    private Address CreateAddress(Business business)
    {
        return new Address
        {
            ContactName = business.OwnerName,
            City = business.City,
            Country = "Turkey",
            Description = business.Address
        };
    }
}
