using Grand.Business.Core.Interfaces.Catalog.Discounts;
using Grand.Business.Core.Interfaces.Catalog.Prices;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Checkout.Shipping;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Domain.Common;
using Grand.Domain.Customers;
using Grand.Domain.Directory;
using Grand.Domain.Discounts;
using Grand.Domain.Orders;
using Grand.Domain.Shipping;
using Grand.Domain.Stores;

namespace Grand.Business.Checkout.Services.Shipping;

/// <summary>
/// Service for managing free shipping calculations and conditions
/// </summary>
public class FreeShippingService : IFreeShippingService
{
    private readonly IShippingService _shippingService;
    private readonly IPricingService _pricingService;
    private readonly ICurrencyService _currencyService;
    private readonly IProductService _productService;
    private readonly IDiscountService _discountService;
    private readonly ITranslationService _translationService;
    private readonly IPriceFormatter _priceFormatter;
    private readonly IDiscountValidationService _discountValidationService;
    private readonly ShippingSettings _shippingSettings;

    public FreeShippingService(
        IShippingService shippingService,
        IPricingService pricingService,
        ICurrencyService currencyService,
        IProductService productService,
        IDiscountService discountService,
        ITranslationService translationService,
        IPriceFormatter priceFormatter,
        IDiscountValidationService discountValidationService,
        ShippingSettings shippingSettings)
    {
        _shippingService = shippingService;
        _pricingService = pricingService;
        _currencyService = currencyService;
        _productService = productService;
        _discountService = discountService;
        _translationService = translationService;
        _priceFormatter = priceFormatter;
        _discountValidationService = discountValidationService;
        _shippingSettings = shippingSettings;
    }

    public async Task<ComprehensiveFreeShippingInfo> GetFreeShippingInfo(Customer customer, Store store,
        Currency currency, IList<ShoppingCartItem> shoppingCart, Address shippingAddress)
    {
        var availableOptions = new List<FreeShippingOption>();

        // 1. Check customer group-based free shipping
        var customerGroupOption = await CheckCustomerGroupFreeShipping(customer);
        if (customerGroupOption != null)
            availableOptions.Add(customerGroupOption);

        // 2. Check discount/promotion-based free shipping
        var discountOptions = await CheckDiscountFreeShipping(customer, store, currency, shoppingCart);
        availableOptions.AddRange(discountOptions);

        // 3. Check product-based free shipping
        var productOption = await CheckProductFreeShipping(shoppingCart);
        if (productOption != null)
            availableOptions.Add(productOption);

        // 4. Check amount-based free shipping from system settings
        var cartSubtotal = await CalculateCartSubtotal(shoppingCart);
        var systemAmountOption = CheckSystemAmountFreeShipping(cartSubtotal);
        if (systemAmountOption != null)
            availableOptions.Add(systemAmountOption);

        // 5. Check shipping provider-specific free shipping
        var providerOptions = await CheckShippingProviderFreeShipping(customer, shoppingCart, shippingAddress);
        availableOptions.AddRange(providerOptions);

        // Find the best option (active or closest to being active)
        var bestOption = GetBestOption(availableOptions, cartSubtotal);

        var info = new ComprehensiveFreeShippingInfo {
            AvailableOptions = availableOptions
        };

        if (bestOption != null)
        {
            info.IsFreeShippingActive = bestOption.IsActive;
            info.MinimumAmountForFreeShipping = bestOption.MinimumAmount;
            info.FreeShippingDescription = bestOption.Description;
            info.FreeShippingSource = bestOption.Source;
            info.CurrencyCode = currency.CurrencyCode;

            if (bestOption.MinimumAmount.HasValue && !bestOption.IsActive)
            {
                var remaining = bestOption.MinimumAmount.Value - cartSubtotal;
                info.RemainingAmountForFreeShipping = remaining > 0 ? remaining : 0;
                info.FormattedRemainingAmount = _priceFormatter.FormatPrice(
                    info.RemainingAmountForFreeShipping.Value, currency);
            }

            if (bestOption.MinimumAmount.HasValue)
            {
                info.FormattedMinimumAmount = _priceFormatter.FormatPrice(
                    bestOption.MinimumAmount.Value, currency);
            }
        }

        return info;
    }

    public async Task<bool> IsFreeShippingAvailable(Customer customer, Store store,
        IList<ShoppingCartItem> shoppingCart, Address shippingAddress)
    {
        var info = await GetFreeShippingInfo(customer, store, null, shoppingCart, shippingAddress);
        return info.IsFreeShippingActive;
    }

    public async Task<FreeShippingOption> GetBestFreeShippingOption(Customer customer, Store store,
        Currency currency, IList<ShoppingCartItem> shoppingCart, Address shippingAddress)
    {
        var info = await GetFreeShippingInfo(customer, store, currency, shoppingCart, shippingAddress);
        return info.AvailableOptions.FirstOrDefault(o => o.IsActive) ??
               info.AvailableOptions.OrderBy(o => o.Priority).FirstOrDefault();
    }

    private async Task<FreeShippingOption> CheckCustomerGroupFreeShipping(Customer customer)
    {
        // Check if any of the customer's groups have free shipping enabled
        if (customer.FreeShipping)
            return new FreeShippingOption {
                Source = "Customer",
                IsActive = customer.FreeShipping,
                Description = "Free shipping for customer",
                Priority = 2
            };
        foreach (var groupId in customer.Groups)
        {
            var group = customer.Groups.FirstOrDefault(g => g == groupId);
            if (group != null)
            {
                // Note: This would need to be extended if customer groups have free shipping settings
                // For now, returning null as GrandNode doesn't have this by default
            }
        }

        return null;
    }

    private async Task<List<FreeShippingOption>> CheckDiscountFreeShipping(Customer customer,
        Store store, Currency currency,
        IList<ShoppingCartItem> shoppingCart)
    {
        var options = new List<FreeShippingOption>();

        // Check for applicable discounts that offer free shipping
        var discounts = await _discountService.GetActiveDiscountsByContext(DiscountType.AssignedToShipping);

        foreach (var discount in discounts)
        {
            var validationResult =
                await _discountValidationService.ValidateDiscount(discount, customer, store, currency);
            if (validationResult.IsValid)
            {
                options.Add(new FreeShippingOption {
                    Source = "Discount",
                    IsActive = true,
                    Description = discount.Name,
                    Priority = 1
                });
            }
        }

        return options;
    }

    private async Task<FreeShippingOption> CheckProductFreeShipping(IList<ShoppingCartItem> shoppingCart)
    {
        // Check if all products in cart have free shipping
        var allProductsFreeShipping = true;

        foreach (var item in shoppingCart)
        {
            var product = await _productService.GetProductById(item.ProductId);
            if (product != null && !product.IsFreeShipping)
            {
                allProductsFreeShipping = false;
                break;
            }
        }

        if (allProductsFreeShipping && shoppingCart.Any())
        {
            return new FreeShippingOption {
                Source = "Product",
                IsActive = true,
                Description = _translationService.GetResource("ShoppingCart.FreeShipping.AllProductsFreeShipping"),
                Priority = 2
            };
        }

        return null;
    }

    private FreeShippingOption CheckSystemAmountFreeShipping(double cartSubtotal)
    {
        if (_shippingSettings.FreeShippingOverXEnabled && _shippingSettings.FreeShippingOverXValue > 0)
        {
            return new FreeShippingOption {
                Source = "System",
                IsActive = cartSubtotal >= _shippingSettings.FreeShippingOverXValue,
                MinimumAmount = _shippingSettings.FreeShippingOverXValue,
                Description = "Free shipping on orders over specified amount",
                Priority = 3
            };
        }

        return null;
    }

    private async Task<List<FreeShippingOption>> CheckShippingProviderFreeShipping(Customer customer,
        IList<ShoppingCartItem> shoppingCart, Address shippingAddress)
    {
        var options = new List<FreeShippingOption>();

        // Get all active shipping providers
        var providers = _shippingService.LoadAllShippingRateCalculationProviders(customer: customer);

        foreach (var provider in providers)
        {
            var freeShippingInfo = await provider.GetFreeShippingInfo(customer, shoppingCart, shippingAddress);

            if (freeShippingInfo != null && freeShippingInfo.IsFreeShippingAvailable)
            {
                options.Add(new FreeShippingOption {
                    Source = $"ShippingProvider:{provider.FriendlyName}",
                    IsActive = freeShippingInfo.MeetsFreeShippingConditions,
                    MinimumAmount = freeShippingInfo.MinimumOrderAmountForFreeShipping,
                    Description = freeShippingInfo.FreeShippingConditionDescription ?? provider.FriendlyName,
                    Priority = 4
                });
            }
        }

        return options;
    }

    private FreeShippingOption GetBestOption(List<FreeShippingOption> options, double cartSubtotal)
    {
        if (!options.Any())
            return null;

        // First, try to find an active option
        var activeOption = options.Where(o => o.IsActive).OrderBy(o => o.Priority).FirstOrDefault();
        if (activeOption != null)
            return activeOption;

        // If no active option, find the one with the smallest remaining amount needed
        var amountBasedOptions = options.Where(o => o.MinimumAmount.HasValue).ToList();
        if (amountBasedOptions.Any())
        {
            return amountBasedOptions
                .OrderBy(o => o.MinimumAmount.Value - cartSubtotal)
                .ThenBy(o => o.Priority)
                .FirstOrDefault();
        }

        // Return the highest priority option
        return options.OrderBy(o => o.Priority).FirstOrDefault();
    }

    private async Task<double> CalculateCartSubtotal(IList<ShoppingCartItem> shoppingCart)
    {
        double subtotal = 0;

        foreach (var item in shoppingCart)
        {
            var product = await _productService.GetProductById(item.ProductId);
            if (product != null)
            {
                var (itemSubtotal, _, _) = await _pricingService.GetSubTotal(item, product);
                subtotal += itemSubtotal;
            }
        }

        return subtotal;
    }
}