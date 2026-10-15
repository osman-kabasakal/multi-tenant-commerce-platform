using Platform.Security;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Catalog.Categories;
using Grand.Business.Core.Interfaces.Catalog.Prices;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Catalog.Tax;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Domain.Customers;
using Grand.Domain.Payments;
using Grand.Infrastructure;
using Grand.Web.ExternalSettings.TenantToken;
using Iyzipay;
using Iyzipay.Model;
using Iyzipay.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Newtonsoft.Json;
using System.Globalization;
using System.Net;
using System.Web;

namespace Payments.Iyzico.Builders;

public class IyzicoPaymentRequestBuilder
{
    private readonly CreatePaymentRequest _request;
    private readonly IWorkContext _workContext;
    private readonly IUserFieldService _userFieldService;
    private readonly ICountryService _countryService;
    private readonly ITenantEncryptionService _encryptionService;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly LinkGenerator _linkGenerator;
    private readonly ITenantTokenHandler _tenantTokenHandler;
    private readonly IShoppingCartService _shoppingCartService;
    private readonly IPricingService _pricingService;
    private readonly ITaxService _taxService;
    private readonly IProductService _productService;
    private readonly ITranslationService _translationService;
    private readonly ICategoryService _categoryService;
    private readonly IOrderService _orderService;
    private readonly Options _iyzicoOptions;
    private readonly IyzicoPaymentSettings _settings;

    public IyzicoPaymentRequestBuilder(IWorkContext workContext,
    IUserFieldService userFieldService,
        ICountryService countryService,
         ITenantEncryptionService encryptionService,
         IHttpContextAccessor httpContextAccessor,
         LinkGenerator linkGenerator,
         ITenantTokenHandler tenantTokenHandler,
         IShoppingCartService shoppingCartService,
         IPricingService pricingService,
         ITaxService taxService,
         IProductService productService,
         ITranslationService translationService,
         ICategoryService categoryService,
         IOrderService orderService,
         IyzicoPaymentSettings settings
         )
    {
        _request = new CreatePaymentRequest();
        _workContext = workContext;
        _userFieldService = userFieldService;
        _countryService = countryService;
        _encryptionService = encryptionService;
        _httpContextAccessor = httpContextAccessor;
        _linkGenerator = linkGenerator;
        _tenantTokenHandler = tenantTokenHandler;
        _shoppingCartService = shoppingCartService;
        _pricingService = pricingService;
        _taxService = taxService;
        _productService = productService;
        _translationService = translationService;
        _categoryService = categoryService;
        _orderService = orderService;
        _settings = settings;
        _iyzicoOptions = new Options {
            ApiKey = settings.PublicKey,
            SecretKey = settings.PrivateKey,
            BaseUrl = settings.UseSandBox ? "https://sandbox-api.iyzipay.com" : "https://api.iyzipay.com"
        };
    }

    public IyzicoPaymentRequestBuilder WithBaseInfo(PaymentTransaction transaction, string conversationId)
    {
        _request.Locale = Locale.TR.ToString();
        _request.ConversationId = conversationId;
        _request.Price = transaction.TransactionAmount.ToString("F2", CultureInfo.InvariantCulture).TrimEnd('0').TrimEnd('.');
        _request.PaidPrice = transaction.TransactionAmount.ToString("F2", CultureInfo.InvariantCulture).TrimEnd('0').TrimEnd('.');
        _request.Currency = transaction.CurrencyCode;
        _request.Installment = 1;
        _request.BasketId = transaction.OrderGuid.ToString();
        // _request.PaymentChannel = PaymentChannel.MOBILE.ToString();
        // _request.PaymentGroup = PaymentGroup.PRODUCT.ToString();
        return this;
    }

    public async Task<IyzicoPaymentRequestBuilder> WithCustomerInfo(PaymentTransaction paymentTransaction, Customer customer)
    {
        var country = await _countryService.GetCountryById(customer.BillingAddress.CountryId);
        var stateProvince = await _countryService.GetStateProvincesByCountryId(country.Id, _workContext.WorkingLanguage.Id);
        var stateProvinceName = stateProvince.FirstOrDefault(x => x.Id == customer.BillingAddress.StateProvinceId)?.Name;
        var cusromerName = customer.GetFullName();
        if (string.IsNullOrEmpty(cusromerName))
        {
            cusromerName = $"{customer.BillingAddress.FirstName} {customer.BillingAddress.LastName}";
        }
        var splitName = cusromerName.Split(" ").Where(x => !string.IsNullOrEmpty(x)).ToArray();
        var buyerPhone = await customer.GetUserField<String>(_userFieldService, SystemCustomerFieldNames.Phone);
        if (string.IsNullOrEmpty(buyerPhone))
        {
            buyerPhone = customer.BillingAddress.PhoneNumber;
        }
        _request.Buyer = new Buyer {
            Id = customer.Id.ToString(),
            Name = string.Join(' ', splitName.TakeWhile((v, index) => index < splitName.Length - 1)),
            Surname = splitName.Last(),
            GsmNumber = buyerPhone,
            Email = string.IsNullOrEmpty(customer.Email) ? customer.BillingAddress.Email : customer.Email,
            IdentityNumber = "11111111111", // Example, replace with actual.
            LastLoginDate = DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss"),
            RegistrationDate = customer.CreatedOnUtc.ToString("yyyy-MM-dd HH:mm:ss"),
            RegistrationAddress = $"{customer.BillingAddress.Address1} {customer.BillingAddress.Address2} {customer.BillingAddress.City} {stateProvinceName} {country.Name} {customer.BillingAddress.ZipPostalCode}",
            Ip = paymentTransaction.IPAddress,
            City = customer.BillingAddress.City,
            Country = country.Name,
            ZipCode = customer.BillingAddress.ZipPostalCode,
        };

        _request.BillingAddress = new Address {
            Description = $"{customer.BillingAddress.Address1} {customer.BillingAddress.Address2} {customer.BillingAddress.City} {stateProvinceName} {country.Name} {customer.BillingAddress.ZipPostalCode}",
            ContactName = string.Join(' ', splitName),
            City = customer.BillingAddress.City,
            Country = country.Name,
            ZipCode = customer.BillingAddress.ZipPostalCode
        };


        _request.ShippingAddress = customer.ShippingAddress != null ? new Address {
            Description = $"{customer.ShippingAddress.Address1} {customer.ShippingAddress.Address2} {customer.ShippingAddress.City} {stateProvinceName} {country.Name} {customer.ShippingAddress.ZipPostalCode}",
            ContactName = customer.ShippingAddress.FirstName + " " + customer.ShippingAddress.LastName,
            City = customer.ShippingAddress.City,
            Country = country.Name,
            ZipCode = customer.ShippingAddress.ZipPostalCode
        } : _request.BillingAddress;

        return this;
    }

    public async Task<IyzicoPaymentRequestBuilder> WithPaymentCard(PaymentTransaction paymentTransaction)
    {
        var paymentCard = new PaymentCard();
        var cardUserKey = await _workContext.CurrentCustomer.GetUserField<String>(_userFieldService, IyzicoDefaults.IyzicoUserKey);

        if (paymentTransaction.CustomValues.ContainsKey(IyzicoDefaults.SelectedCardTokenKey) && !string.IsNullOrEmpty(cardUserKey))
        {
            var userCards = await CardList.Retrieve(new RetrieveCardListRequest {
                Locale = Locale.TR.ToString(),
                ConversationId = Guid.NewGuid().ToString(),
                CardUserKey = cardUserKey,
            }, _iyzicoOptions);

            if (userCards.CardDetails.Any(x => x.CardToken == paymentTransaction.CustomValues[IyzicoDefaults.SelectedCardTokenKey].ToString()))
            {
                paymentCard.CardToken = paymentTransaction.CustomValues[IyzicoDefaults.SelectedCardTokenKey].ToString();
                paymentCard.CardUserKey = await _workContext.CurrentCustomer.GetUserField<String>(_userFieldService, IyzicoDefaults.IyzicoUserKey);
            }
        }
        else
        {
            if (paymentTransaction.CustomValues.ContainsKey(IyzicoDefaults.EncryptedCartFormKey))
            {
                var creditCardFormModelJson = await _encryptionService.DecryptWithHybridMethod(paymentTransaction.CustomValues[IyzicoDefaults.EncryptedCartFormKey].ToString(), IyzicoDefaults.IyzicoEncryptionKey);
                var creditCardFormModel = JsonConvert.DeserializeObject<CreditCardFormModel>(Encoding.UTF8.GetString(Convert.FromBase64String(creditCardFormModelJson)));
                paymentCard.CardHolderName = creditCardFormModel.CardHolderName;
                paymentCard.CardNumber = creditCardFormModel.CardNumber;
                paymentCard.ExpireMonth = creditCardFormModel.ExpireMonth;
                paymentCard.ExpireYear = creditCardFormModel.ExpireYear;
                paymentCard.Cvc = creditCardFormModel.Cvc;
                
                // Check if card storage is supported by settings
                if (!_settings.CardStorageSupported)
                {
                    // Card storage not supported, always set RegisterCard to 0 and CardAlias to null
                    paymentCard.RegisterCard = 0;
                    paymentCard.CardAlias = null;
                }
                else
                {
                    // Card storage is supported, use the user's preference
                    paymentCard.RegisterCard = (creditCardFormModel.ApproveCartStoreWithIyzico ?? false) ? 1 : 0;
                    paymentCard.CardAlias = creditCardFormModel.CardAlias;
                }
                
                paymentCard.CardUserKey = cardUserKey;
                _request.Installment = creditCardFormModel.Installment ?? 1;
            }
        }

        _request.PaymentCard = paymentCard;
        return this;
    }

    public async Task<IyzicoPaymentRequestBuilder> WithCallbackUrl()
    {
        if (_httpContextAccessor.HttpContext.Request.Headers.TryGetValue("x-store-token", out var headerToken))
        {
            _request.CallbackUrl = _linkGenerator.GetUriByRouteValues(_httpContextAccessor.HttpContext, IyzicoDefaults.PaymentThreeDsCallbackRouteName, new { store_token = WebUtility.UrlEncode(await _tenantTokenHandler.CreateTemporaryToken(headerToken,isOtt: false,expirationMinutes:15)) });
            
        }
        return this;
    }

    public async Task<IyzicoPaymentRequestBuilder> WithOrderItems(PaymentTransaction paymentTransaction)
    {
        var order = await _orderService.GetOrderByGuid(paymentTransaction.OrderGuid);
        _request.BasketItems = new List<BasketItem>();

        var price = 0.0;
        foreach (var orderItem in order.OrderItems)
        {

            var product = await _productService.GetProductById(orderItem.ProductId);

            _request.BasketItems.Add(
                new BasketItem() {
                    Id = orderItem.Id.ToString(),
                    Name = product.Name,
                    Category1 = product.ProductCategories.Any() ? (await _categoryService.GetCategoryById(product.ProductCategories.First().CategoryId)).Name : "",
                    ItemType = orderItem.IsShipEnabled ? BasketItemType.PHYSICAL.ToString() : BasketItemType.VIRTUAL.ToString(),
                    Price = orderItem.PriceInclTax.ToString("F2", CultureInfo.InvariantCulture).TrimEnd('0').TrimEnd('.'),
                }
            );

            price += orderItem.PriceInclTax;
        }
        _request.Price = price.ToString("F2", CultureInfo.InvariantCulture).TrimEnd('0').TrimEnd('.');
        return this;
    }

    public async Task<IyzicoPaymentRequestBuilder> WithBasketItems()
    {
        var cart = await _shoppingCartService.GetShoppingCart(shoppingCartType: Grand.Domain.Orders.ShoppingCartType.ShoppingCart);

        _request.BasketItems = new List<BasketItem>();
        double price = 0.0;
        foreach (var cartItem in cart)
        {
            var product = await _productService.GetProductById(cartItem.ProductId);
            var (subTotal, discountAmount, appliedDiscounts) = await _pricingService.GetSubTotal(cartItem, product);
            var shoppingCartItemSubTotalWithDiscount =
                (await _taxService.GetProductPrice(product, subTotal)).productprice;
            price += shoppingCartItemSubTotalWithDiscount;
            _request.BasketItems.Add(
                new BasketItem() {
                    Id = cartItem.Id.ToString(),
                    Name = product.Name,
                    Category1 = product.ProductCategories.Any() ? (await _categoryService.GetCategoryById(product.ProductCategories.First().CategoryId)).Name : "",
                    ItemType = cartItem.IsShipEnabled ? BasketItemType.PHYSICAL.ToString() : BasketItemType.VIRTUAL.ToString(),
                    Price = shoppingCartItemSubTotalWithDiscount.ToString("F2", CultureInfo.InvariantCulture).TrimEnd('0').TrimEnd('.'),
                }
            );
        }
        _request.Price = price.ToString("F2", CultureInfo.InvariantCulture).TrimEnd('0').TrimEnd('.');
        return this;
    }

    public CreatePaymentRequest Build() => _request;
}
