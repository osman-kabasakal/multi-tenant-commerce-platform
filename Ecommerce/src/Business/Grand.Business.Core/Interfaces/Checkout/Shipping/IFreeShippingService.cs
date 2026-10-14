using Grand.Domain.Common;
using Grand.Domain.Customers;
using Grand.Domain.Directory;
using Grand.Domain.Orders;
using Grand.Domain.Stores;

namespace Grand.Business.Core.Interfaces.Checkout.Shipping;

/// <summary>
/// Service interface for managing free shipping calculations and conditions
/// </summary>
public interface IFreeShippingService
{
    /// <summary>
    /// Gets comprehensive free shipping information considering all sources
    /// </summary>
    /// <param name="customer">Customer</param>
    /// <param name="store">Store</param>
    /// <param name="currency">Currency</param>
    /// <param name="shoppingCart">Shopping cart items</param>
    /// <param name="shippingAddress">Shipping address</param>
    /// <returns>Comprehensive free shipping information</returns>
    Task<ComprehensiveFreeShippingInfo> GetFreeShippingInfo(Customer customer, Store store, Currency currency, 
        IList<ShoppingCartItem> shoppingCart, Address shippingAddress);

    /// <summary>
    /// Checks if free shipping is available from any source
    /// </summary>
    /// <param name="customer">Customer</param>
    /// <param name="store">Store</param>
    /// <param name="shoppingCart">Shopping cart items</param>
    /// <param name="shippingAddress">Shipping address</param>
    /// <returns>True if free shipping is available</returns>
    Task<bool> IsFreeShippingAvailable(Customer customer, Store store, 
        IList<ShoppingCartItem> shoppingCart, Address shippingAddress);

    /// <summary>
    /// Gets the most advantageous free shipping option for the customer
    /// </summary>
    /// <param name="customer">Customer</param>
    /// <param name="store">Store</param>
    /// <param name="currency">Currency</param>
    /// <param name="shoppingCart">Shopping cart items</param>
    /// <param name="shippingAddress">Shipping address</param>
    /// <returns>Best free shipping option available</returns>
    Task<FreeShippingOption> GetBestFreeShippingOption(Customer customer, Store store, Currency currency,
        IList<ShoppingCartItem> shoppingCart, Address shippingAddress);
}

/// <summary>
/// Represents comprehensive free shipping information from all sources
/// </summary>
public class ComprehensiveFreeShippingInfo
{
    /// <summary>
    /// Whether free shipping is currently active for the cart
    /// </summary>
    public bool IsFreeShippingActive { get; set; }

    /// <summary>
    /// Minimum amount needed for free shipping (if amount-based)
    /// </summary>
    public double? MinimumAmountForFreeShipping { get; set; }

    /// <summary>
    /// Remaining amount needed to qualify for free shipping
    /// </summary>
    public double? RemainingAmountForFreeShipping { get; set; }

    /// <summary>
    /// Description of free shipping conditions
    /// </summary>
    public string FreeShippingDescription { get; set; }

    /// <summary>
    /// Source of the free shipping (e.g., "Customer Group", "Promotion", "Order Amount", "Shipping Provider")
    /// </summary>
    public string FreeShippingSource { get; set; }

    /// <summary>
    /// Currency code
    /// </summary>
    public string CurrencyCode { get; set; }

    /// <summary>
    /// Formatted minimum amount string
    /// </summary>
    public string FormattedMinimumAmount { get; set; }

    /// <summary>
    /// Formatted remaining amount string
    /// </summary>
    public string FormattedRemainingAmount { get; set; }

    /// <summary>
    /// All available free shipping options
    /// </summary>
    public List<FreeShippingOption> AvailableOptions { get; set; } = new();
}

/// <summary>
/// Represents a single free shipping option
/// </summary>
public class FreeShippingOption
{
    /// <summary>
    /// Source of this free shipping option
    /// </summary>
    public string Source { get; set; }

    /// <summary>
    /// Whether this option is currently active
    /// </summary>
    public bool IsActive { get; set; }

    /// <summary>
    /// Minimum amount required (if applicable)
    /// </summary>
    public double? MinimumAmount { get; set; }

    /// <summary>
    /// Description of the conditions
    /// </summary>
    public string Description { get; set; }

    /// <summary>
    /// Priority for sorting (lower is better)
    /// </summary>
    public int Priority { get; set; }
}