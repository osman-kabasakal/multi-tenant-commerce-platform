using DotLiquid;
using Grand.Business.Core.Utilities.Messages.DotLiquidDrops;
using Grand.Domain.Catalog;
using Grand.Domain.Customers;
using Grand.Domain.Localization;
using Grand.Domain.Orders;
using Grand.Domain.Payments;
using Grand.Domain.Stores;

namespace Widgets.LegalTexts.Models;

public class LegalTextMessageTemplateToken : Drop
{

    public LegalTextMessageTemplateToken()
    {
    }

    public Drop Store { get; set; }
    public Drop Customer { get; set; }
    public Drop ShippingAdress { get; set; }
    public Drop BillingAdress { get; set; }
    public Drop ShoppingCart { get; set; }
    public Drop OrderTotals { get; set; }

}

public class CustomLiquidShoppingCartItem : LiquidShoppingCartItem
{
    public CustomLiquidShoppingCartItem(Product product, string attributeDescription, string pictureUrl, ShoppingCartItem shoppingCartItem, Language language) : base(product, attributeDescription, pictureUrl, shoppingCartItem, language)
    {
    }

    public string UnitPrice { get; set; }
    public string SubTotal { get; set; }
}

public class CustomLiquidShoppingCart : LiquidShoppingCart
{
    public CustomLiquidShoppingCart(Customer customer) : base(customer)
    {
    }

    public DateTime OrderDate { get; set; } = DateTime.UtcNow;
}

public class LiquidOrderTotals : Drop
{
    public string SubTotal { get; set; }
    public bool SubTotalIncludingTax { get; set; }
    public string SubTotalDiscount { get; set; }
    public string Shipping { get; set; }
    public string SelectedShippingMethod { get; set; }
    public string PaymentMethodAdditionalFee { get; set; }
    public string Tax { get; set; }
    public bool DisplayTax { get; set; }
    public string OrderTotalDiscount { get; set; }
    public string RedeemedLoyaltyPointsAmount { get; set; }
    public string OrderTotal { get; set; }
    public bool RequiresShipping { get; set; }
    public bool DisplayTaxRates { get; set; }

    public DateTime CreatedDate { get; set; }= DateTime.UtcNow;
}

public class LiquidShippingAdress : Drop
{
    public string FullName { get; set; }
    public string Address { get; set; }
    public string Phone { get; set; }
    public string Email { get; set; }
    public string ShippingMethod { get; set; }
    public string TrackingNumber { get; set; }
    public DateTime? EstimatedDeliveryDate { get; set; }
}

public class LiquidBillingAdress : Drop
{
    public string FullName { get; set; }
    public string CompanyName { get; set; }
    public string Address { get; set; }
    public string Phone { get; set; }
    public string Email { get; set; }
    public string TaxNumber { get; set; }
}