using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Catalog.Prices;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Catalog.Tax;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Business.Core.Utilities.Messages.DotLiquidDrops;
using Grand.Domain.Catalog;
using Grand.Domain.Common;
using Grand.Domain.Orders;
using Grand.Infrastructure;
using Grand.Infrastructure.Mapper;
using Grand.Web.Common.Components;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Widgets.LegalTexts.Features.Models.OrderTotals;
using Widgets.LegalTexts.Models;
using Widgets.LegalTexts.Services;

namespace Widgets.LegalTexts.Components;

[ViewComponent(Name = "LegalTextsView")]
public class LegalTextsViewComponent : BaseViewComponent
{
    private readonly IMediator _mediator;
    private readonly IWorkContext _workContext;
    private readonly ILegalTextMessageTemplateService _legalTextMessageTemplateService;
    private readonly IShoppingCartService _shoppingCartService;
    private readonly ICountryService _countryService;
    private readonly IProductService _productService;
    private readonly IPictureService _pictureService;
    private readonly IProductAttributeFormatter _productAttributeFormatter;
    private readonly ITaxService _taxService;
    private readonly IPricingService _pricingService;
    private readonly IPriceFormatter _priceFormatter;

    public LegalTextsViewComponent(
        IMediator mediator,
        IWorkContext workContext,
        ILegalTextMessageTemplateService legalTextMessageTemplateService,
        IShoppingCartService shoppingCartService,
        ICountryService countryService,
        IProductService productService,
        IPictureService pictureService,
        IProductAttributeFormatter productAttributeFormatter,
        ITaxService taxService,
        IPricingService pricingService,
        IPriceFormatter priceFormatter
    )
    {
        _mediator = mediator;
        _workContext = workContext;
        _legalTextMessageTemplateService = legalTextMessageTemplateService;
        _shoppingCartService = shoppingCartService;
        _countryService = countryService;
        _productService = productService;
        _pictureService = pictureService;
        _productAttributeFormatter = productAttributeFormatter;
        _taxService = taxService;
        _pricingService = pricingService;
        _priceFormatter = priceFormatter;
    }

    public async Task<IViewComponentResult> InvokeAsync(string categoryName, object additionalData = null)
    {
        var messageTemplates = await _legalTextMessageTemplateService.GetMessageTemplateByCategory(categoryName);

        foreach (var messageTemplate in messageTemplates)
        {
            messageTemplate.Body = messageTemplate.GetTranslation(x => x.Body, _workContext.WorkingLanguage.Id);
            messageTemplate.Name = messageTemplate.GetTranslation(x => x.Name, _workContext.WorkingLanguage.Id);
        }



        var liquidObject = new LiquidObjectBuilder(_mediator)
        .AddStoreTokens(_workContext.CurrentStore, _workContext.WorkingLanguage, new Grand.Domain.Messages.EmailAccount {
            Email = _workContext.CurrentStore.CompanyEmail,
            DisplayName = _workContext.CurrentStore.CompanyName,
        })
        .AddCustomerTokens(_workContext.CurrentCustomer, _workContext.CurrentStore, _workContext.CurrentHost, _workContext.WorkingLanguage);

        var cart = await _shoppingCartService.GetShoppingCart(_workContext.CurrentStore.Id,
            ShoppingCartType.ShoppingCart);

        var orderTotals = await _mediator.Send(new GetOrderTotals() {
            Cart = cart,
            IsEditable = true,
            Store = _workContext.CurrentStore,
            Currency = _workContext.WorkingCurrency,
            Customer = _workContext.CurrentCustomer,
            Language = _workContext.WorkingLanguage,
            TaxDisplayType = _workContext.TaxDisplayType
        });

        var liquidObjectToken = await liquidObject.BuildAsync();

        var legalTextTokens = new LegalTextMessageTemplateToken() {
            Store = liquidObjectToken.Store,
            Customer = liquidObjectToken.Customer,
            ShippingAdress = cart.RequiresShipping() && _workContext.CurrentCustomer.ShippingAddress != null ? new LiquidShippingAdress() {
                FullName = _workContext.CurrentCustomer.ShippingAddress.FirstName + " " + _workContext.CurrentCustomer.ShippingAddress.LastName,
                Address = await GetFormattedAddress(_workContext.CurrentCustomer.ShippingAddress),
                Phone = _workContext.CurrentCustomer.ShippingAddress.PhoneNumber,
                Email = _workContext.CurrentCustomer.Email,
                ShippingMethod = orderTotals.SelectedShippingMethod,
                TrackingNumber = null,
                EstimatedDeliveryDate = null,
            } : new LiquidShippingAdress(),
            BillingAdress = _workContext.CurrentCustomer.BillingAddress != null ? new LiquidBillingAdress() {
                FullName = _workContext.CurrentCustomer.BillingAddress.FirstName + " " + _workContext.CurrentCustomer.BillingAddress.LastName,
                CompanyName = _workContext.CurrentCustomer.BillingAddress.Company,
                Address = await GetFormattedAddress(_workContext.CurrentCustomer.BillingAddress),
                Phone = _workContext.CurrentCustomer.BillingAddress.PhoneNumber,
                Email = _workContext.CurrentCustomer.BillingAddress.Email,
                TaxNumber = _workContext.CurrentCustomer.BillingAddress.VatNumber
            } : new LiquidBillingAdress(),
            ShoppingCart = await GetShopingCartItemPrice(),
            OrderTotals = orderTotals,
        };

        var model = messageTemplates.Select(x =>
        {
            var componentModel = x.MapTo<LegalTextMessageTemplate, LegalTextMessageTemplateComponentModel>();
            componentModel.TemplateText = Convert.ToBase64String(Encoding.UTF8.GetBytes(_legalTextMessageTemplateService.RenderTemplate(x, legalTextTokens)));
            return componentModel;
        }).ToList();

        return View(model);
    }

    private async Task<string> GetFormattedAddress(Address address)
    {
        var country = await _countryService.GetCountryById(address.CountryId);
        var states = await _countryService.GetStateProvincesByCountryId(address.CountryId);
        var stateProvince = states.FirstOrDefault(x => x.Id == address.StateProvinceId);
        var parts = new List<string>
        {
                address.Address1,
                !string.IsNullOrEmpty(address.Address2) ? address.Address2 : null,
                address.City,
                stateProvince?.Name,
                country?.Name,
                address.ZipPostalCode
            };

        return string.Join(", ", parts.Where(x => !string.IsNullOrEmpty(x)));
    }

    public async Task<LiquidShoppingCart> GetShopingCartItemPrice()
    {
        var liquidShoppingCart = new LiquidShoppingCart(_workContext.CurrentCustomer);
        await ProductList();
        async Task ProductList()
        {
            var attributeDescription = string.Empty;
            var pictureUrl = string.Empty;
            var shoppingCardItems = _workContext.CurrentCustomer.ShoppingCartItems.Where(x => x.ShoppingCartTypeId == ShoppingCartType.ShoppingCart).ToList();
            foreach (var item in shoppingCardItems)
            {
                var product = await _productService.GetProductById(item.ProductId);

                if (product == null){
                    await _shoppingCartService.DeleteShoppingCartItem(_workContext.CurrentCustomer,item);
                    continue;
                }

                if (product.ProductPictures.Count != 0)
                    pictureUrl = await _pictureService.GetPictureUrl(
                        product.ProductPictures.MinBy(x => x.DisplayOrder)?.PictureId, 100,
                        storeLocation: _workContext.CurrentStore.SslEnabled ? _workContext.CurrentStore.SecureUrl : _workContext.CurrentStore.Url);

                //attributes
                if (item.Attributes != null && item.Attributes.Any())
                    attributeDescription =
                        await _productAttributeFormatter.FormatAttributes(product, item.Attributes,
                            _workContext.CurrentCustomer);

                var result = new CustomLiquidShoppingCartItem(product, attributeDescription, pictureUrl, item,
                    _workContext.WorkingLanguage);


                var unitprice = await _pricingService.GetUnitPrice(item, product, true);
                var (subTotal, discountAmount, appliedDiscounts) = await _pricingService.GetSubTotal(item, product);
                var shoppingCartItemSubTotalWithDiscount =
                    (await _taxService.GetProductPrice(product, subTotal)).productprice;

                result.UnitPrice = _priceFormatter.FormatPrice(unitprice.unitprice);
                result.SubTotal = _priceFormatter.FormatPrice(shoppingCartItemSubTotalWithDiscount);
                liquidShoppingCart.Items.Add(result);
            }
        }
        return liquidShoppingCart;
    }
}
