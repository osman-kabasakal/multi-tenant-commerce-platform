using Famizyo.Integration.Adisyo.Domain;
using Famizyo.Integration.Adisyo.Models;
using Famizyo.Integration.Adisyo.Settings;
using Grand.Business.Core.Commands.Checkout.Orders;
using Grand.Business.Core.Commands.Checkout.Shipping;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Checkout.Payments;
using Grand.Business.Core.Interfaces.Checkout.Shipping;
using Grand.Business.Core.Interfaces.Common.Addresses;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Data;
using Grand.Domain.Catalog;
using Grand.Domain.Common;
using Grand.Domain.Orders;
using Grand.Domain.Payments;
using Grand.Domain.Shipping;
using MediatR;
using Microsoft.Extensions.Logging;
using MongoDB.Driver.Linq;
using System.Text.Json;

namespace Famizyo.Integration.Adisyo.Services;

public class AdisyoOrderService : IAdisyoOrderService
{
    private readonly IAdisyoApiService _adisyoApiService;
    private readonly IAdisyoOrderMappingService _orderMappingService;
    private readonly IOrderService _orderService;
    private readonly IProductService _productService;
    private readonly ICustomerService _customerService;
    private readonly ISettingService _settingService;
    private readonly ICountryService _countryService;
    private readonly IPaymentService _paymentService;
    private readonly IPaymentTransactionService _paymentTransactionService;
    private readonly IRepository<AdisyoFeatureValueMapping> _featureValueMappingRepository;
    private readonly IAddressAttributeService _addressAttributeService;
    private readonly IShipmentService _shipmentService;
    private readonly IMediator _mediator;
    private readonly ILogger<AdisyoOrderService> _logger;

    public AdisyoOrderService(
        IAdisyoApiService adisyoApiService,
        IAdisyoOrderMappingService orderMappingService,
        IOrderService orderService,
        IProductService productService,
        ICustomerService customerService,
        ISettingService settingService,
        ICountryService countryService,
        IPaymentService paymentService,
        IPaymentTransactionService paymentTransactionService,
        IRepository<AdisyoFeatureValueMapping> featureValueMappingRepository,
        IAddressAttributeService  addressAttributeService,
        IShipmentService shipmentService,
        IMediator mediator,
        ILogger<AdisyoOrderService> logger)
    {
        _adisyoApiService = adisyoApiService;
        _orderMappingService = orderMappingService;
        _orderService = orderService;
        _productService = productService;
        _customerService = customerService;
        _settingService = settingService;
        _countryService = countryService;
        _paymentService = paymentService;
        _paymentTransactionService = paymentTransactionService;
        _featureValueMappingRepository = featureValueMappingRepository;
        _addressAttributeService = addressAttributeService;
        _shipmentService = shipmentService;
        _mediator = mediator;
        _logger = logger;
        
    }

    private string? _aciklamaAttributeId;
    private async Task<string?> AciklamaAttributeId()
    {
        if (_aciklamaAttributeId != null || !string.IsNullOrEmpty(_aciklamaAttributeId))
        {
            return _aciklamaAttributeId;
        }
        
        var adressAttributes = await _addressAttributeService.GetAllAddressAttributes();
        return adressAttributes.FirstOrDefault(x => x.Name == "adres_tarifi")?.Id;
    } 

    public async Task<AdisyoOrderResponse> SendOrderToAdisyoAsync(Order order)
    {
        try
        {
            _logger.LogInformation("Converting GrandNode order {OrderId} to Adisyo format", order.Id);

            if (!await CanSendOrderToAdisyoAsync(order))
            {
                throw new InvalidOperationException($"Order {order.Id} cannot be sent to Adisyo");
            }

            var customer = await _customerService.GetCustomerById(order.CustomerId);
            if (customer == null)
            {
                throw new InvalidOperationException($"Customer not found for order {order.Id}");
            }

            var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
            var orderRequest = await ConvertToAdisyoOrderAsync(order, customer, settings);

            var response = await _adisyoApiService.SaveOrderAsync(orderRequest);

            // Store Adisyo order ID mapping
            await StoreAdisyoOrderIdAsync(order, response?.OrderId??0);

            _logger.LogInformation("Successfully sent order {OrderId} to Adisyo. AdisyoOrderId: {AdisyoOrderId}",
                order.Id, response.OrderId);

            return response;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to send order {OrderId} to Adisyo", order.Id);
            
            var existingMapping = await _orderMappingService.GetByGrandNodeOrderIdAsync(order.Id);

            if (existingMapping != null)
            {
                existingMapping.AdisyoOrderId = 0;
                existingMapping.SyncStatus = "Failed";
                existingMapping.LastSyncDate = DateTime.UtcNow;
                existingMapping.ErrorMessage = ex.Message;
                await _orderMappingService.UpdateAsync(existingMapping);
            }
            else
            {
                // Create failed mapping record
                var failedMapping = new AdisyoOrderMapping {
                    GrandNodeOrderId = order.Id,
                    AdisyoOrderId = 0,
                    SentToAdisyoDate = DateTime.UtcNow,
                    SyncStatus = "Failed",
                    LastSyncDate = DateTime.UtcNow,
                    ErrorMessage = ex.Message
                };
                await _orderMappingService.InsertAsync(failedMapping);
            }
            throw;
        }
    }

    public async Task<bool> CancelOrderInAdisyoAsync(string grandNodeOrderId, string? cancelReason = null)
    {
        try
        {
            var mapping = await _orderMappingService.GetByGrandNodeOrderIdAsync(grandNodeOrderId);
            if (mapping == null)
            {
                _logger.LogWarning("Order mapping not found for order {OrderId}", grandNodeOrderId);
                return false;
            }

            if (mapping.AdisyoOrderId == 0)
            {
                _logger.LogWarning("Order {OrderId} has no valid Adisyo order ID", grandNodeOrderId);
                return false;
            }

            await _adisyoApiService.CancelOrderAsync(mapping.AdisyoOrderId, cancelReason);

            // Update mapping status
            mapping.SyncStatus = "Cancelled";
            mapping.CancelReason = cancelReason;
            await _orderMappingService.UpdateAsync(mapping);

            _logger.LogInformation("Successfully cancelled order {OrderId} in Adisyo", grandNodeOrderId);
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to cancel order {OrderId} in Adisyo", grandNodeOrderId);
            return false;
        }
    }

    public async Task SyncOrderStatusAsync()
    {
        try
        {
            _logger.LogInformation("Starting order status synchronization from Adisyo");

            var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
            if (!settings.EnableOrderStatusSync)
            {
                _logger.LogDebug("Order status sync is disabled");
                return;
            }

            // Get recent orders from Adisyo
            var recentOrdersRequest = new AdisyoRecentOrdersRequest {
                Page = 1,
                MinimumUpdateDate = DateTime.UtcNow.AddMinutes(-(12*60))
                    .ToString("yyyy-MM-dd HH:mm:ss")
            };

            var recentOrders = await _adisyoApiService.GetRecentOrdersAsync(recentOrdersRequest);

            foreach (var adisyoOrder in recentOrders.Data)
            {
                await UpdateGrandNodeOrderStatusAsync(adisyoOrder);
            }

            _logger.LogInformation("Completed order status synchronization. Processed {Count} orders",
                recentOrders.Data.Count);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during order status synchronization");
        }
    }

    public async Task<bool> CanSendOrderToAdisyoAsync(Order order)
    {
        // Check if order is already sent to Adisyo
        var existingMapping = await _orderMappingService.GetByGrandNodeOrderIdAsync(order.Id);
        if (existingMapping is { AdisyoOrderId: > 0 })
        {
            _logger.LogWarning("Order {OrderId} is already sent to Adisyo with ID {AdisyoOrderId}",
                order.Id, existingMapping.AdisyoOrderId);
            return false;
        }

        // Check if order has valid products
        if (!order.OrderItems.Any())
        {
            return false;
        }

        // Check if customer information is available
        var customer = await _customerService.GetCustomerById(order.CustomerId);
        if (customer == null)
        {
            return false;
        }

        // Check if billing address is available
        var shipRequired = order.ShippingStatusId == ShippingStatus.ShippingNotRequired;
        var orderAddress = shipRequired ? order.ShippingAddress : order.BillingAddress;
        if (orderAddress == null)
        {
            return false;
        }
        
        if(order.OrderStatusId == (int)OrderStatusSystem.Complete ||
           order.OrderStatusId == (int)OrderStatusSystem.Cancelled)
        {
            _logger.LogWarning("Order {OrderId} is already completed or cancelled, cannot send to Adisyo",
                order.Id);
            return false;
        }
        
        return true;
    }

    public int? GetAdisyoOrderId(Order order)
    {
        var mapping = _orderMappingService.GetByGrandNodeOrderIdAsync(order.Id).Result;
        return mapping?.AdisyoOrderId;
    }

    public async Task StoreAdisyoOrderIdAsync(Order order, int adisyoOrderId)
    {
        var existingMapping = await _orderMappingService.GetByGrandNodeOrderIdAsync(order.Id);
        if (existingMapping != null)
        {
            // Update existing mapping
            existingMapping.AdisyoOrderId = adisyoOrderId;
            existingMapping.SentToAdisyoDate = DateTime.UtcNow;
            existingMapping.SyncStatus = "Sent";
            existingMapping.LastSyncDate = DateTime.UtcNow;
            await _orderMappingService.UpdateAsync(existingMapping);
            return;
        }
        var mapping = new AdisyoOrderMapping {
            GrandNodeOrderId = order.Id,
            AdisyoOrderId = adisyoOrderId,
            SentToAdisyoDate = DateTime.UtcNow,
            SyncStatus = "Sent",
            LastSyncDate = DateTime.UtcNow
        };

        await _orderMappingService.InsertAsync(mapping);
    }

    public async Task SyncCompletedOrdersAsync()
    {
        try
        {
            var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
            var completedOrderRequest = new AdisyoCompletedOrdersRequest {
                Page = 1,
                StartDate = DateTime.UtcNow.AddMinutes(-(12*60))
                    .ToString("yyyy-MM-dd HH:mm:ss"),
                IncludeCancelled = true,
                OrderType = settings.OrderType.ToString()
            };
        
            var completedOrders = await _adisyoApiService.GetCompletedOrdersAsync(completedOrderRequest);

            if (completedOrders.Orders != null)
            {
                foreach (var completedOrder in completedOrders.Orders)
                {
                    try
                    {
                        // Update GrandNode order status
                        await UpdateGrandNodeOrderStatusAsync(completedOrder);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "Error updating GrandNode order status for completed order {AdisyoOrderId}",
                            completedOrder.Id);
                    }
                }
            }
        }
        catch (Exception e)
        {
            _logger.LogError(e," Error syncing completed orders from Adisyo");
        }
        
    }

    private async Task<AdisyoOrderRequest> ConvertToAdisyoOrderAsync(Order order,
        Grand.Domain.Customers.Customer customer, AdisyoIntegrationSettings settings)
    {
        //Payment description 
        var paymentMethod = _paymentService.LoadPaymentMethodBySystemName(order.PaymentMethodSystemName);
        var paymentDescription =
            paymentMethod != null ? paymentMethod.FriendlyName : order.PaymentMethodSystemName;
        
        // Determine payment method ID using mapping
        var paymentMethodId = GetMappedPaymentMethodId(order.PaymentMethodSystemName, settings);
        
        // Calculate order items total
        var orderItemsTotal = order.OrderItems.Sum(x => x.UnitPriceWithoutDiscInclTax * x.Quantity);
        
        if (orderItemsTotal <= 0)
        {
            _logger.LogWarning("Order {OrderId} has zero or negative total, cannot send to Adisyo", order.Id);
            throw new InvalidOperationException($"Order {order.Id} has invalid total amount");
        }
        
        // Convert order items
        var orderDetails = await ConvertOrderItemsAsync(order.OrderItems, settings);
        
        // Calculate the final totals
        double adisyoOrderTotal;
        double adisyoDiscount = 0;
        
        if (orderItemsTotal > order.OrderTotal)
        {
            // Case 1: Order items total is greater than GrandNode order total
            // Adisyo order total = order items total
            // Discount = order items total - GrandNode order total
            adisyoOrderTotal = orderItemsTotal;
            adisyoDiscount = orderItemsTotal - order.OrderTotal;
            
            _logger.LogInformation("Order {OrderId}: Items total ({ItemsTotal}) > GrandNode total ({OrderTotal}). Setting discount: {Discount}", 
                order.Id, orderItemsTotal, order.OrderTotal, adisyoDiscount);
        }
        else if (orderItemsTotal < order.OrderTotal)
        {
            // Case 2: Order items total is less than GrandNode order total
            // Need to add service fee products
            var difference = order.OrderTotal - orderItemsTotal;
            
            if (!string.IsNullOrEmpty(settings.ServiceFeeCategoryId))
            {
                _logger.LogInformation("Order {OrderId}: Items total ({ItemsTotal}) < GrandNode total ({OrderTotal}). Adding service fee: {ServiceFee}", 
                    order.Id, orderItemsTotal, order.OrderTotal, difference);
                
                // Get Adisyo categories to find service fee products
                var categories = await _adisyoApiService.GetProductCategoriesAsync();
                var serviceFeeCategory = categories.FirstOrDefault(c => c.CategoryId.ToString() == settings.ServiceFeeCategoryId);
                
                if (serviceFeeCategory?.Products != null && serviceFeeCategory.Products.Any())
                {
                    // Find products that can cover the difference
                    var serviceFeeDetails = await CreateServiceFeeOrderDetails(serviceFeeCategory.Products, difference, settings);
                    
                    if (serviceFeeDetails.Any())
                    {
                        orderDetails.AddRange(serviceFeeDetails);
                        
                        // Recalculate order items total after adding service fee
                        var newOrderItemsTotal = orderItemsTotal + serviceFeeDetails.Sum(d => 
                            (d.Quantity ?? 0) * GetProductPrice(serviceFeeCategory.Products, d.ProductUnitId, settings.OrderType));
                        
                        if (newOrderItemsTotal > order.OrderTotal)
                        {
                            // If new total is greater than GrandNode total, add discount
                            adisyoOrderTotal = newOrderItemsTotal;
                            adisyoDiscount = newOrderItemsTotal - order.OrderTotal;
                        }
                        else
                        {
                            // New total should match GrandNode total
                            adisyoOrderTotal = order.OrderTotal;
                            adisyoDiscount = 0;
                        }
                    }
                    else
                    {
                        // No suitable service fee products found
                        _logger.LogWarning("Order {OrderId}: No suitable service fee products found to cover difference", order.Id);
                        adisyoOrderTotal = orderItemsTotal;
                        adisyoDiscount = 0;
                    }
                }
                else
                {
                    // Service fee category not found or has no products
                    _logger.LogWarning("Order {OrderId}: Service fee category {CategoryId} not found or has no products", 
                        order.Id, settings.ServiceFeeCategoryId);
                    adisyoOrderTotal = orderItemsTotal;
                    adisyoDiscount = 0;
                }
            }
            else
            {
                // No service fee category configured
                _logger.LogInformation("Order {OrderId}: No service fee category configured. Using GrandNode total", order.Id);
                adisyoOrderTotal = orderItemsTotal;
                adisyoDiscount = 0;
            }
        }
        else
        {
            // Case 3: Order items total equals GrandNode order total
            adisyoOrderTotal = order.OrderTotal;
            adisyoDiscount = 0;
        }
        
        // Ensure the equation is always satisfied: adisyoOrderTotal - adisyoDiscount = order.OrderTotal
        _logger.LogInformation("Order {OrderId} final calculation: AdisyoTotal={AdisyoTotal}, Discount={Discount}, GrandNodeTotal={GrandTotal}", 
            order.Id, adisyoOrderTotal, adisyoDiscount, order.OrderTotal);
        
        //Order address
        var shipRequired = order.ShippingStatusId == ShippingStatus.ShippingNotRequired;
        var orderAddress = shipRequired ? order.ShippingAddress : order.BillingAddress;
        var orderRequest = new AdisyoOrderRequest {
            CustomerName = orderAddress?.FirstName ?? "Ad",
            CustomerSurname = orderAddress?.LastName ?? "Soyad",
            CustomerPhone = orderAddress?.PhoneNumber ?? "",
            Address = await ConvertAddressToStringAsync(orderAddress),
            PaymentMethodId = paymentMethodId,
            OrderTotal = adisyoOrderTotal,
            WebOrderId = order.Id,
            OrderNote = orderAddress?.Note,
            CustomerId = customer.Id,
            Discount = adisyoDiscount,
            PaymentNote = paymentDescription,
            OrderDetails = orderDetails
        };

        // Add optional address information
        if (orderAddress != null)
        {
            var stateProvince = await _countryService.GetStateProvincesByCountryId(orderAddress.CountryId);
            var city = stateProvince?.FirstOrDefault(x => x.Id == orderAddress.StateProvinceId);
            if (city != null)
            {
                orderRequest.City = city.Name;
            }
            orderRequest.OrderNote = orderAddress.Note;
            orderRequest.Region = orderAddress.City;

            var aciklamaId = await AciklamaAttributeId();
            orderRequest.AddressDescription = orderAddress.Attributes.FirstOrDefault(x=>x.Key ==
                aciklamaId)?.Value;
        }

        return orderRequest;
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
    
    private async Task<string> GetDistrictNameAsync(string? stateProvinceId)
    {
        try
        {
            if (string.IsNullOrEmpty(stateProvinceId))
                return "";

            var countries = await _countryService.GetAllCountries();
            var districtName= countries.SelectMany(x => x.StateProvinces).FirstOrDefault(x => x.Id == stateProvinceId)?.Name ?? "";
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

    private async Task<List<AdisyoOrderDetail>> ConvertOrderItemsAsync(
        ICollection<OrderItem> orderItems, AdisyoIntegrationSettings settings)
    {
        var orderDetails = new List<AdisyoOrderDetail>();

        foreach (var item in orderItems)
        {
            var product = await _productService.GetProductById(item.ProductId);
            if (product == null) continue;

            var orderDetail = new AdisyoOrderDetail {
                Quantity = item.Quantity,
                IsMenu = false
            };

            // Use product mapping strategy from settings
            if (!string.IsNullOrEmpty(product.ExternalId) && product.ExternalId.StartsWith("adisyo") && !string.IsNullOrEmpty(product.Sku))
            {
                if(int.TryParse(product.ExternalId.Replace("adisyo-",string.Empty),out var prUnitId))
                {
                    orderDetail.ProductUnitId = prUnitId;
                }
                else
                {
                    orderDetail.ProductCode = product.Sku;
                }
                
                foreach (var productAttributeValue in product.ParseProductAttributeValues(item.Attributes))
                {
                    var adisyoFeature = await _featureValueMappingRepository.Table.FirstOrDefaultAsync(x=>x.GrandNodeProductAttributeValueId == productAttributeValue.Id);
                    if (adisyoFeature == null) continue;
                    orderDetail.Features ??= new List<AdisyoOrderFeature>();
                    orderDetail.Features.Add(new AdisyoOrderFeature() {
                        FeatureId = adisyoFeature.AdisyoFeatureId,
                        Name = adisyoFeature.FeatureName
                    });
                }
            }
            else
            {
               continue;
            }

            orderDetails.Add(orderDetail);
        }

        return orderDetails;
    }

    private async Task UpdateGrandNodeOrderStatusAsync(AdisyoOrderInfo adisyoOrder)
    {
        try
        {
            // Find mapping by Adisyo order ID
            order_mapping:
            var mapping = await _orderMappingService.GetByAdisyoOrderIdAsync(adisyoOrder?.Id??0);
            if (mapping == null)
            {
                mapping = await _orderMappingService.GetByGrandNodeOrderIdAsync(adisyoOrder?.ExternalAppId);
                if (mapping == null)
                {
                    _logger.LogWarning("Order mapping not found for Adisyo order ID {AdisyoOrderId}", adisyoOrder.Id);
                    return;
                }
                else
                {
                    mapping.AdisyoOrderId = adisyoOrder?.Id??0;
                    var tempOrder = await _orderService.GetOrderById(mapping.GrandNodeOrderId);
                    
                    if(tempOrder == null)
                        return;

                    await StoreAdisyoOrderIdAsync(await _orderService.GetOrderById(mapping.GrandNodeOrderId),
                        mapping.AdisyoOrderId);
                    
                    goto order_mapping;
                }
               
            }

            // Get GrandNode order
            var order = await _orderService.GetOrderById(mapping.GrandNodeOrderId);
            if (order == null)
            {
                _logger.LogWarning("GrandNode order not found for order ID {OrderId}", mapping.GrandNodeOrderId);
                return;
            }

            

            // Handle different Adisyo statuses
            switch (adisyoOrder.StatusId)
            {
                case 5: // Teslimatta (On Delivery)
                    await HandleShipmentCreationAsync(order);
                    break;
                    
                case 7: // Başarılı tamamlanan siparişler (Successfully completed)
                    await HandleCompletedOrderAsync(order);
                    break;
                    
                case 9: // İade veya İptal siparişler (Cancelled/Refunded)
                    await HandleCancelledOrRefundedOrderAsync(order);
                    break;
                    
                default:
                    // Handle other statuses with existing logic
                    var newOrderStatus = MapAdisyoStatusToGrandNodeStatus(adisyoOrder?.StatusId ?? 0);
                    if (newOrderStatus != null && order.ShippingStatusId != (ShippingStatus)newOrderStatus.Value)
                    {
                        _logger.LogInformation(
                            "Updated order {OrderId} status to {Status} based on Adisyo order {AdisyoOrderId}",
                            order.Id, newOrderStatus.Value, adisyoOrder.Id);
                    }
                    break;
            }
            
            // Update mapping with latest Adisyo status
            mapping.AdisyoOrderStatus = adisyoOrder.Status;
            await _orderMappingService.UpdateAsync(mapping);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating GrandNode order status for Adisyo order {AdisyoOrderId}",
                adisyoOrder.Id);
        }
    }

    private int GetMappedPaymentMethodId(string paymentMethodSystemName, AdisyoIntegrationSettings settings)
    {
        try
        {
            // Try to get mapping from settings
            if (!string.IsNullOrEmpty(settings.PaymentMethodMappings))
            {
                var mappings = JsonSerializer.Deserialize<Dictionary<string, int>>(settings.PaymentMethodMappings);
                if (mappings != null && mappings.TryGetValue(paymentMethodSystemName, out var mappedId))
                {
                    _logger.LogDebug("Using mapped payment method ID {PaymentMethodId} for {SystemName}", 
                        mappedId, paymentMethodSystemName);
                    return mappedId;
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to deserialize payment method mappings");
        }

        // Fallback to default payment method ID from settings
        _logger.LogWarning("No mapping found for payment method {SystemName}, using default payment method ID {DefaultId}", 
            paymentMethodSystemName, settings.PaymentMethodId);
        return settings.PaymentMethodId;
    }

    private static int? MapAdisyoStatusToGrandNodeStatus(string adisyoStatus)
    {
        return adisyoStatus.ToLowerInvariant() switch {
            "ordered" => (int)ShippingStatus.Pending,
            "cooked" =>  (int)ShippingStatus.Pending,
            "Sipariş Alındı" =>  (int)ShippingStatus.Pending,
            "ondelivery" =>  (int)ShippingStatus.Shipped,
            "teslimatta"=>  (int)ShippingStatus.Shipped,
            "completed" =>  (int)ShippingStatus.Delivered,
            "kapandı" =>  (int)ShippingStatus.Delivered,
            "cancelled" =>  (int)ShippingStatus.ShippingNotRequired,
            _ => (int)ShippingStatus.ShippingNotRequired
        };
    }
    
    private static int? MapAdisyoStatusToGrandNodeStatus(int adisyoStatus)
    {
        return adisyoStatus switch {
            //Hazırlandı
            1 => (int)ShippingStatus.Pending,
            3 => (int) ShippingStatus.Pending,
            //Teslimatta
            5 => (int)ShippingStatus.Shipped,
            //Kapandı
            7 =>  (int)ShippingStatus.Delivered,
            //İptal edildi
            9 => (int)ShippingStatus.ShippingNotRequired,
            _ => (int)ShippingStatus.ShippingNotRequired
        };
    }

    private async Task HandleCompletedOrderAsync(Order order)
    {
        try
        {
            _logger.LogInformation("Processing completed order {OrderId} from Adisyo", order.Id);

            // For cash on delivery orders, mark payment as paid and then deliver
            if (IsCashOnDeliveryPayment(order.PaymentMethodSystemName))
            {
                // Mark payment as paid if not already paid
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

            // Handle delivery status
            await HandleOrderDeliveryAsync(order);
            
            _logger.LogInformation("Successfully processed completed order {OrderId}", order.Id);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error handling completed order {OrderId}", order.Id);
        }
    }

    private async Task HandleCancelledOrRefundedOrderAsync(Order order)
    {
        try
        {
            _logger.LogInformation("Processing cancelled/refunded order {OrderId} from Adisyo", order.Id);

            var isCashOnDelivery = IsCashOnDeliveryPayment(order.PaymentMethodSystemName);
            var paymentTransactions = await _paymentTransactionService.GetByOrderCode(order.Code);
            var hasPayments = paymentTransactions?.Any() == true;
            var isOrderDelivered = order.ShippingStatusId == ShippingStatus.Delivered;

            if (isCashOnDelivery)
            {
                // For cash on delivery, handle all cancellations/refunds in GrandNode
                await CancelOrderInGrandNodeAsync(order.Id);
            }
            else if (hasPayments)
            {
                // Online payment
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
                // No payments (either refunded or never taken) - just cancel
                await CancelOrderInGrandNodeAsync(order.Id);
            }
            
            _logger.LogInformation("Successfully processed cancelled/refunded order {OrderId}", order.Id);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error handling cancelled/refunded order {OrderId}", order.Id);
        }
    }

    private async Task HandleOrderDeliveryAsync(Order order)
    {
        try
        {
            var existingShipments = await _shipmentService.GetShipmentsByOrder(order.Id);
            
            if (existingShipments.Any())
            {
                // Mark existing shipment as delivered if not already
                var undeliveredShipment = existingShipments.FirstOrDefault(s => !s.DeliveryDateUtc.HasValue);
                if (undeliveredShipment != null)
                {
                    await _mediator.Send(new DeliveryCommand { Shipment = undeliveredShipment, NotifyCustomer = true });
                    _logger.LogInformation("Marked shipment {ShipmentId} as delivered for order {OrderId}", 
                        undeliveredShipment.Id, order.Id);
                }
            }
            else
            {
                // Create shipment and immediately mark as delivered
                await CreateAndDeliverShipmentAsync(order);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error handling order delivery for order {OrderId}", order.Id);
        }
    }

    private async Task CreateAndDeliverShipmentAsync(Order order)
    {
        try
        {
            if (order.ShippingStatusId == ShippingStatus.ShippingNotRequired)
            {
                _logger.LogDebug("Order {OrderId} does not require shipping", order.Id);
                return;
            }

            var shipment = new Shipment
            {
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
                    var shipmentItem = new ShipmentItem
                    {
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
                
                // Ship and deliver immediately
                await _mediator.Send(new ShipCommand { Shipment = shipment, NotifyCustomer = true });
                await _mediator.Send(new DeliveryCommand { Shipment = shipment, NotifyCustomer = true });
                
                _logger.LogInformation("Created and delivered shipment {ShipmentId} for completed order {OrderId}", 
                    shipment.Id, order.Id);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating and delivering shipment for order {OrderId}", order.Id);
        }
    }

    private async Task HandleShipmentCreationAsync(Order order)
    {
        try
        {
            // Check if order already has shipments
            var existingShipments = await _shipmentService.GetShipmentsByOrder(order.Id);
            if (existingShipments.Any())
            {
                _logger.LogDebug("Order {OrderId} already has shipments, skipping creation", order.Id);
                
                // Mark existing shipment as shipped if not already
                var unshippedShipment = existingShipments.FirstOrDefault(s => !s.ShippedDateUtc.HasValue);
                if (unshippedShipment != null)
                {
                    await _mediator.Send(new ShipCommand { Shipment = unshippedShipment, NotifyCustomer = true });
                    _logger.LogInformation("Marked shipment {ShipmentId} as shipped for order {OrderId}", 
                        unshippedShipment.Id, order.Id);
                }
                return;
            }

            // Check if order can be shipped
            if (order.ShippingStatusId != ShippingStatus.ShippingNotRequired && 
                order.ShippingStatusId != ShippingStatus.Shipped)
            {
                // Create shipment with all order items
                var shipment = new Shipment
                {
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
                        var shipmentItem = new ShipmentItem
                        {
                            OrderItemId = orderItem.Id,
                            Quantity = orderItem.Quantity,
                            WarehouseId = product.WarehouseId
                        };
                        shipment.ShipmentItems.Add(shipmentItem);
                    }
                }

                // Only create shipment if there are items to ship
                if (shipment.ShipmentItems.Any())
                {
                    await _shipmentService.InsertShipment(shipment);
                    
                    // Mark as shipped immediately since Adisyo says it's "ondelivery"
                    await _mediator.Send(new ShipCommand { Shipment = shipment, NotifyCustomer = true });
                    
                    _logger.LogInformation("Created and shipped shipment {ShipmentId} for order {OrderId} based on Adisyo ondelivery status", 
                        shipment.Id, order.Id);
                }
            }
            else
            {
                _logger.LogWarning("Order {OrderId} cannot be shipped", order.Id);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error handling shipment creation for order {OrderId}", order.Id);
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

    private Task<List<AdisyoOrderDetail>> CreateServiceFeeOrderDetails(
        List<AdisyoProduct> serviceFeeProducts, double targetAmount, AdisyoIntegrationSettings settings)
    {
        var orderDetails = new List<AdisyoOrderDetail>();
        var remainingAmount = targetAmount;
        
        // Sort products by price descending to use larger denominations first
        var sortedProducts = serviceFeeProducts
            .SelectMany(p => p.ProductUnits ?? new List<AdisyoProductUnit>())
            .Where(pu => pu.Prices != null && pu.Prices.Any())
            .Select(pu => new {
                ProductUnit = pu,
                Price = pu.Prices.FirstOrDefault(pr => pr.OrderType == settings.OrderType)?.Price 
                        ?? pu.Prices.FirstOrDefault()?.Price ?? 0
            })
            .Where(x => x.Price > 0)
            .OrderByDescending(x => x.Price)
            .ToList();
        
        if (!sortedProducts.Any())
        {
            _logger.LogWarning("No valid service fee products found with prices");
            return Task.FromResult(orderDetails);
        }
        
        foreach (var productInfo in sortedProducts)
        {
            if (remainingAmount <= 0) break;
            
            // Calculate how many of this product we need
            var quantity = (int)(remainingAmount / productInfo.Price);
            if (quantity > 0)
            {
                orderDetails.Add(new AdisyoOrderDetail {
                    ProductUnitId = productInfo.ProductUnit.ProductUnitId,
                    Quantity = quantity,
                    IsMenu = false
                });
                
                remainingAmount -= quantity * productInfo.Price;
            }
        }
        
        // If there's still remaining amount, add one more of the smallest priced product
        if (remainingAmount > 0 && sortedProducts.Any())
        {
            var smallestProduct = sortedProducts.Last();
            var existingDetail = orderDetails.FirstOrDefault(d => d.ProductUnitId == smallestProduct.ProductUnit.ProductUnitId);
            
            if (existingDetail != null)
            {
                existingDetail.Quantity++;
            }
            else
            {
                orderDetails.Add(new AdisyoOrderDetail {
                    ProductUnitId = smallestProduct.ProductUnit.ProductUnitId,
                    Quantity = 1,
                    IsMenu = false
                });
            }
        }
        
        return Task.FromResult(orderDetails);
    }
    
    private double GetProductPrice(List<AdisyoProduct> products, int? productUnitId, int orderType)
    {
        if (!productUnitId.HasValue) return 0;
        
        var productUnit = products
            .SelectMany(p => p.ProductUnits ?? new List<AdisyoProductUnit>())
            .FirstOrDefault(pu => pu.ProductUnitId == productUnitId);
            
        if (productUnit?.Prices == null) return 0;
        
        // Try to find price for specific order type first
        var price = productUnit.Prices.FirstOrDefault(p => p.OrderType == orderType)?.Price;
        
        // Fallback to first available price
        if (!price.HasValue || price.Value == 0)
        {
            price = productUnit.Prices.FirstOrDefault()?.Price;
        }
        
        return price ?? 0;
    }
}