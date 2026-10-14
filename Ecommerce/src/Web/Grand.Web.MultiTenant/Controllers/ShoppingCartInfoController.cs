using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Checkout.Shipping;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Domain.Common;
using Grand.Domain.Orders;
using Grand.Infrastructure;
using Grand.Web.Common.Controllers;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace Grand.Web.MultiTenant.Controllers
{
    /// <summary>
    /// API Controller for providing shopping cart information including minimum order and free shipping details
    /// </summary>
    public class ShoppingCartInfoController : BasePublicController
    {
        private readonly IWorkContext _workContext;
        private readonly IOrderMinimumService _orderMinimumService;
        private readonly IFreeShippingService _freeShippingService;
        private readonly IShoppingCartService _shoppingCartService;
        private readonly ICurrencyService _currencyService;

        public ShoppingCartInfoController(
            IWorkContext workContext,
            IOrderMinimumService orderMinimumService,
            IFreeShippingService freeShippingService,
            IShoppingCartService shoppingCartService,
            ICurrencyService currencyService)
        {
            _workContext = workContext;
            _orderMinimumService = orderMinimumService;
            _freeShippingService = freeShippingService;
            _shoppingCartService = shoppingCartService;
            _currencyService = currencyService;
        }

        /// <summary>
        /// Gets comprehensive shopping cart information including minimum order and free shipping details
        /// </summary>
        /// <returns>Shopping cart information</returns>
        [HttpGet]
        public async Task<IActionResult> GetShoppingCartInfo()
        {
            var customer = _workContext.CurrentCustomer;
            var store = _workContext.CurrentStore;
            var currency = _workContext.WorkingCurrency;

            // Get customer's shopping cart
            var cart = await _shoppingCartService.GetShoppingCart(store.Id, ShoppingCartType.ShoppingCart);

            if (!cart.Any())
            {
                return Ok(new ShoppingCartInfoResponse
                {
                    Success = false,
                    Message = "Shopping cart is empty",
                    CartIsEmpty = true
                });
            }

            // Get customer's shipping address
            Address shippingAddress = null;
            if (customer.ShippingAddress!=null && !string.IsNullOrEmpty(customer.ShippingAddress.Id))
            {
                shippingAddress = customer.Addresses.FirstOrDefault(a => a.Id == customer.ShippingAddress.Id);
            }

            // Get minimum order information
            var minimumOrderInfo = await _orderMinimumService.GetMinimumOrderInfo(customer, store, currency, cart);

            // Get free shipping information
            var freeShippingInfo = await _freeShippingService.GetFreeShippingInfo(customer, store, currency, cart, shippingAddress);

            // Prepare response
            var response = new ShoppingCartInfoResponse
            {
                Success = true,
                CartIsEmpty = false,
                CanCheckout = minimumOrderInfo.IsMet,
                
                MinimumOrder = new MinimumOrderInfoDto
                {
                    MinimumOrderAmount = minimumOrderInfo.MinimumOrderAmount,
                    RemainingAmount = minimumOrderInfo.RemainingAmount,
                    IsMet = minimumOrderInfo.IsMet,
                    CurrencyCode = minimumOrderInfo.CurrencyCode,
                    FormattedMinimumAmount = minimumOrderInfo.FormattedMinimumAmount,
                    FormattedRemainingAmount = minimumOrderInfo.FormattedRemainingAmount
                },

                FreeShipping = new FreeShippingInfoDto
                {
                    IsFreeShippingActive = freeShippingInfo.IsFreeShippingActive,
                    MinimumAmountForFreeShipping = freeShippingInfo.MinimumAmountForFreeShipping,
                    RemainingAmountForFreeShipping = freeShippingInfo.RemainingAmountForFreeShipping,
                    FreeShippingDescription = freeShippingInfo.FreeShippingDescription,
                    FreeShippingSource = freeShippingInfo.FreeShippingSource,
                    CurrencyCode = freeShippingInfo.CurrencyCode,
                    FormattedMinimumAmount = freeShippingInfo.FormattedMinimumAmount,
                    FormattedRemainingAmount = freeShippingInfo.FormattedRemainingAmount
                },

                CartSummary = new CartSummaryDto
                {
                    Subtotal = minimumOrderInfo.CartSubtotal,
                    FormattedSubtotal = minimumOrderInfo.FormattedCartSubtotal,
                    ItemCount = cart.Sum(x => x.Quantity),
                    CurrencyCode = currency.CurrencyCode
                }
            };

            // Add validation messages if needed
            if (!minimumOrderInfo.IsMet)
            {
                response.ValidationMessages.Add($"Minimum order amount of {minimumOrderInfo.FormattedMinimumAmount} not reached. Add {minimumOrderInfo.FormattedRemainingAmount} more to your cart.");
            }

            if (freeShippingInfo.RemainingAmountForFreeShipping.HasValue && freeShippingInfo.RemainingAmountForFreeShipping.Value > 0)
            {
                response.ValidationMessages.Add($"Add {freeShippingInfo.FormattedRemainingAmount} more to qualify for free shipping.");
            }

            return Ok(response);
        }
    }

    #region DTOs

    public class ShoppingCartInfoResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public bool CartIsEmpty { get; set; }
        public bool CanCheckout { get; set; }
        public MinimumOrderInfoDto MinimumOrder { get; set; }
        public FreeShippingInfoDto FreeShipping { get; set; }
        public CartSummaryDto CartSummary { get; set; }
        public List<string> ValidationMessages { get; set; } = new List<string>();
    }

    public class MinimumOrderInfoDto
    {
        public double MinimumOrderAmount { get; set; }
        public double RemainingAmount { get; set; }
        public bool IsMet { get; set; }
        public string CurrencyCode { get; set; }
        public string FormattedMinimumAmount { get; set; }
        public string FormattedRemainingAmount { get; set; }
    }

    public class FreeShippingInfoDto
    {
        public bool IsFreeShippingActive { get; set; }
        public double? MinimumAmountForFreeShipping { get; set; }
        public double? RemainingAmountForFreeShipping { get; set; }
        public string FreeShippingDescription { get; set; }
        public string FreeShippingSource { get; set; }
        public string CurrencyCode { get; set; }
        public string FormattedMinimumAmount { get; set; }
        public string FormattedRemainingAmount { get; set; }
    }

    public class CartSummaryDto
    {
        public double Subtotal { get; set; }
        public string FormattedSubtotal { get; set; }
        public int ItemCount { get; set; }
        public string CurrencyCode { get; set; }
    }

    #endregion
}