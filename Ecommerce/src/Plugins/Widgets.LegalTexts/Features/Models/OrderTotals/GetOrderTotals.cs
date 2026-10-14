using DotLiquid;
using Grand.Domain.Customers;
using Grand.Domain.Directory;
using Grand.Domain.Localization;
using Grand.Domain.Orders;
using Grand.Domain.Stores;
using Grand.Domain.Tax;
using MediatR;
using System;
using Widgets.LegalTexts.Models;

namespace Widgets.LegalTexts.Features.Models.OrderTotals;

public class GetOrderTotals: IRequest<LiquidOrderTotals>
{
    public Customer Customer { get; set; }
    public Language Language { get; set; }
    public Currency Currency { get; set; }
    public Store Store { get; set; }
    public TaxDisplayType TaxDisplayType { get; set; }
    public IList<ShoppingCartItem> Cart { get; set; }
    public bool IsEditable { get; set; }
}
