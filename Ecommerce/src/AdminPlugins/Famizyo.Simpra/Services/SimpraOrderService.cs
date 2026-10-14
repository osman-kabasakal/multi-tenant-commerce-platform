using Famizyo.Simpra.Models;
using Famizyo.Simpra.Settings;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Checkout.CheckoutAttributes;
using Grand.Business.Core.Interfaces.Catalog.Tax;
using Grand.Data;
using Grand.Domain.Orders;
using Grand.Domain.Catalog;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;
using System.Text.Json;
using MongoDB.Driver;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Domain.Customers;
using MongoDB.Driver.Linq;
using System.Globalization;
using Order = Grand.Domain.Orders.Order;
using Grand.Business.Core.Commands.Checkout.Orders;
using Grand.Business.Core.Commands.Checkout.Shipping;
using Grand.Business.Core.Interfaces.Checkout.Payments;
using Grand.Business.Core.Interfaces.Checkout.Shipping;
using Grand.Business.Core.Interfaces.Common.Addresses;
using Grand.Domain.Payments;
using Grand.Domain.Shipping;
using MediatR;
using System.Text.RegularExpressions;

namespace Famizyo.Simpra.Services;

public class SimpraOrderService : ISimpraOrderService
{
    private readonly ISimpraApiService _simpraApiService;
    private readonly IOrderService _orderService;
    private readonly ICustomerService _customerService;
    private readonly ISettingService _settingService;
    private readonly IConnectionMultiplexer _redis;
    private readonly ILogger<SimpraOrderService> _logger;
    private readonly IUserFieldService _userFieldService;
    private readonly IRepository<Order> _orderRepository;
    private readonly IProductService _productService;
    private readonly ISimpraMenuItemMappingService _menuItemMappingService;
    private readonly ISimpraCondimentMappingService _condimentMappingService;
    private readonly IPaymentTransactionService _paymentTransactionService;
    private readonly IShipmentService _shipmentService;
    private readonly ICountryService _countryService;
    private readonly IAddressAttributeService _addressAttributeService;
    private readonly IProductAttributeService _productAttributeService;
    private readonly IProductAttributeFormatter _productAttributeFormatter;
    private readonly IPaymentService _paymentService;
    private readonly IMediator _mediator;
    private readonly ICheckoutAttributeParser _checkoutAttributeParser;
    private readonly ITaxService _taxService;
    private readonly ICurrencyService _currencyService;

    public SimpraOrderService(
        ISimpraApiService simpraApiService,
        IOrderService orderService,
        ICustomerService customerService,
        ISettingService settingService,
        IConnectionMultiplexer redis,
        ILogger<SimpraOrderService> logger,
        IUserFieldService userFieldService,
        IRepository<Order> orderRepository,
        IProductService productService,
        ISimpraMenuItemMappingService menuItemMappingService,
        ISimpraCondimentMappingService condimentMappingService,
        IPaymentTransactionService paymentTransactionService,
        IShipmentService shipmentService,
        ICheckoutAttributeParser checkoutAttributeParser,
        ITaxService taxService,
        ICurrencyService currencyService,
        ICountryService countryService,
        IAddressAttributeService addressAttributeService,
        IProductAttributeService productAttributeService,
        IProductAttributeFormatter productAttributeFormatter,
        IPaymentService paymentService,
        IMediator mediator)
    {
        _simpraApiService = simpraApiService;
        _orderService = orderService;
        _customerService = customerService;
        _settingService = settingService;
        _redis = redis;
        _logger = logger;
        _userFieldService = userFieldService;
        _orderRepository = orderRepository;
        _productService = productService;
        _menuItemMappingService = menuItemMappingService;
        _condimentMappingService = condimentMappingService;
        _paymentTransactionService = paymentTransactionService;
        _shipmentService = shipmentService;
        _checkoutAttributeParser = checkoutAttributeParser;
        _taxService = taxService;
        _currencyService = currencyService;
        _countryService = countryService;
        _addressAttributeService = addressAttributeService;
        _productAttributeService = productAttributeService;
        _productAttributeFormatter = productAttributeFormatter;
        _paymentService = paymentService;
        _mediator = mediator;
    }

    public async Task<SimpraCrudCheckResponse> SendOrderToSimpraAsync(Order order)
    {
        try
        {
            if (!await CanSendOrderToSimpraAsync(order) || order.ShippingAddress == null)
            {
                throw new InvalidOperationException("Order cannot be sent to Simpra");
            }

            // Only send orders with Preparing status
            if (order.OrderStatusId != (int)OrderStatusSystem.Processing && !(IsCashOnDeliveryPayment(order.PaymentMethodSystemName) && order.OrderStatusId == (int)OrderStatusSystem.Pending))
            {
                _logger.LogWarning("Order {OrderId} is not in Preparing status, skipping Simpra transfer", order.Id);
                return null;
            }

            var settings = _settingService.LoadSetting<SimpraSettings>();

            var tarifAttributeId = await AciklamaAttributeId();
            var tarif = order.ShippingAddress.Attributes?
                .FirstOrDefault(x => x.Key == tarifAttributeId)?.Value ?? "";

            var orderCheckoutAttributes =
                await _checkoutAttributeParser.ParseCheckoutAttributes(order.CheckoutAttributes);
            var checkoutAttributeText = new StringBuilder();
            foreach (var attribute in orderCheckoutAttributes)
            {
                var customAttribute = order.CheckoutAttributes
                    .FirstOrDefault(x => x.Key == attribute.Id);
                if (customAttribute == null)
                    continue;

                if (!attribute.ShouldHaveValues())
                {
                    var attributeValue = customAttribute?.Value;
                    if (!string.IsNullOrEmpty(attributeValue))
                        checkoutAttributeText.AppendLine($"{attribute.TextPrompt ?? attribute.Name}: {attributeValue}");
                }
                else
                {
                    var attributeValues = await _checkoutAttributeParser.ParseCheckoutAttributeValues(
                        order.CheckoutAttributes);
                    var selectedValues = attributeValues
                        .Where(x => x.CheckoutAttributeId == attribute.Id)
                        .Select(x => x.Name)
                        .ToList();

                    if (selectedValues.Any())
                    {
                        checkoutAttributeText.AppendLine(
                            $"{attribute.TextPrompt ?? attribute.Name}: {string.Join(", ", selectedValues)}");
                    }
                }
            }

            var customerPhone = string.Join("",
                Regex.Matches(order.ShippingAddress.PhoneNumber ?? "", @"\d+").Select(x => x.Value));
            
            var paymentInfo = _paymentService.LoadPaymentMethodBySystemName(order.PaymentMethodSystemName);
            

            var orderNotes = (await _orderService.GetOrderNotes(order.Id)) ?? [];
            var checkRequest = new SimpraCheckRequest {
                RevenueCenterId = settings.RevenueCenterId,
                SalesChannelId = settings.SalesChannelId,
                MenuItems = await ConvertOrderItemsToMenuItemsAsync(order),
                Customer = !string.IsNullOrEmpty(customerPhone)
                    ? new SimpraCustomerRequest {
                        PhoneNumber = customerPhone,
                        FirstName = order.ShippingAddress.FirstName,
                        LastName = order.ShippingAddress.LastName,
                        Email = order.ShippingAddress.Email
                    }
                    : null,
                Delivery = order.ShippingAddress != null
                    ? new SimpraDeliveryRequest {
                        Address = await ConvertAddressToStringAsync(order.ShippingAddress),
                        Note = order.PaymentStatusId == PaymentStatus.Paid ? "Ödendi" : IsCashOnDeliveryPayment(order.PaymentMethodSystemName)? $"Kapıda Ödeme ({(order.PaymentMethodSystemName.Contains("CreditCard", StringComparison.OrdinalIgnoreCase)?"Kredi Kartı":"Nakit")})": "Ödeme Bekleniyor",
                    }
                    : null,
                Note = string.Join("\n",
                    orderNotes.Where(x => x.CreatedByCustomer).Select(x => x.Note)
                        .Union([(paymentInfo!=null ? paymentInfo.FriendlyName:""),(order.ShippingAddress?.Note ?? ""), checkoutAttributeText.ToString(), tarif])),
                Extras = new List<SimpraCheckExtra> {
                    new SimpraCheckExtra { Key = "external_order_id", Value = order.Id },
                    new SimpraCheckExtra { Key = "order_number", Value = order.OrderNumber.ToString() }
                },
                Discounts = order.OrderDiscount == 0
                    ? []
                    : [
                        new SimpraDiscount {
                            Amount = (decimal)order.OrderDiscount,
                        }
                    ],
            };

            var response = await _simpraApiService.CreateCheckAsync(checkRequest);

            if (response.Success && response.Data != null)
            {
                await StoreSimpraCheckIdAsync(order, response.Data.check.id);

                // Create payment record
                //await CreatePaymentRecordAsync(response.Data.check.id, order);

                // Create service charges for fees
                await CreateServiceChargesForOrderAsync(response.Data.check.id, order);

                _logger.LogInformation("Order {OrderId} successfully sent to Simpra with Check ID {CheckId}",
                    order.Id, response.Data.check.id);
            }

            return response.Data;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error sending order {OrderId} to Simpra", order.Id);
            throw;
        }
    }

    private async Task<string?> AciklamaAttributeId()
    {
        var adressAttributes = await _addressAttributeService.GetAllAddressAttributes();
        return adressAttributes.FirstOrDefault(x => x.Name == "adres_tarifi")?.Id;
    }

    public async Task<bool> CancelOrderInSimpraAsync(string grandNodeOrderId, string? cancelReason = null)
    {
        try
        {
            var order = await _orderService.GetOrderById(grandNodeOrderId);
            if (order == null) return false;

            var simpraCheckId = GetSimpraCheckId(order);
            if (string.IsNullOrEmpty(simpraCheckId)) return false;

            // Cancel all check items
            var checkResponse = await _simpraApiService.GetCheckAsync(int.Parse(simpraCheckId));
            if (checkResponse.Success && checkResponse.Data != null)
            {
                // Implementation would need to get check items and cancel them one by one
                // This is a simplified version
                _logger.LogInformation("Order {OrderId} cancellation requested in Simpra", grandNodeOrderId);
                return true;
            }

            return false;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error cancelling order {OrderId} in Simpra", grandNodeOrderId);
            return false;
        }
    }

    public async Task SyncOrderStatusAsync()
    {
        try
        {
            _logger.LogInformation("Starting order status synchronization from Simpra");

            var settings = _settingService.LoadSetting<SimpraSettings>();
            if (!settings.EnableOrderStatusSync)
            {
                _logger.LogDebug("Order status sync is disabled");
                return;
            }

            // Get checks updated in the last sync interval (default to 12 hours like Adisyo)
            var syncInterval =
                settings.OrderStatusSyncInterval > 0 ? settings.OrderStatusSyncInterval : 720; // 12 hours
            var lastSyncTime = DateTime.UtcNow.AddMinutes(-syncInterval);

            // Convert DateTime to Unix timestamp
            var unixTimestamp = ((DateTimeOffset)lastSyncTime).ToUnixTimeSeconds();

            int currentPage = 1;
            bool hasMorePages = true;
            int totalProcessed = 0;

            while (hasMorePages)
            {
                var checksResponse = await _simpraApiService.GetChecksAsync(
                    page: currentPage,
                    perPage: 50,
                    updatedAt: unixTimestamp,
                    revenueCenterId: settings.RevenueCenterId);

                if (checksResponse.Success && checksResponse.Data != null)
                {
                    var checks = checksResponse.Data.Checks;

                    foreach (var check in checks)
                    {
                        await UpdateGrandNodeOrderStatusFromSimpraAsync(check);
                    }

                    totalProcessed += checks.Count;

                    // Check if there are more pages
                    hasMorePages = checksResponse.Data.Meta.HasNextPage;
                    currentPage++;

                    _logger.LogDebug("Processed page {Page} with {Count} checks. Total processed: {Total}",
                        currentPage - 1, checks.Count, totalProcessed);
                }
                else
                {
                    _logger.LogWarning("Failed to get checks from Simpra for page {Page}", currentPage);
                    break;
                }
            }

            _logger.LogInformation("Completed order status synchronization. Total processed: {Count} checks",
                totalProcessed);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during order status synchronization from Simpra");
        }
    }

    public async Task<bool> CanSendOrderToSimpraAsync(Order order)
    {
        var settings = _settingService.LoadSetting<SimpraSettings>();

        if (string.IsNullOrEmpty(settings.AccessToken) ||
            string.IsNullOrEmpty(settings.RevenueCenterId) ||
            string.IsNullOrEmpty(settings.SalesChannelId) ||
            string.IsNullOrEmpty(settings.EmployeeId))
        {
            return false;
        }

        // Only send orders in Preparing status
        if (order.OrderStatusId != (int)OrderStatusSystem.Processing && !(IsCashOnDeliveryPayment(order.PaymentMethodSystemName) && order.OrderStatusId == (int)OrderStatusSystem.Pending))
        {
            _logger.LogWarning("Order {OrderId} is not in Preparing status, cannot send to Simpra", order.Id);
            return false;
        }

        return true;
    }

    public string? GetSimpraCheckId(Order order)
    {
        return order.UserFields
            .FirstOrDefault(x => x.Key == "SimpraCheckId")?.Value;
    }

    public async Task StoreSimpraCheckIdAsync(Order order, string simpraCheckId)
    {
        order.UserFields.Add(new Grand.Domain.Common.UserField() {
            Key = "SimpraCheckId",
            Value = simpraCheckId,
            StoreId = order.StoreId
        });

        await _orderService.UpdateOrder(order);
    }

    public async Task ProcessOrderStatusUpdateAsync(SimpraOrderStatusUpdate statusUpdate)
    {
        try
        {
            var order = await _orderService.GetOrderById(statusUpdate.OrderId);
            if (order == null)
            {
                _logger.LogWarning("Order {OrderId} not found for status update", statusUpdate.OrderId);
                return;
            }

            _logger.LogDebug(
                "Processing order status update from Redis: Order {OrderId}, NewStatus: {Status}, Source: {Source}",
                statusUpdate.OrderId, statusUpdate.NewStatus, statusUpdate.Source);

            // Create a mock SimpraCheckResponse to reuse existing status handlers
            var mockCheck = new SimpraCheckResponse {
                Id = GetSimpraCheckId(order) ?? "",
                DeliveryStatus = statusUpdate.DeliveryStatus,
                Status = statusUpdate.NewStatus,
                Sequence = order.OrderNumber,
                Summary = new SimpraCheckSummary {
                    TotalAmount = order.OrderTotal.ToString("F2")
                },
                CreatedAt = ((DateTimeOffset)order.CreatedOnUtc).ToUnixTimeSeconds()
            };

            // Handle different delivery statuses using existing handlers
            switch (statusUpdate.DeliveryStatus?.ToLowerInvariant())
            {
                case "preparing":
                    await HandlePreparingStatusAsync(order, mockCheck);
                    break;

                case "on_delivery":
                    await HandleOnDeliveryStatusAsync(order, mockCheck);
                    break;

                case "delivered":
                    await HandleDeliveredStatusAsync(order, mockCheck);
                    break;

                case "cancelled":
                    await HandleCancelledStatusAsync(order, mockCheck);
                    break;

                default:
                    // Handle general status changes
                    await HandleGeneralStatusAsync(order, mockCheck);
                    break;
            }

            _logger.LogInformation("Successfully processed order status update from Redis for order {OrderId}",
                statusUpdate.OrderId);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing order status update for order {OrderId}", statusUpdate.OrderId);
        }
    }

    public async Task PublishOrderStatusUpdateAsync(string storeId, string orderId, string newStatus,
        string deliveryStatus)
    {
        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            var message = new SimpraOrderStatusUpdate {
                Tenant = new TenantInfo { StoreId = storeId },
                OrderId = orderId,
                NewStatus = newStatus,
                DeliveryStatus = deliveryStatus,
                Timestamp = DateTime.UtcNow,
                Source = "simpra"
            };

            var subscriber = _redis.GetSubscriber();
            var channel = $"{settings.RedisChannelPrefix}:order:status:updates";

            await subscriber.PublishAsync(channel, JsonSerializer.Serialize(message));

            _logger.LogDebug("Published order status update to Redis: {OrderId} -> {Status}", orderId, newStatus);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error publishing order status update to Redis");
        }
    }

    private async Task<List<SimpraMenuItem>> ConvertOrderItemsToMenuItemsAsync(Order order)
    {
        var menuItems = new List<SimpraMenuItem>();

        foreach (var orderItem in order.OrderItems)
        {
            // Get product to find Simpra menu item mapping
            var product = await _productService.GetProductById(orderItem.ProductId);
            if (product == null) continue;

            // Get Simpra menu item ID from product mapping
            var simpraMenuItemId = await GetSimpraMenuItemIdAsync(product);
            
            var simpraUnitAmount = (decimal)orderItem.UnitPriceInclTax; // Convert double to decimal for Simpra
            var productAttributeValues = product.ParseProductAttributeValues(orderItem.Attributes);
            if (productAttributeValues != null && productAttributeValues.Any())
            {
                foreach (var productAttributeValue in productAttributeValues)
                {
                    if (productAttributeValue.PriceAdjustment > 0)
                    {
                        var condimentMapping =
                            await _condimentMappingService
                                .GetByGrandNodeAttributeValueIdAsync(productAttributeValue.Id);
                        if ((condimentMapping != null && condimentMapping.IsActive) && !string.IsNullOrEmpty(simpraMenuItemId))
                        {
                            simpraUnitAmount -= (decimal)productAttributeValue.PriceAdjustment;
                        }
                    }
                }
            }
            
            if (string.IsNullOrEmpty(simpraMenuItemId))
            {
                _logger.LogWarning("No Simpra menu item mapping found for product {ProductId}", orderItem.ProductId);
                var customMenuItem = new SimpraMenuItem {
                    Name = product.GetTranslation(x=>x.Name,order.CustomerLanguageId),
                    Quantity = orderItem.Quantity,
                    UnitAmount = simpraUnitAmount, // Convert double to decimal for Simpra
                    Notes = new List<string>() {
                        "Eşitlenmeyen Ürün.",
                        await _productAttributeFormatter.FormatAttributes(product, orderItem.Attributes, (await _customerService.GetCustomerById(order.CustomerId)),"\n",false,true,true,true,false,false)
                    }
                };

                menuItems.Add(customMenuItem);
                continue; // Skip items that don't have Simpra mapping
            }

            

            var menuItem = new SimpraMenuItem {
                Id = simpraMenuItemId,
                Quantity = orderItem.Quantity,
                UnitAmount = simpraUnitAmount, // Convert double to decimal for Simpra
                // Notes = !string.IsNullOrEmpty(orderItem.AttributeDescription) ? 
                //     new List<string> { orderItem.AttributeDescription } : null,
                Condiments = await ConvertProductAttributesToOrderCondimentsAsync(orderItem)
            };

            menuItems.Add(menuItem);
        }

        return menuItems;
    }

    private async Task<string> ConvertAddressToStringAsync(Grand.Domain.Common.Address? address)
    {
        if (address == null) return "";

        try
        {
            var addressParts = new List<string>();

            if (!string.IsNullOrWhiteSpace(address.Address1))
                addressParts.Add(address.Address1);

            if (!string.IsNullOrWhiteSpace(address.Address2))
                addressParts.Add(address.Address2);

            if (!string.IsNullOrWhiteSpace(address.City))
                addressParts.Add(address.City);

            var district = await GetDistrictNameAsync(address.StateProvinceId);
            if (!string.IsNullOrWhiteSpace(district))
                addressParts.Add(district);

            var country = await GetCountryNameAsync(address.CountryId);
            if (!string.IsNullOrWhiteSpace(country))
                addressParts.Add(country);

            if (!string.IsNullOrWhiteSpace(address.ZipPostalCode))
                addressParts.Add(address.ZipPostalCode);

            var fullAddress = string.Join(", ", addressParts);

            _logger.LogDebug("Converted address for order: {FullAddress}", fullAddress);

            return fullAddress;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error converting address to string format");

            // Return basic address if conversion fails
            return $"{address.Address1} {address.Address2}, {address.City}".Trim();
        }
    }

    private string BuildAddressLine(Grand.Domain.Common.Address address)
    {
        var addressParts = new List<string>();

        if (!string.IsNullOrWhiteSpace(address.Address1))
            addressParts.Add(address.Address1);

        if (!string.IsNullOrWhiteSpace(address.Address2))
            addressParts.Add(address.Address2);

        // Add building/apartment info if available
        var buildingInfo = address.Attributes?
            .FirstOrDefault(attr => attr.Key.Contains("building", StringComparison.OrdinalIgnoreCase) ||
                                    attr.Key.Contains("apartment", StringComparison.OrdinalIgnoreCase))?.Value;
        if (!string.IsNullOrWhiteSpace(buildingInfo))
            addressParts.Add(buildingInfo);

        return string.Join(" ", addressParts).Trim();
    }

    private async Task<string> GetDistrictNameAsync(string? stateProvinceId)
    {
        try
        {
            if (string.IsNullOrEmpty(stateProvinceId))
                return "";

            var countries = await _countryService.GetAllCountries();
            var districtName = countries.SelectMany(x => x.StateProvinces).FirstOrDefault(x => x.Id == stateProvinceId)
                ?.Name ?? "";
            return districtName;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting district name for state province {StateProvinceId}", stateProvinceId);
            return stateProvinceId ?? "";
        }
    }

    private async Task<string> GetCountryNameAsync(string? countryId)
    {
        try
        {
            if (string.IsNullOrEmpty(countryId))
                return "";

            var country = await _countryService.GetCountryById(countryId);
            return country?.Name ?? "";
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting district name for state province {StateProvinceId}", countryId);
            return countryId ?? "";
        }
    }

    private async Task CreatePaymentRecordAsync(string checkId, Order order)
    {
        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            var paymentMappings = GetPaymentMethodMappings(settings);

            if (paymentMappings.TryGetValue(order.PaymentMethodSystemName, out var simpraPaymentTypeId))
            {
                var paymentRequest = new SimpraCheckPaymentRequest {
                    PaymentTypeId = simpraPaymentTypeId.ToString(),
                    Amount = Convert.ToDecimal(order.OrderTotal, CultureInfo.CurrentCulture),
                };

                await _simpraApiService.CreateCheckPaymentAsync(checkId, paymentRequest);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating payment record for check {CheckId}", checkId);
        }
    }

    private Dictionary<string, string> GetPaymentMethodMappings(SimpraSettings settings)
    {
        if (string.IsNullOrEmpty(settings.PaymentMethodMappings))
            return new Dictionary<string, string>();

        try
        {
            return JsonSerializer.Deserialize<Dictionary<string, string>>(settings.PaymentMethodMappings)
                   ?? new Dictionary<string, string>();
        }
        catch
        {
            return new Dictionary<string, string>();
        }
    }

    private OrderStatusSystem? MapSimpraStatusToGrandNodeStatus(string simpraStatus)
    {
        return simpraStatus?.ToLower() switch {
            "preparing" => OrderStatusSystem.Processing,
            "on_delivery" => OrderStatusSystem.Processing,
            "delivered" => OrderStatusSystem.Complete,
            "cancelled" => OrderStatusSystem.Cancelled,
            _ => null
        };
    }

    private async Task ProcessSimpraCheckStatusAsync(SimpraCheckResponse check)
    {
        if (string.IsNullOrEmpty(check.DeliveryStatus)) return;

        var order = await _orderRepository.Table
            .Where(o => o.UserFields.Any(ga => ga.Key == "SimpraCheckId" && ga.Value == check.Id))
            .FirstOrDefaultAsync();

        if (order != null)
        {
            await PublishOrderStatusUpdateAsync(order.StoreId, order.Id, check.Status, check.DeliveryStatus);
        }
    }

    private async Task<string?> GetSimpraMenuItemIdAsync(Grand.Domain.Catalog.Product product)
    {
        try
        {
            // First check if we have a mapping in the database
            var mapping = await _menuItemMappingService.GetByGrandNodeProductIdAsync(product.Id);
            if (mapping != null && !string.IsNullOrEmpty(mapping.SimpraMenuItemId))
            {
                return mapping.SimpraMenuItemId;
            }

            // Fallback to UserFields for backward compatibility
            var menuItemIdString = product.UserFields
                .FirstOrDefault(x => x.Key == "SimpraMenuItemId")?.Value;

            if (!string.IsNullOrEmpty(menuItemIdString))
            {
                // Create mapping entry for future use
                var newMapping = new Domain.SimpraMenuItemMapping {
                    GrandNodeProductId = product.Id,
                    SimpraMenuItemId = menuItemIdString,
                    MenuItemName = product.Name,
                    ProductSku = product.Sku,
                    SimpraPrice = (decimal)product.Price,
                    IsActive = true,
                    SyncStatus = "Synced",
                    LastSyncDate = DateTime.UtcNow
                };

                await _menuItemMappingService.InsertAsync(newMapping);
                return menuItemIdString;
            }

            _logger.LogWarning("No Simpra menu item mapping found for product {ProductId} ({ProductName})",
                product.Id, product.Name);
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting Simpra menu item ID for product {ProductId}", product.Id);
            return null;
        }
    }

    private async Task<List<SimpraOrderCondiment>?> ConvertProductAttributesToOrderCondimentsAsync(OrderItem orderItem)
    {
        var condiments = new List<SimpraOrderCondiment>();

        try
        {
            if (orderItem.Attributes != null && orderItem.Attributes.Any())
            {
                var product = await _productService.GetProductById(orderItem.ProductId);
                if (product != null)
                {
                    // Parse the attributes collection into attribute values
                    // Following the Adisyo pattern for attribute parsing
                    var productAttributeValues = product.ParseProductAttributeValues(orderItem.Attributes);

                    foreach (var attributeValue in productAttributeValues)
                    {
                        try
                        {
                            // Look for existing condiment mapping
                            var condimentMapping =
                                await _condimentMappingService.GetByGrandNodeAttributeValueIdAsync(attributeValue.Id);

                            if (condimentMapping != null && condimentMapping.IsActive)
                            {
                                // Use mapped condiment
                                var condiment = new SimpraOrderCondiment {
                                    Id = condimentMapping.SimpraCondimentId
                                };

                                condiments.Add(condiment);

                                _logger.LogDebug(
                                    "Mapped attribute value {AttributeValueId} to Simpra condiment {CondimentId}",
                                    attributeValue.Id, condimentMapping.SimpraCondimentId);
                            }
                            else
                            {
                                // Create a temporary mapping using a hash-based approach
                                // This should be replaced with proper admin mapping interface
                                var tempCondimentId =
                                    Math.Abs(attributeValue.Id.GetHashCode()).ToString(); // Convert to string

                                var condiment = new SimpraOrderCondiment {
                                    Id = tempCondimentId
                                };

                                condiments.Add(condiment);

                                _logger.LogWarning(
                                    "No condiment mapping found for attribute value {AttributeValueId} ({AttributeValueName}), using temporary ID {TempId}",
                                    attributeValue.Id, attributeValue.Name, tempCondimentId);

                                // TODO: Consider creating a pending mapping record for admin review
                            }
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(ex,
                                "Error processing attribute value {AttributeValueId} for condiment mapping",
                                attributeValue.Id);
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error converting product attributes to condiments for order item {OrderItemId}",
                orderItem.Id);
        }

        return condiments.Count > 0 ? condiments : null;
    }

    private async Task<List<SimpraCondimentSelection>> ConvertProductAttributesToCondimentsAsync(OrderItem orderItem)
    {
        var condimentSelections = new List<SimpraCondimentSelection>();

        try
        {
            if (orderItem.Attributes != null && orderItem.Attributes.Any())
            {
                var product = await _productService.GetProductById(orderItem.ProductId);
                if (product != null)
                {
                    // Parse the attributes collection into attribute values
                    // Following the Adisyo pattern for attribute parsing
                    var productAttributeValues = product.ParseProductAttributeValues(orderItem.Attributes);

                    foreach (var attributeValue in productAttributeValues)
                    {
                        try
                        {
                            // Look for existing condiment mapping
                            var condimentMapping =
                                await _condimentMappingService.GetByGrandNodeAttributeValueIdAsync(attributeValue.Id);

                            if (condimentMapping != null && condimentMapping.IsActive)
                            {
                                // Use mapped condiment
                                var condimentSelection = new SimpraCondimentSelection {
                                    CondimentId = condimentMapping.SimpraCondimentId,
                                    Quantity = 1,
                                    Notes =
                                        $"{condimentMapping.CondimentName} (Price: {condimentMapping.AdditionalPrice:C})"
                                };

                                condimentSelections.Add(condimentSelection);

                                _logger.LogDebug(
                                    "Mapped attribute value {AttributeValueId} to Simpra condiment {CondimentId}",
                                    attributeValue.Id, condimentMapping.SimpraCondimentId);
                            }
                            else
                            {
                                // Create a temporary mapping using a hash-based approach
                                // This should be replaced with proper admin mapping interface
                                var tempCondimentId =
                                    Math.Abs(attributeValue.Id.GetHashCode()).ToString(); // Convert to string

                                var condimentSelection = new SimpraCondimentSelection {
                                    CondimentId = tempCondimentId,
                                    Quantity = 1,
                                    Notes = $"{attributeValue.Name} (Unmapped - ID: {tempCondimentId})"
                                };

                                condimentSelections.Add(condimentSelection);

                                _logger.LogWarning(
                                    "No condiment mapping found for attribute value {AttributeValueId} ({AttributeValueName}), using temporary ID {TempId}",
                                    attributeValue.Id, attributeValue.Name, tempCondimentId);

                                // TODO: Consider creating a pending mapping record for admin review
                            }
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(ex,
                                "Error processing attribute value {AttributeValueId} for condiment mapping",
                                attributeValue.Id);
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error converting product attributes to condiments for order item {OrderItemId}",
                orderItem.Id);
        }

        return condimentSelections;
    }

    private async Task UpdateGrandNodeOrderStatusFromSimpraAsync(SimpraCheckResponse simpraCheck)
    {
        try
        {
            // Find GrandNode order by Simpra check ID
            var order = await _orderRepository.Table
                .Where(o => o.UserFields.Any(uf => uf.Key == "SimpraCheckId" && uf.Value == simpraCheck.Id))
                .FirstOrDefaultAsync();

            if (order == null)
            {
                _logger.LogWarning("GrandNode order not found for Simpra check ID {CheckId}", simpraCheck.Id);
                return;
            }

            _logger.LogDebug(
                "Processing status update for order {OrderId} from Simpra check {CheckId}. Status: {Status}, DeliveryStatus: {DeliveryStatus}",
                order.Id, simpraCheck.Id, simpraCheck.Status, simpraCheck.DeliveryStatus);

            // Handle different Simpra delivery statuses
            // switch (simpraCheck.DeliveryStatus?.ToLowerInvariant())
            // {
            //     case "preparing":
            //         await HandlePreparingStatusAsync(order, simpraCheck);
            //         break;
            //         
            //     case "on_delivery":
            //         await HandleOnDeliveryStatusAsync(order, simpraCheck);
            //         break;
            //         
            //     case "delivered":
            //         await HandleDeliveredStatusAsync(order, simpraCheck);
            //         break;
            //         
            //     case "cancelled":
            //         await HandleCancelledStatusAsync(order, simpraCheck);
            //         break;
            //         
            //     default:
            //         // Handle check status if delivery status is not available
            //         await HandleGeneralStatusAsync(order, simpraCheck);
            //         break;
            // }

            // Publish Redis notification for status change
            await PublishOrderStatusUpdateAsync(order.StoreId, order.Id, simpraCheck.Status,
                simpraCheck.DeliveryStatus ?? "");

            _logger.LogInformation(
                "Successfully processed status update for order {OrderId} from Simpra check {CheckId}",
                order.Id, simpraCheck.Id);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating GrandNode order status for Simpra check {CheckId}", simpraCheck.Id);
        }
    }

    private async Task HandlePreparingStatusAsync(Order order, SimpraCheckResponse simpraCheck)
    {
        try
        {
            _logger.LogInformation("Processing preparing status for order {OrderId} from Simpra", order.Id);

            // Ensure payment is recorded if order is paid and this is a cash-on-delivery order
            if (IsCashOnDeliveryPayment(order.PaymentMethodSystemName))
            {
                // For COD orders, don't mark as paid until delivery
                _logger.LogDebug("Order {OrderId} is cash on delivery, payment will be processed on delivery",
                    order.Id);
            }
            else
            {
                // For online payments, ensure payment is marked as paid if Simpra shows it as paid
                await EnsurePaymentStatusAsync(order, simpraCheck);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error handling preparing status for order {OrderId}", order.Id);
        }
    }

    private async Task HandleOnDeliveryStatusAsync(Order order, SimpraCheckResponse simpraCheck)
    {
        try
        {
            _logger.LogInformation("Processing on_delivery status for order {OrderId} from Simpra", order.Id);

            // Create shipment if not exists and mark as shipped
            await CreateOrUpdateShipmentAsync(order, shipped: true, delivered: false);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error handling on_delivery status for order {OrderId}", order.Id);
        }
    }

    private async Task HandleDeliveredStatusAsync(Order order, SimpraCheckResponse simpraCheck)
    {
        try
        {
            _logger.LogInformation("Processing delivered status for order {OrderId} from Simpra", order.Id);

            // For cash on delivery orders, mark payment as paid when delivered
            if (IsCashOnDeliveryPayment(order.PaymentMethodSystemName))
            {
                await MarkCashOnDeliveryAsPaidAsync(order);
            }

            // Ensure shipment exists and mark as delivered
            await CreateOrUpdateShipmentAsync(order, shipped: true, delivered: true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error handling delivered status for order {OrderId}", order.Id);
        }
    }

    private async Task HandleCancelledStatusAsync(Order order, SimpraCheckResponse simpraCheck)
    {
        try
        {
            _logger.LogInformation("Processing cancelled status for order {OrderId} from Simpra", order.Id);

            var isCashOnDelivery = IsCashOnDeliveryPayment(order.PaymentMethodSystemName);
            var paymentTransactions = await _paymentTransactionService.GetByOrderCode(order.Code);
            var hasPayments = paymentTransactions?.Any() == true;
            var isOrderDelivered = order.ShippingStatusId == ShippingStatus.Delivered;
            var isOrderShipped = order.ShippingStatusId == ShippingStatus.Shipped;

            if (isOrderShipped)
            {
                var existingShipments = await _shipmentService.GetShipmentsByOrder(order.Id);
                foreach (var shipment in existingShipments)
                {
                    if (shipment.DeliveryDateUtc.HasValue)
                        continue;
                    var orderId = shipment.OrderId;

                    //delete shipment
                    await _shipmentService.DeleteShipment(shipment);

                    //add a note
                    await _orderService.InsertOrderNote(new OrderNote {
                        Note = $"A shipment #{shipment.ShipmentNumber} has been deleted",
                        DisplayToCustomer = false,
                        OrderId = order.Id
                    });
                }
            }

            if (isCashOnDelivery)
            {
                // For cash on delivery, just cancel the order
                await CancelOrderInGrandNodeAsync(order.Id);
            }
            else if (hasPayments)
            {
                // Online payment - refund if paid
                if (!isOrderDelivered)
                {
                    // Order not delivered yet - refund and cancel
                    await RefundOrderPaymentAsync(order);
                    await CancelOrderInGrandNodeAsync(order.Id);
                }
                else
                {
                    // Order was delivered and then cancelled/refunded
                    await RefundOrderPaymentAsync(order);
                    await CancelOrderInGrandNodeAsync(order.Id);
                }
            }
            else
            {
                // No payments - just cancel
                await CancelOrderInGrandNodeAsync(order.Id);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error handling cancelled status for order {OrderId}", order.Id);
        }
    }

    private async Task HandleGeneralStatusAsync(Order order, SimpraCheckResponse simpraCheck)
    {
        try
        {
            // Map general check status to GrandNode status
            var newOrderStatus = MapSimpraStatusToGrandNodeStatus(simpraCheck.Status);
            if (newOrderStatus.HasValue && order.OrderStatusId != (int)newOrderStatus.Value)
            {
                // order.OrderStatusId = (int)newOrderStatus.Value;


                await _mediator.Send(new SetOrderStatusCommand() {
                    Order = order,
                    Os = newOrderStatus.Value,
                    NotifyCustomer = true,
                    NotifyStoreOwner = true
                });
                await _orderService.UpdateOrder(order);

                _logger.LogInformation(
                    "Updated order {OrderId} status to {Status} based on Simpra check status {SimpraStatus}",
                    order.Id, newOrderStatus.Value, simpraCheck.Status);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error handling general status for order {OrderId}", order.Id);
        }
    }

    private async Task EnsurePaymentStatusAsync(Order order, SimpraCheckResponse simpraCheck)
    {
        try
        {
            // Check if order payment status needs to be updated based on Simpra check
            if (order.PaymentStatusId != PaymentStatus.Paid)
            {
                var paymentTransactions = await _paymentTransactionService.GetByOrderCode(order.Code);
                var paymentTransaction = paymentTransactions?.FirstOrDefault();
                if (paymentTransaction != null && paymentTransaction.TransactionStatus != TransactionStatus.Paid)
                {
                    await _mediator.Send(new MarkAsPaidCommand {
                        PaymentTransaction = paymentTransaction
                    });
                    _logger.LogInformation("Marked online payment as paid for order {OrderId}", order.Id);
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error ensuring payment status for order {OrderId}", order.Id);
        }
    }

    private async Task MarkCashOnDeliveryAsPaidAsync(Order order)
    {
        try
        {
            if (order.PaymentStatusId != PaymentStatus.Paid)
            {
                var paymentTransactions = await _paymentTransactionService.GetByOrderCode(order.Code);
                var paymentTransaction = paymentTransactions?.FirstOrDefault();
                if (paymentTransaction != null)
                {
                    await _mediator.Send(new MarkAsPaidCommand {
                        PaymentTransaction = paymentTransaction
                    });
                    _logger.LogInformation("Marked cash on delivery payment as paid for order {OrderId}", order.Id);
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error marking cash on delivery as paid for order {OrderId}", order.Id);
        }
    }

    private async Task CreateOrUpdateShipmentAsync(Order order, bool shipped, bool delivered)
    {
        try
        {
            if (order.ShippingStatusId == ShippingStatus.ShippingNotRequired)
            {
                _logger.LogDebug("Order {OrderId} does not require shipping", order.Id);
                return;
            }

            var existingShipments = await _shipmentService.GetShipmentsByOrder(order.Id);

            if (existingShipments.Any())
            {
                // Update existing shipment
                var shipment = existingShipments.First();

                if (shipped && !shipment.ShippedDateUtc.HasValue)
                {
                    await _mediator.Send(new ShipCommand { Shipment = shipment, NotifyCustomer = true });
                    _logger.LogInformation("Marked existing shipment {ShipmentId} as shipped for order {OrderId}",
                        shipment.Id, order.Id);
                }

                if (delivered && !shipment.DeliveryDateUtc.HasValue)
                {
                    await _mediator.Send(new DeliveryCommand { Shipment = shipment, NotifyCustomer = true });
                    _logger.LogInformation("Marked existing shipment {ShipmentId} as delivered for order {OrderId}",
                        shipment.Id, order.Id);
                }
            }
            else
            {
                // Create new shipment
                var shipment = new Shipment {
                    OrderId = order.Id,
                    StoreId = order.StoreId,
                    TrackingNumber = string.Empty,
                    TotalWeight = 0,
                    CreatedOnUtc = DateTime.UtcNow
                };

                // Add all order items to shipment
                foreach (var orderItem in order.OrderItems)
                {
                    var product = await _productService.GetProductById(orderItem.ProductId);
                    if (product?.IsShipEnabled == true)
                    {
                        var shipmentItem = new ShipmentItem {
                            OrderItemId = orderItem.Id,
                            Quantity = orderItem.Quantity,
                            WarehouseId = product.WarehouseId
                        };
                        shipment.ShipmentItems.Add(shipmentItem);
                    }
                }

                if (shipment.ShipmentItems.Any())
                {
                    await _shipmentService.InsertShipment(shipment);

                    if (shipped)
                    {
                        await _mediator.Send(new ShipCommand { Shipment = shipment, NotifyCustomer = true });
                        _logger.LogInformation("Created and shipped new shipment {ShipmentId} for order {OrderId}",
                            shipment.Id, order.Id);
                    }

                    if (delivered)
                    {
                        await _mediator.Send(new DeliveryCommand { Shipment = shipment, NotifyCustomer = true });
                        _logger.LogInformation("Marked new shipment {ShipmentId} as delivered for order {OrderId}",
                            shipment.Id, order.Id);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating or updating shipment for order {OrderId}", order.Id);
        }
    }

    private async Task CancelOrderInGrandNodeAsync(string orderId)
    {
        try
        {
            var order = await _orderService.GetOrderById(orderId);
            if (order == null)
            {
                _logger.LogWarning("Order {OrderId} not found for cancellation", orderId);
                return;
            }

            if (order.OrderStatusId == (int)OrderStatusSystem.Cancelled)
            {
                _logger.LogDebug("Order {OrderId} is already cancelled", orderId);
                return;
            }

            await _mediator.Send(new CancelOrderCommand {
                Order = order,
                NotifyCustomer = true
            });

            _logger.LogInformation("Successfully cancelled order {OrderId} in GrandNode", orderId);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error cancelling order {OrderId} in GrandNode", orderId);
        }
    }

    private async Task RefundOrderPaymentAsync(Order order)
    {
        try
        {
            var paymentTransactions = await _paymentTransactionService.GetByOrderCode(order.Code);
            var paymentTransaction = paymentTransactions?
                .FirstOrDefault(pt => pt.TransactionStatus == TransactionStatus.Paid);

            if (paymentTransaction == null)
            {
                _logger.LogWarning("No paid payment transaction found for order {OrderId}", order.Id);
                return;
            }

            if (paymentTransaction.TransactionStatus == TransactionStatus.Refunded ||
                paymentTransaction.TransactionStatus == TransactionStatus.PartiallyRefunded)
            {
                _logger.LogDebug("Payment transaction for order {OrderId} is already refunded", order.Id);
                return;
            }

            // Attempt full refund
            await _mediator.Send(new RefundCommand {
                PaymentTransaction = paymentTransaction
            });

            _logger.LogInformation("Successfully refunded payment for order {OrderId}", order.Id);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error refunding payment for order {OrderId}", order.Id);
        }
    }

    private static bool IsCashOnDeliveryPayment(string paymentMethodSystemName)
    {
        return paymentMethodSystemName?.Contains("CashOnDelivery", StringComparison.OrdinalIgnoreCase) == true ||
               paymentMethodSystemName?.Contains("COD", StringComparison.OrdinalIgnoreCase) == true;
    }

    /// <summary>
    /// Creates service charges for order fees (shipping, payment fees, checkout attributes)
    /// </summary>
    private async Task CreateServiceChargesForOrderAsync(string checkId, Order order)
    {
        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            var serviceChargeMappings = GetServiceChargeMappings(settings);

            // 1. Create service charge for shipping fee if exists
            if (order.OrderShippingInclTax > 0)
            {
                await CreateShippingServiceChargeAsync(checkId, order, serviceChargeMappings);
            }

            // 2. Create service charge for payment method additional fee if exists
            if (order.PaymentMethodAdditionalFeeInclTax > 0)
            {
                await CreatePaymentFeeServiceChargeAsync(checkId, order, serviceChargeMappings);
            }

            // 3. Create service charges for checkout attributes if exists
            if (order.CheckoutAttributes != null && order.CheckoutAttributes.Any())
            {
                await CreateCheckoutAttributeServiceChargesAsync(checkId, order, serviceChargeMappings);
            }

            _logger.LogInformation("Service charges created for order {OrderId} with check {CheckId}", order.Id,
                checkId);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating service charges for order {OrderId} with check {CheckId}", order.Id,
                checkId);
        }
    }

    /// <summary>
    /// Creates service charge for shipping costs
    /// </summary>
    private async Task CreateShippingServiceChargeAsync(string checkId, Order order,
        Dictionary<string, string> serviceChargeMappings)
    {
        try
        {
            if (!serviceChargeMappings.TryGetValue("shipping", out var serviceChargeId))
            {
                _logger.LogWarning("No service charge mapping found for shipping fees for order {OrderId}", order.Id);
                return;
            }

            var request = new SimpraCheckServiceChargeRequest {
                ServiceChargeId = serviceChargeId,
                Amount = (decimal)order.OrderShippingInclTax
            };

            var response = await _simpraApiService.CreateCheckServiceChargeAsync(checkId, request);
            if (response.Success)
            {
                _logger.LogInformation(
                    "Created shipping service charge {ServiceChargeId} for order {OrderId}, amount: {Amount}",
                    serviceChargeId, order.Id, order.OrderShippingInclTax);
            }
            else
            {
                _logger.LogWarning("Failed to create shipping service charge for order {OrderId}: {Message}",
                    order.Id, response.Message);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating shipping service charge for order {OrderId}", order.Id);
        }
    }

    /// <summary>
    /// Creates service charge for payment method additional fees
    /// </summary>
    private async Task CreatePaymentFeeServiceChargeAsync(string checkId, Order order,
        Dictionary<string, string> serviceChargeMappings)
    {
        try
        {
            if (!serviceChargeMappings.TryGetValue("payment_fee", out var serviceChargeId))
            {
                _logger.LogWarning("No service charge mapping found for payment fees for order {OrderId}", order.Id);
                return;
            }

            var request = new SimpraCheckServiceChargeRequest {
                ServiceChargeId = serviceChargeId,
                Amount = (decimal)order.PaymentMethodAdditionalFeeInclTax
            };

            var response = await _simpraApiService.CreateCheckServiceChargeAsync(checkId, request);
            if (response.Success)
            {
                _logger.LogInformation(
                    "Created payment fee service charge {ServiceChargeId} for order {OrderId}, amount: {Amount}",
                    serviceChargeId, order.Id, order.PaymentMethodAdditionalFeeInclTax);
            }
            else
            {
                _logger.LogWarning("Failed to create payment fee service charge for order {OrderId}: {Message}",
                    order.Id, response.Message);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating payment fee service charge for order {OrderId}", order.Id);
        }
    }

    /// <summary>
    /// Creates service charges for checkout attributes that have price adjustments
    /// </summary>
    private async Task CreateCheckoutAttributeServiceChargesAsync(string checkId, Order order,
        Dictionary<string, string> serviceChargeMappings)
    {
        try
        {
            // Parse checkout attributes to find ones with price adjustments

            var checkoutAttributeParse =
                await _checkoutAttributeParser.ParseCheckoutAttributeValue(order.CheckoutAttributes);

            foreach (var attribute in checkoutAttributeParse)
            {
                try
                {
                    // Try to find a matching service charge mapping for this specific attribute key and value
                    var specificMappingKey = $"checkout_attribute_{attribute.ca.Id}_{attribute.cav?.Id}";
                    var generalMappingKey = $"checkout_attribute_{attribute.ca.Id}";

                    string? serviceChargeId = null;

                    // First try to find a specific mapping for key + value combination
                    if (serviceChargeMappings.TryGetValue(specificMappingKey, out serviceChargeId))
                    {
                        _logger.LogDebug(
                            "Found specific mapping for checkout attribute {AttributeKey}={AttributeValue}: {ServiceChargeId}",
                            attribute.ca.Id, attribute.cav?.Id, serviceChargeId);
                    }
                    // If not found, try to find a general mapping for just the key
                    else if (serviceChargeMappings.TryGetValue(generalMappingKey, out serviceChargeId))
                    {
                        _logger.LogDebug(
                            "Found general mapping for checkout attribute {AttributeKey}: {ServiceChargeId}",
                            attribute.ca.Id, serviceChargeId);
                    }

                    if (!string.IsNullOrEmpty(serviceChargeId))
                    {
                        // For checkout attributes, we typically want to add a fixed service charge
                        // regardless of the value, unless the value represents a price
                        var orderCustomer = await _customerService.GetCustomerById(order.CustomerId);
                        var amountWithTax =
                            await _taxService.GetCheckoutAttributePrice(attribute.ca, attribute.cav, orderCustomer);
                        var orderCurrency = await _currencyService.GetCurrencyByCode(order.CustomerCurrencyCode);
                        var orderPrimaryCurrency = await _currencyService.GetCurrencyByCode(order.PrimaryCurrencyCode);

                        var amount =
                            await _currencyService.ConvertCurrency(amountWithTax.checkoutPrice, orderPrimaryCurrency,
                                orderCurrency);


                        // Try to parse the value as a price first
                        if (amount > 0)
                        {
                            // Value is a price amount
                            _logger.LogDebug(
                                "Using checkout attribute value as amount: {Amount} for attribute {AttributeKey}",
                                amount, attribute.ca.Id);
                        }
                        else
                        {
                            // Value is not a price, use a default amount of 0
                            // This allows the service charge to be added without an additional amount
                            amount = 0;
                            _logger.LogDebug(
                                "Checkout attribute value is not a price, using default amount 0 for attribute {AttributeKey}={AttributeValue}",
                                attribute.ca.Id, attribute.cav.Id);
                        }

                        var request = new SimpraCheckServiceChargeRequest {
                            ServiceChargeId = serviceChargeId,
                            Amount = (decimal)amount
                        };

                        var response = await _simpraApiService.CreateCheckServiceChargeAsync(checkId, request);
                        if (response.Success)
                        {
                            _logger.LogInformation(
                                "Created checkout attribute service charge {ServiceChargeId} for order {OrderId}, attribute: {AttributeKey}={AttributeValue}, amount: {Amount}",
                                serviceChargeId, order.Id, attribute.ca.Id, attribute.cav.Id, amount);
                        }
                        else
                        {
                            _logger.LogWarning(
                                "Failed to create checkout attribute service charge for order {OrderId}, attribute {AttributeKey}={AttributeValue}: {Message}",
                                order.Id, attribute.ca.Id, attribute.cav.Id, response.Message);
                        }
                    }
                    else
                    {
                        _logger.LogDebug(
                            "No service charge mapping found for checkout attribute {AttributeKey}={AttributeValue} for order {OrderId}",
                            attribute.ca.Id, attribute.cav.Id, order.Id);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex,
                        "Error processing checkout attribute {AttributeKey}={AttributeValue} for order {OrderId}",
                        attribute.ca.Id, attribute.cav.Id, order.Id);
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating checkout attribute service charges for order {OrderId}", order.Id);
        }
    }

    /// <summary>
    /// Gets service charge mappings from settings
    /// </summary>
    private Dictionary<string, string> GetServiceChargeMappings(SimpraSettings settings)
    {
        if (string.IsNullOrEmpty(settings.ServiceChargeMappings))
            return new Dictionary<string, string>();

        try
        {
            return JsonSerializer.Deserialize<Dictionary<string, string>>(settings.ServiceChargeMappings)
                   ?? new Dictionary<string, string>();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deserializing service charge mappings from settings");
            return new Dictionary<string, string>();
        }
    }
}