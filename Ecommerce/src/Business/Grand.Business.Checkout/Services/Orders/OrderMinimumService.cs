using Grand.Business.Core.Interfaces.Catalog.Prices;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Checkout.Shipping;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Domain.Customers;
using Grand.Domain.Directory;
using Grand.Domain.Orders;
using Grand.Domain.Stores;

namespace Grand.Business.Checkout.Services.Orders;

/// <summary>
/// Service for calculating minimum order requirements
/// </summary>
public class OrderMinimumService : IOrderMinimumService
{
    private readonly IShippingService _shippingService;
    private readonly IPricingService _pricingService;
    private readonly ICurrencyService _currencyService;
    private readonly IProductService _productService;
    private readonly IPriceFormatter _priceFormatter;
    private readonly OrderSettings _orderSettings;

    public OrderMinimumService(
        IShippingService shippingService,
        IPricingService pricingService,
        ICurrencyService currencyService,
        IProductService productService,
        IPriceFormatter priceFormatter,
        OrderSettings orderSettings)
    {
        _shippingService = shippingService;
        _pricingService = pricingService;
        _currencyService = currencyService;
        _productService = productService;
        _priceFormatter = priceFormatter;
        _orderSettings = orderSettings;
    }

    public async Task<double> GetMinimumOrderSubtotalAmount(Customer customer, Store store, Currency currency)
    {
        // Start with the system-wide minimum from OrderSettings
        var systemMinimum = _orderSettings.MinOrderSubtotalAmount;

        // Get all active shipping providers
        var shippingProviders =  _shippingService.LoadAllShippingRateCalculationProviders(
            customer: customer,
            storeId: store?.Id);

        // Get minimum amounts from all shipping providers
        var providerMinimums = new List<double>();
        foreach (var provider in shippingProviders)
        {
            var providerMinimum = await provider.GetOrderSubtotalMinimumAmount(customer, store, currency);
            if (providerMinimum.HasValue)
            {
                providerMinimums.Add(providerMinimum.Value);
            }
        }

        // If there are provider minimums, find the smallest one
        var smallestProviderMinimum = providerMinimums.Any() ? providerMinimums.Min() : 0;

        // Return the maximum between system minimum and the smallest provider minimum
        // This ensures we respect both the system requirement and at least one shipping option
        return Math.Max(systemMinimum, smallestProviderMinimum);
    }

    public async Task<double> GetRemainingAmountForMinimumOrder(Customer customer, Store store, Currency currency, 
        IList<ShoppingCartItem> shoppingCart)
    {
        var minimumAmount = await GetMinimumOrderSubtotalAmount(customer, store, currency);
        var cartSubtotal = await CalculateCartSubtotal(shoppingCart);
        
        var remaining = minimumAmount - cartSubtotal;
        return remaining > 0 ? remaining : 0;
    }

    public async Task<bool> MeetsMinimumOrderRequirements(Customer customer, Store store, Currency currency, 
        IList<ShoppingCartItem> shoppingCart)
    {
        var minimumAmount = await GetMinimumOrderSubtotalAmount(customer, store, currency);
        var cartSubtotal = await CalculateCartSubtotal(shoppingCart);
        
        return cartSubtotal >= minimumAmount;
    }

    public async Task<MinimumOrderInfo> GetMinimumOrderInfo(Customer customer, Store store, Currency currency, 
        IList<ShoppingCartItem> shoppingCart)
    {
        var minimumAmount = await GetMinimumOrderSubtotalAmount(customer, store, currency);
        var cartSubtotal = await CalculateCartSubtotal(shoppingCart);
        var remainingAmount = minimumAmount - cartSubtotal;
        
        return new MinimumOrderInfo
        {
            MinimumOrderAmount = minimumAmount,
            RemainingAmount = remainingAmount > 0 ? remainingAmount : 0,
            IsMet = cartSubtotal >= minimumAmount,
            CurrencyCode = currency.CurrencyCode,
            FormattedMinimumAmount = _priceFormatter.FormatPrice(minimumAmount, currency),
            FormattedRemainingAmount = _priceFormatter.FormatPrice(
                remainingAmount > 0 ? remainingAmount : 0, currency),
            CartSubtotal = cartSubtotal,
            FormattedCartSubtotal = _priceFormatter.FormatPrice(cartSubtotal, currency)
        };
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