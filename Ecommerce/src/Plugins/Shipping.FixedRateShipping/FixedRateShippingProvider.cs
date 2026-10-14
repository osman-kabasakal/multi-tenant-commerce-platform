using Grand.Business.Core.Enums.Checkout;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Catalog.Prices;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Catalog.Tax;
using Grand.Business.Core.Interfaces.Checkout.Shipping;
using Grand.Business.Core.Interfaces.Common.Addresses;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Utilities.Checkout;
using Grand.Domain.Common;
using Grand.Domain.Orders;
using Grand.Domain.Shipping;
using Grand.Infrastructure;
using Microsoft.Extensions.Logging;
using Shipping.FixedRateShipping.Models;
using Shipping.FixedRateShipping.Services;
using System.Globalization;
using System.Linq;

namespace Shipping.FixedRateShipping;

public class FixedRateShippingProvider : IShippingRateCalculationProvider
{
    private readonly ICurrencyService _currencyService;
    private readonly ISettingService _settingService;
    private readonly ShippingFixedRateSettings _shippingFixedRateSettings;
    private readonly IDeliveryAreaService _deliveryAreaService;
    private readonly IPricingService _pricingService;
    private readonly ITaxService _taxService;
    private readonly IProductService _productService;
    private readonly IAddressAttributeService _addressAttributeService;
    private readonly ILogger<FixedRateShippingProvider> _logger;
    private readonly IShippingMethodService _shippingMethodService;
    private readonly ITranslationService _translationService;
    private readonly IWorkContext _workContext;


    public FixedRateShippingProvider(
        IShippingMethodService shippingMethodService,
        IWorkContext workContext,
        ISettingService settingService,
        ICurrencyService currencyService,
        ITranslationService translationService,
        ShippingFixedRateSettings shippingFixedRateSettings,
        IDeliveryAreaService deliveryAreaService,
        IPricingService pricingService,
        ITaxService taxService,
        IProductService productService,
        IAddressAttributeService addressAttributeService,
        ILogger<FixedRateShippingProvider> logger)
    {
        _shippingMethodService = shippingMethodService;
        _workContext = workContext;
        _settingService = settingService;
        _currencyService = currencyService;
        _translationService = translationService;
        _shippingFixedRateSettings = shippingFixedRateSettings;
        _deliveryAreaService = deliveryAreaService;
        _pricingService = pricingService;
        _taxService = taxService;
        _productService = productService;
        _addressAttributeService = addressAttributeService;
        _logger = logger;
    }


    /// <summary>
    ///     Gets available shipping options
    /// </summary>
    /// <param name="getShippingOptionRequest">A request for getting shipping options</param>
    /// <returns>Represents a response of getting shipping rate options</returns>
    public async Task<GetShippingOptionResponse> GetShippingOptions(GetShippingOptionRequest getShippingOptionRequest)
    {
        ArgumentNullException.ThrowIfNull(getShippingOptionRequest);

        try
        {
            var response = new GetShippingOptionResponse();

            if (getShippingOptionRequest.Items == null || getShippingOptionRequest.Items.Count == 0)
            {
                response.AddError("No shipment items");
                return response;
            }

            // Check if delivery address has coordinates
            var latitude = 0.0;
            var longitude = 0.0;
            bool hasCoordinates = false;

            var allAttributes = await _addressAttributeService.GetAllAddressAttributes();
            var latAttributeId = allAttributes.FirstOrDefault(a => a.Name == "lat")?.Id;
            var longAttributeId = allAttributes.FirstOrDefault(a => a.Name == "long")?.Id;

            if (getShippingOptionRequest.ShippingAddress is { Attributes: not null } 
                && _shippingFixedRateSettings.DeliveryAreas!=null 
                && _shippingFixedRateSettings.DeliveryAreas.Count != 0)
            {
                var latAttribute = getShippingOptionRequest.ShippingAddress.Attributes
                    .FirstOrDefault(a => a.Key == latAttributeId);
                var longAttribute = getShippingOptionRequest.ShippingAddress.Attributes
                    .FirstOrDefault(a => a.Key == longAttributeId);

                if (latAttribute != null && longAttribute != null)
                {
                    if (double.TryParse(latAttribute.Value, CultureInfo.InvariantCulture, out latitude) &&
                        double.TryParse(longAttribute.Value, CultureInfo.InvariantCulture, out longitude))
                    {
                        hasCoordinates = true;
                    }
                }
            }

            var restrictByCountryId =
                getShippingOptionRequest.ShippingAddress != null &&
                !string.IsNullOrEmpty(getShippingOptionRequest.ShippingAddress.CountryId)
                    ? getShippingOptionRequest.ShippingAddress.CountryId
                    : "";

            var shippingMethods =
                await _shippingMethodService.GetAllShippingMethods(restrictByCountryId,
                    getShippingOptionRequest.Customer);

            // Calculate subtotal for minimum order amount validation
            double subtotal = 0.0;
            foreach (var packageItem in getShippingOptionRequest.Items)
            {
                var cartItem = packageItem.ShoppingCartItem;
                var product = await _productService.GetProductById(cartItem.ProductId);
                var (subTotal, _, _) = await _pricingService.GetSubTotal(cartItem, product);
                var shoppingCartItemSubTotalWithDiscount =
                    (await _taxService.GetProductPrice(product, subTotal)).productprice;

                subtotal += shoppingCartItemSubTotalWithDiscount;
            }


            foreach (var shippingMethod in shippingMethods)
            {
                DeliveryArea matchingDeliveryArea = null;

                // If coordinates are available, check if the address is within any delivery area
                if (hasCoordinates 
                    && _shippingFixedRateSettings.DeliveryAreas!.ContainsKey(shippingMethod.Id)
                    && _shippingFixedRateSettings.DeliveryAreas[shippingMethod.Id].Count > 0
                    )
                {
                    
                    matchingDeliveryArea = await _deliveryAreaService.GetMatchingDeliveryArea(
                        shippingMethod.Id, latitude, longitude);

                    // If no matching delivery area found, skip this shipping method
                    if (matchingDeliveryArea == null)
                    {
                        response.AddError( string.Format( _translationService
                            .GetResource("Plugins.Shipping.FixedRateShipping.DeliveryAreaNotFound"),shippingMethod.GetTranslation(x => x.Name, _workContext.WorkingLanguage.Id)));
                        continue;
                    }
                    
                    // Check minimum order amount
                    if (subtotal < matchingDeliveryArea.MinimumOrderAmount)
                    {
                        response.AddError(_translationService
                            .GetResource("Plugins.Shipping.FixedRateShipping.MinimumOrderAmountNotReached")
                            .Replace("{0}", matchingDeliveryArea.MinimumOrderAmount.ToString("C")));
                        continue;
                    }

                    // Calculate shipping rate based on free shipping settings
                    double shippingRate = matchingDeliveryArea.ShippingRate;
                    
                    // Check if free shipping is enabled and conditions are met
                    if (matchingDeliveryArea.UseFreeShipping && 
                        matchingDeliveryArea.FreeShippingOrderAmount > 0 && 
                        subtotal >= matchingDeliveryArea.FreeShippingOrderAmount)
                    {
                        shippingRate = 0;
                    }
                    // else if(matchingDeliveryArea.UseFreeShipping && 
                    //        matchingDeliveryArea.FreeShippingOrderAmount > 0)
                    // {
                    //     response.Errors.Add(_translationService
                    //         .GetResource("Plugins.Shipping.FixedRateShipping.FreeShippingOrderAmountNotReached")
                    //         .Replace("{0}", (await _currencyService.ConvertFromPrimaryStoreCurrency(
                    //             (matchingDeliveryArea.FreeShippingOrderAmount - shippingRate), _workContext.WorkingCurrency)).ToString("C")));
                    // }
                    
                    // Add shipping option with calculated rate
                    var shippingOption = new ShippingOption {
                        Name = shippingMethod.GetTranslation(x => x.Name, _workContext.WorkingLanguage.Id),
                        Description =
                            shippingMethod.GetTranslation(x => x.Description, _workContext.WorkingLanguage.Id),
                        Rate = await _currencyService.ConvertFromPrimaryStoreCurrency(
                            shippingRate, _workContext.WorkingCurrency)
                    };
                    response.ShippingOptions.Add(shippingOption);
                }
                else
                {
                    // No coordinates available, use the default rate
                    var shippingOption = new ShippingOption {
                        Name = shippingMethod.GetTranslation(x => x.Name, _workContext.WorkingLanguage.Id),
                        Description =
                            shippingMethod.GetTranslation(x => x.Description, _workContext.WorkingLanguage.Id),
                        Rate = await _currencyService.ConvertFromPrimaryStoreCurrency(
                            GetRate(shippingMethod.Id), _workContext.WorkingCurrency)
                    };
                    response.ShippingOptions.Add(shippingOption);
                }
            }
            return response;
        }
        catch (Exception e)
        {
            _logger.LogError(e," Error getting shipping options");
            return new GetShippingOptionResponse();
        }
    }

    /// <summary>
    /// Gets fixed shipping rate (if Shipping rate method allows it and the rate can be calculated before checkout).
    /// </summary>
    /// <param name="getShippingOptionRequest">A request for getting shipping options</param>
    /// <returns>Fixed shipping rate; or null in case there's no fixed shipping rate</returns>
    public async Task<double?> GetFixedRate(GetShippingOptionRequest getShippingOptionRequest)
    {
        ArgumentNullException.ThrowIfNull(getShippingOptionRequest);

        try
        {
            if (getShippingOptionRequest.Items == null || getShippingOptionRequest.Items.Count == 0)
            {
                return null;
            }

            // Teslimat adresi koordinatlarını kontrol et
            var latitude = 0.0;
            var longitude = 0.0;
            bool hasCoordinates = false;

            var allAttributes = await _addressAttributeService.GetAllAddressAttributes();
            var latAttributeId = allAttributes.FirstOrDefault(a => a.Name == "lat")?.Id;
            var longAttributeId = allAttributes.FirstOrDefault(a => a.Name == "long")?.Id;

            if (getShippingOptionRequest.ShippingAddress is { Attributes: not null } && _shippingFixedRateSettings.DeliveryAreas!=null && _shippingFixedRateSettings.DeliveryAreas.Count != 0)
            {
                var latAttribute = getShippingOptionRequest.ShippingAddress.Attributes
                    .FirstOrDefault(a => a.Key == latAttributeId);
                var longAttribute = getShippingOptionRequest.ShippingAddress.Attributes
                    .FirstOrDefault(a => a.Key == longAttributeId);

                if (latAttribute != null && longAttribute != null)
                {
                    if (double.TryParse(latAttribute.Value, CultureInfo.InvariantCulture, out latitude) &&
                        double.TryParse(longAttribute.Value, CultureInfo.InvariantCulture, out longitude))
                    {
                        hasCoordinates = true;
                    }
                }
            }

            var restrictByCountryId =
                getShippingOptionRequest.ShippingAddress != null &&
                !string.IsNullOrEmpty(getShippingOptionRequest.ShippingAddress.CountryId)
                    ? getShippingOptionRequest.ShippingAddress.CountryId
                    : "";

            var shippingMethods =
                await _shippingMethodService.GetAllShippingMethods(restrictByCountryId,
                    getShippingOptionRequest.Customer);

            // Minimum sipariş tutarı için alt toplam hesapla
            double subtotal = 0.0;
            foreach (var packageItem in getShippingOptionRequest.Items)
            {
                var cartItem = packageItem.ShoppingCartItem;
                var product = await _productService.GetProductById(cartItem.ProductId);
                var (subTotal, _, _) = await _pricingService.GetSubTotal(cartItem, product);
                var shoppingCartItemSubTotalWithDiscount =
                    (await _taxService.GetProductPrice(product, subTotal)).productprice;

                subtotal += shoppingCartItemSubTotalWithDiscount;
            }

            var rates = new List<double>();
            foreach (var shippingMethod in shippingMethods)
            {
                if (hasCoordinates)
                {

                    // Koordinatlar varsa, teslimat bölgesi kontrolü yap
                    var matchingDeliveryArea = await _deliveryAreaService.GetMatchingDeliveryArea(
                        shippingMethod.Id, latitude, longitude);

                    if (matchingDeliveryArea != null && subtotal >= matchingDeliveryArea.MinimumOrderAmount)
                    {
                        // Calculate shipping rate based on free shipping settings
                        double shippingRate = matchingDeliveryArea.ShippingRate;
                        
                        // Check if free shipping is enabled and conditions are met
                        if (matchingDeliveryArea.UseFreeShipping && 
                            matchingDeliveryArea.FreeShippingOrderAmount > 0 && 
                            subtotal >= matchingDeliveryArea.FreeShippingOrderAmount)
                        {
                            shippingRate = 0;
                        }
                        
                        rates.Add(shippingRate);
                    }
                }
                else
                {
                    // Koordinat yoksa varsayılan oranı kullan
                    var rate = GetRate(shippingMethod.Id);
                    if (!rates.Contains(rate))
                        rates.Add(rate);
                }
            }

            // Eğer tek bir oran varsa, bu sabit oran olarak kabul edilebilir
            return rates.Count switch
            {
                1 => rates[0],
                0 => 0,
                _ => rates.Min()
            };
        }
        catch (Exception e)
        {
            _logger.LogError(e," Error calculating fixed shipping rate");
            return 0;
        }
    }

    public ShippingRateCalculationType ShippingRateCalculationType => ShippingRateCalculationType.Off;

    public IShipmentTracker ShipmentTracker => null;

    public async Task<IList<string>> ValidateShippingForm(string shippingOption, IDictionary<string, string> data)
    {
        return await Task.FromResult(new List<string>());
    }

    public async Task<string> GetControllerRouteName()
    {
        return await Task.FromResult("");
    }

    public async Task<bool> HideShipmentMethods(IList<ShoppingCartItem> cart)
    {
        return await Task.FromResult(false);
    }

    public string ConfigurationUrl => FixedRateShippingDefaults.ConfigurationUrl;
    public string SystemName => FixedRateShippingDefaults.ProviderSystemName;
    public string FriendlyName => _translationService.GetResource(FixedRateShippingDefaults.FriendlyName);
    public int Priority => _shippingFixedRateSettings.DisplayOrder;
    public IList<string> LimitedToStores => new List<string>();
    public IList<string> LimitedToGroups => new List<string>();

    #region Utilities

    private double GetRate(string shippingMethodId)
    {
        var key = $"ShippingRateComputationMethod.FixedRate.Rate.ShippingMethodId{shippingMethodId}";
        var rate = _settingService.GetSettingByKey<FixedShippingRate>(key)?.Rate;
        return rate ?? 0;
    }

    #endregion

    #region New Methods for Minimum Order and Free Shipping

    public async Task<double?> GetOrderSubtotalMinimumAmount(Grand.Domain.Customers.Customer customer, Grand.Domain.Stores.Store store, Grand.Domain.Directory.Currency currency)
    {
        try
        {
            if (_shippingFixedRateSettings.DeliveryAreas == null || !_shippingFixedRateSettings.DeliveryAreas.Any())
                return null;

            // Get all delivery areas for all shipping methods
            var allMinimumAmounts = new List<double>();

            foreach (var deliveryAreasByMethod in _shippingFixedRateSettings.DeliveryAreas)
            {
                foreach (var deliveryArea in deliveryAreasByMethod.Value)
                {
                    if (deliveryArea.MinimumOrderAmount > 0)
                    {
                        allMinimumAmounts.Add(deliveryArea.MinimumOrderAmount);
                    }
                }
            }

            // Return the smallest minimum amount among all delivery areas
            return allMinimumAmounts.Any() ? allMinimumAmounts.Min() : (double?)null;
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error getting minimum order amount");
            return null;
        }
    }

    public async Task<FreeShippingInfo> GetFreeShippingInfo(Grand.Domain.Customers.Customer customer, IList<ShoppingCartItem> shoppingCart, Grand.Domain.Common.Address shippingAddress)
    {
        try
        {
            var freeShippingInfo = new FreeShippingInfo
            {
                IsFreeShippingAvailable = false,
                MeetsFreeShippingConditions = false
            };

            if (_shippingFixedRateSettings.DeliveryAreas == null || !_shippingFixedRateSettings.DeliveryAreas.Any())
                return freeShippingInfo;

            // Check if address has coordinates
            var latitude = 0.0;
            var longitude = 0.0;
            bool hasCoordinates = false;

            if (shippingAddress?.Attributes != null)
            {
                var allAttributes = await _addressAttributeService.GetAllAddressAttributes();
                var latAttributeId = allAttributes.FirstOrDefault(a => a.Name == "lat")?.Id;
                var longAttributeId = allAttributes.FirstOrDefault(a => a.Name == "long")?.Id;

                var latAttribute = shippingAddress.Attributes.FirstOrDefault(a => a.Key == latAttributeId);
                var longAttribute = shippingAddress.Attributes.FirstOrDefault(a => a.Key == longAttributeId);

                if (latAttribute != null && longAttribute != null)
                {
                    if (double.TryParse(latAttribute.Value, CultureInfo.InvariantCulture, out latitude) &&
                        double.TryParse(longAttribute.Value, CultureInfo.InvariantCulture, out longitude))
                    {
                        hasCoordinates = true;
                    }
                }
            }

            // Calculate cart subtotal
            double subtotal = 0.0;
            foreach (var item in shoppingCart)
            {
                var product = await _productService.GetProductById(item.ProductId);
                if (product != null)
                {
                    var (subTotal, _, _) = await _pricingService.GetSubTotal(item, product);
                    var shoppingCartItemSubTotalWithDiscount = (await _taxService.GetProductPrice(product, subTotal)).productprice;
                    subtotal += shoppingCartItemSubTotalWithDiscount;
                }
            }

            // Find the best free shipping option across all delivery areas
            double? lowestFreeShippingThreshold = null;
            DeliveryArea bestDeliveryArea = null;

            if (hasCoordinates)
            {
                // Check all shipping methods for the matching delivery area
                var shippingMethods = await _shippingMethodService.GetAllShippingMethods(customer: customer);
                
                foreach (var shippingMethod in shippingMethods)
                {
                    if (_shippingFixedRateSettings.DeliveryAreas.ContainsKey(shippingMethod.Id))
                    {
                        var matchingDeliveryArea = await _deliveryAreaService.GetMatchingDeliveryArea(
                            shippingMethod.Id, latitude, longitude);

                        if (matchingDeliveryArea != null && 
                            matchingDeliveryArea.UseFreeShipping && 
                            matchingDeliveryArea.FreeShippingOrderAmount > 0)
                        {
                            if (!lowestFreeShippingThreshold.HasValue || 
                                matchingDeliveryArea.FreeShippingOrderAmount < lowestFreeShippingThreshold.Value)
                            {
                                lowestFreeShippingThreshold = matchingDeliveryArea.FreeShippingOrderAmount;
                                bestDeliveryArea = matchingDeliveryArea;
                            }
                        }
                    }
                }
            }

            if (bestDeliveryArea != null && lowestFreeShippingThreshold.HasValue)
            {
                freeShippingInfo.IsFreeShippingAvailable = true;
                freeShippingInfo.MinimumOrderAmountForFreeShipping = lowestFreeShippingThreshold.Value;
                freeShippingInfo.MeetsFreeShippingConditions = subtotal >= lowestFreeShippingThreshold.Value;
                freeShippingInfo.FreeShippingConditionDescription = $"Free shipping for orders over {lowestFreeShippingThreshold.Value:C}";
                
                if (!freeShippingInfo.MeetsFreeShippingConditions)
                {
                    freeShippingInfo.AmountRemainingForFreeShipping = lowestFreeShippingThreshold.Value - subtotal;
                }
            }

            return freeShippingInfo;
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error getting free shipping info");
            return new FreeShippingInfo
            {
                IsFreeShippingAvailable = false,
                MeetsFreeShippingConditions = false
            };
        }
    }

    #endregion
}