using Grand.Domain.Customers;
using Grand.Domain.Directory;
using Grand.Domain.Orders;
using Grand.Domain.Stores;

namespace Grand.Business.Core.Interfaces.Checkout.Orders;

/// <summary>
/// Service interface for calculating minimum order requirements
/// </summary>
public interface IOrderMinimumService
{
    /// <summary>
    /// Gets the minimum order subtotal amount considering both OrderSettings and shipping providers
    /// </summary>
    /// <param name="customer">Customer</param>
    /// <param name="store">Store</param>
    /// <param name="currency">Currency</param>
    /// <returns>Minimum order subtotal amount</returns>
    Task<double> GetMinimumOrderSubtotalAmount(Customer customer, Store store, Currency currency);

    /// <summary>
    /// Calculates the remaining amount needed to meet minimum order requirements
    /// </summary>
    /// <param name="customer">Customer</param>
    /// <param name="store">Store</param>
    /// <param name="currency">Currency</param>
    /// <param name="shoppingCart">Shopping cart items</param>
    /// <returns>Remaining amount or zero if minimum is met</returns>
    Task<double> GetRemainingAmountForMinimumOrder(Customer customer, Store store, Currency currency, IList<ShoppingCartItem> shoppingCart);

    /// <summary>
    /// Checks if the current shopping cart meets minimum order requirements
    /// </summary>
    /// <param name="customer">Customer</param>
    /// <param name="store">Store</param>
    /// <param name="currency">Currency</param>
    /// <param name="shoppingCart">Shopping cart items</param>
    /// <returns>True if minimum requirements are met</returns>
    Task<bool> MeetsMinimumOrderRequirements(Customer customer, Store store, Currency currency, IList<ShoppingCartItem> shoppingCart);

    /// <summary>
    /// Gets formatted minimum order information for display
    /// </summary>
    /// <param name="customer">Customer</param>
    /// <param name="store">Store</param>
    /// <param name="currency">Currency</param>
    /// <param name="shoppingCart">Shopping cart items</param>
    /// <returns>Formatted minimum order information</returns>
    Task<MinimumOrderInfo> GetMinimumOrderInfo(Customer customer, Store store, Currency currency, IList<ShoppingCartItem> shoppingCart);
}

/// <summary>
/// Represents minimum order information
/// </summary>
public class MinimumOrderInfo
{
    /// <summary>
    /// The minimum order amount required
    /// </summary>
    public double MinimumOrderAmount { get; set; }

    /// <summary>
    /// The remaining amount needed to meet minimum order
    /// </summary>
    public double RemainingAmount { get; set; }

    /// <summary>
    /// Whether the minimum order requirement is met
    /// </summary>
    public bool IsMet { get; set; }

    /// <summary>
    /// Currency code
    /// </summary>
    public string CurrencyCode { get; set; }

    /// <summary>
    /// Formatted minimum order amount string
    /// </summary>
    public string FormattedMinimumAmount { get; set; }

    /// <summary>
    /// Formatted remaining amount string
    /// </summary>
    public string FormattedRemainingAmount { get; set; }

    /// <summary>
    /// Current cart subtotal
    /// </summary>
    public double CartSubtotal { get; set; }

    /// <summary>
    /// Formatted cart subtotal string
    /// </summary>
    public string FormattedCartSubtotal { get; set; }
}