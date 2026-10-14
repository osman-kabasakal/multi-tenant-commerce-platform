using System.Globalization;
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
using Microsoft.VisualBasic;
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

    private Guid? _providerId { get; set; }

    public Guid Id => (Guid)(_providerId.HasValue
        ? _providerId!.Value
        : (_providerId = _context.PaymentProviders.First(x => x.Code == Code).Id));

    public string Name => "iyzico";
    public string CardUserKeyName => "ucsToken";
    public string Code => "IYZICO";
    public PaymentProviderType Type => PaymentProviderType.CreditCard;
    public bool IsActive => true;

    public IyzicoPaymentProvider(
        IApplicationDbContext context,
        IWorkContext workContext,
        IOptions<IyzicoConfiguration> configuration,
        ILogger<IyzicoPaymentProvider> logger)
    {
        _configuration = configuration.Value;
        _context = context;
        _workContext = workContext;
        _logger = logger;
        _apiKey = _configuration.ApiKey;
        _secretKey = _configuration.SecretKey;
        _isSandbox = _configuration.IsSandbox;
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

    public async Task<PaymentResponse> ProcessPaymentAsync(BusinessSubscription subscription, CardData cardModel)
    {
        try
        {
            Iyzipay.Options options = new Iyzipay.Options
            {
                ApiKey = _apiKey,
                SecretKey = _secretKey,
                BaseUrl = _isSandbox ? "https://sandbox-api.iyzipay.com" : "https://api.iyzipay.com"
            };
            // var paymentMethod =
            //     await _context.PaymentMethods.AsNoTracking().FirstOrDefaultAsync(x =>
            //         x.BusinessId == subscription.BusinessId! && x.ProviderId == Id && x.IsDefault);
            // if (paymentMethod == null)
            // {
            //     throw new Exception("Ödeme yöntemi bulunamadı");
            // }
            var subscriptionPlan =
                await _context.SubscriptionPlans.AsNoTracking().FirstOrDefaultAsync(x => x.Id == subscription.PlanId);

            var business = await _context.Businesses.AsNoTracking().FirstAsync(x => x.Id == subscription.BusinessId);

            var iyziPayProduct = Iyzipay.Model.V2.Subscription.Product.Retrieve(
                new RetrieveProductRequest()
                {
                    Locale = Locale.TR.ToString(), ProductReferenceCode = subscription.PlanId.ToString(),
                }, options);

            if (iyziPayProduct.Status != Status.SUCCESS.ToString() && !_isSandbox)
            {
                CreateProductRequest request = new CreateProductRequest
                {
                    Description = subscriptionPlan!.Description,
                    Locale = Locale.TR.ToString(),
                    Name = subscriptionPlan!.Name,
                };

                iyziPayProduct = Iyzipay.Model.V2.Subscription.Product.Create(request, options);

                CreatePlanRequest planRequest = new CreatePlanRequest()
                {
                    Locale = Locale.TR.ToString(),
                    Name = $"{subscriptionPlan.Name} - Aylık Ödeme Planı",
                    TrialPeriodDays = subscriptionPlan.TrialDays,
                    Price = subscriptionPlan.Price.ToString(),
                    CurrencyCode = Currency.TRY.ToString(),
                    PaymentInterval = PaymentInterval.MONTHLY.ToString(),
                    RecurrenceCount = 12,
                    PaymentIntervalCount = 1,
                    PlanPaymentType = PlanPaymentType.RECURRING.ToString(),
                    ProductReferenceCode = iyziPayProduct.Data.ReferenceCode
                };

                ResponseData<PlanResource> response = Plan.Create(planRequest, options);

                subscriptionPlan.UpdateCode(response.Data.ReferenceCode);
                _context.SubscriptionPlans.Update(subscriptionPlan);
                await _context.SaveChangesAsync(default);

                SubscriptionInitializeRequest subscriptionInitializeRequest = new SubscriptionInitializeRequest
                {
                    Locale = Locale.TR.ToString(),
                    Customer = new CheckoutFormCustomer
                    {
                        Email = _workContext.GuestRegistration!.Email,
                        Name = _workContext.GuestRegistration.Firstname,
                        Surname = _workContext.GuestRegistration.Lastname,
                        BillingAddress = new Address
                        {
                            City = business.City,
                            Country = "Türkiye",
                            Description = business.Address,
                            ContactName = business.OwnerName,
                            ZipCode = business.PostalCode,
                        },
                        ShippingAddress = new Address
                        {
                            City = business.City,
                            Country = "Türkiye",
                            Description = business.Address,
                            ContactName = business.OwnerName,
                            ZipCode = business.PostalCode,
                        },
                        GsmNumber = business.Phone,
                        IdentityNumber = business.TaxNumber
                    },
                    PaymentCard = new CardInfo
                    {
                        CardNumber = cardModel.Number,
                        CardHolderName = cardModel.CardHolderName,
                        ExpireMonth = cardModel.ExpiryMonth,
                        ExpireYear = cardModel.ExpiryMonth,
                        Cvc = cardModel.Cvv,
                        RegisterConsumerCard = true
                    },
                    PricingPlanReferenceCode = subscriptionPlan!.Code
                };

                ResponseData<SubscriptionCreatedResource> subscriptionCreateResponse =
                    Subscription.Initialize(subscriptionInitializeRequest, options);

                return new PaymentResponse
                {
                    IsSuccess = subscriptionCreateResponse.Status == Status.SUCCESS.ToString(),
                    PaymentId = subscriptionCreateResponse.Data.ReferenceCode,
                    ErrorMessage = subscriptionCreateResponse.ErrorMessage,
                    RawResult = JsonSerializer.Serialize(subscriptionCreateResponse.Data)
                };
            }
            else
            {
                subscriptionPlan!.UpdateCode(PasswordGenerator.GenerateRandomPassword());
                _context.SubscriptionPlans.Update(subscriptionPlan);
                await _context.SaveChangesAsync(default);
                
                return new PaymentResponse
                {
                    IsSuccess = true,
                    PaymentId = PasswordGenerator.GenerateRandomPassword(),
                    ErrorMessage = null,
                    RawResult = JsonSerializer.Serialize(new{Debug=true})
                };
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing payment with iyzico");
            return new PaymentResponse
            {
                IsSuccess = _isSandbox, ErrorMessage = _isSandbox ?null: "Payment processing failed", RawResult = _isSandbox ?JsonSerializer.Serialize(new{Debug=true}): ex.ToString()
            };
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
            Options options = new Options
            {
                ApiKey = _apiKey,
                SecretKey = _secretKey,
                BaseUrl = _isSandbox ? "https://sandbox-api.iyzipay.com" : "https://api.iyzipay.com"
            };

            RetrieveBinNumberRequest binRequest = new RetrieveBinNumberRequest()
            {
                Locale = Locale.TR.ToString(),
                ConversationId = Guid.NewGuid().ToString(),
                BinNumber = request.Number?.Substring(0, 6)
            };

            BinNumber binNumber = await BinNumber.Retrieve(binRequest, options);

            return binNumber.Status == "success";
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error validating card with iyzico");
            return _isSandbox;
        }
    }

    public Task<bool> ActivateSubscriptionAsync(PaymentResponse paymentDetail)
    {
        if(_isSandbox)
            return Task.FromResult<bool>(true);
        
        ActivateSubscriptionRequest request = new ActivateSubscriptionRequest
        {
            Locale = Locale.TR.ToString(), SubscriptionReferenceCode = paymentDetail.PaymentId
        };
        Options options = new Options
        {
            ApiKey = _apiKey,
            SecretKey = _secretKey,
            BaseUrl = _isSandbox ? "https://sandbox-api.iyzipay.com" : "https://api.iyzipay.com"
        };
        IyzipayResourceV2 response = Subscription.Activate(request, options);

        return Task.FromResult(response.Status == Status.SUCCESS.ToString());
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
