using System.Text.Json.Serialization;

namespace Famizyo.Integration.Adisyo.Models;

#region Response Models

public class AdisyoApiResponse<T>
{
    [JsonPropertyName("data")]
    public T? Data { get; set; }
    
    [JsonPropertyName("status")]
    public int? Status { get; set; }
    
    [JsonPropertyName("message")]
    public string? Message { get; set; }
}

public class AdisyoOrderResponse
{
    [JsonPropertyName("Status")]
    public int? Status { get; set; }
    
    [JsonPropertyName("Message")]
    public string? Message { get; set; }
    
    [JsonPropertyName("OrderId")]
    public int? OrderId { get; set; }
    
    [JsonPropertyName("OrderTotal")]
    public decimal? OrderTotal { get; set; }
    
    [JsonPropertyName("Discount")]
    public decimal? Discount { get; set; }
    
    [JsonPropertyName("InsertedDate")]
    public DateTime? InsertedDate { get; set; }
}

#endregion

#region Product Models

public class AdisyoProductCategory
{
    public AdisyoProductCategory()
    {
        Products = new List<AdisyoProduct>();
    }
    [JsonPropertyName("categoryId")]
    public int? CategoryId { get; set; }
    
    [JsonPropertyName("categoryName")]
    public string? CategoryName { get; set; }
    
    [JsonPropertyName("photoUrl")]
    public string? PhotoUrl { get; set; }
    
    [JsonPropertyName("products")]
    public List<AdisyoProduct>? Products { get; set; } = new();
}

public class AdisyoProduct
{
    public AdisyoProduct()
    {
        ProductUnits = new List<AdisyoProductUnit>();
        Menus = new List<AdisyoMenu>();
    }
    [JsonPropertyName("productName")]
    public string? ProductName { get; set; }
    
    [JsonPropertyName("productCode")]
    public string? ProductCode { get; set; }
    
    [JsonPropertyName("productId")]
    public int? ProductId { get; set; }
    
    [JsonPropertyName("taxRate")]
    public decimal? TaxRate { get; set; }
    
    [JsonPropertyName("isStockFollow")]
    public bool? IsStockFollow { get; set; }
    
    [JsonPropertyName("productUnits")]
    public List<AdisyoProductUnit>? ProductUnits { get; set; } = new();
    
    [JsonPropertyName("menus")]
    public List<AdisyoMenu>? Menus { get; set; }
    
    [JsonPropertyName("photoUrl")]
    public string? PhotoUrl { get; set; }
}

public class AdisyoProductUnit
{
    public AdisyoProductUnit()
    {
        Prices = new List<AdisyoPrice>();
    }
    [JsonPropertyName("productUnitId")]
    public int? ProductUnitId { get; set; }
    
    [JsonPropertyName("unitName")]
    public string? UnitName { get; set; }
    
    [JsonPropertyName("prices")]
    public List<AdisyoPrice>? Prices { get; set; } = new();
}

public class AdisyoPrice
{
    [JsonPropertyName("price")]
    public double? Price { get; set; }
    
    [JsonPropertyName("orderType")]
    public int? OrderType { get; set; }
}

public class AdisyoMenu
{
    [JsonPropertyName("menuId")]
    public int? MenuId { get; set; }
    
    [JsonPropertyName("menuName")]
    public string? MenuName { get; set; }
}

#endregion

#region Feature Models

public class AdisyoFeatureGroup
{
    public AdisyoFeatureGroup()
    {
        Features = new List<AdisyoFeature>();
    }
    [JsonPropertyName("featureGroupId")]
    public int? FeatureGroupId { get; set; }
    
    [JsonPropertyName("featuresGroupName")]
    public string? FeaturesGroupName { get; set; }
    
    [JsonPropertyName("necessaryCount")]
    public int? NecessaryCount { get; set; }
    
    [JsonPropertyName("featureHeaderType")]
    public string? FeatureHeaderType { get; set; }
    
    [JsonPropertyName("features")]
    public List<AdisyoFeature>? Features { get; set; } = new();
}

public class AdisyoFeature
{
    public AdisyoFeature()
    {
        RelatedProducts = new List<AdisyoRelatedProduct>();
    }
    [JsonPropertyName("featureName")]
    public string? FeatureName { get; set; }
    
    [JsonPropertyName("featureId")]
    public int? FeatureId { get; set; }
    
    [JsonPropertyName("relatedProducts")]
    public List<AdisyoRelatedProduct>? RelatedProducts { get; set; } = new();
}

public class AdisyoRelatedProduct
{
    [JsonPropertyName("productId")]
    public int? ProductId { get; set; }
    
    [JsonPropertyName("additionalPrice")]
    public decimal? AdditionalPrice { get; set; }
    
    [JsonPropertyName("featureHeaderName")]
    public string? FeatureHeaderName { get; set; }
}

#endregion

#region Payment Models

public class AdisyoPaymentType
{
    [JsonPropertyName("Name")]
    public string? Name { get; set; }
    
    [JsonPropertyName("Id")]
    public int? Id { get; set; }
    
    [JsonPropertyName("IsOnline")]
    public bool? IsOnline { get; set; }
}

public class AdisyoPaymentTypesResponse
{
    public AdisyoPaymentTypesResponse()
    {
        PaymentTypes = new List<AdisyoPaymentType>();
    }
    [JsonPropertyName("Status")]
    public int? Status { get; set; }
    
    [JsonPropertyName("Message")]
    public string? Message { get; set; }
    
    [JsonPropertyName("PaymentTypes")]
    public List<AdisyoPaymentType>? PaymentTypes { get; set; } = new();
}

#endregion

#region Order Models

public class AdisyoOrderRequest
{
    public AdisyoOrderRequest()
    {
        OrderDetails = new List<AdisyoOrderDetail>();
    }
    [JsonPropertyName("CustomerName")]
    public string? CustomerName { get; set; }
    
    [JsonPropertyName("CustomerSurname")]
    public string? CustomerSurname { get; set; }
    
    [JsonPropertyName("CustomerPhone")]
    public string? CustomerPhone { get; set; }
    
    [JsonPropertyName("Address")]
    public string? Address { get; set; }
    
    [JsonPropertyName("PaymentMethodId")]
    public int? PaymentMethodId { get; set; }
    
    [JsonPropertyName("OrderTotal")]
    public double? OrderTotal { get; set; }
    
    [JsonPropertyName("OrderDetails")]
    public List<AdisyoOrderDetail>? OrderDetails { get; set; } = new();
    
    // Optional fields
    [JsonPropertyName("CustomerId")]
    public string? CustomerId { get; set; }
    
    [JsonPropertyName("CustomerPhone2")]
    public string? CustomerPhone2 { get; set; }
    
    [JsonPropertyName("AddressDescription")]
    public string? AddressDescription { get; set; }
    
    [JsonPropertyName("Region")]
    public string? Region { get; set; }
    
    [JsonPropertyName("City")]
    public string? City { get; set; }
    
    [JsonPropertyName("PaymentNote")]
    public string? PaymentNote { get; set; }
    
    [JsonPropertyName("Discount")]
    public double? Discount { get; set; }
    
    [JsonPropertyName("OrderNote")]
    public string? OrderNote { get; set; }
    
    [JsonPropertyName("WebOrderId")]
    public string? WebOrderId { get; set; }
    
    [JsonPropertyName("ParentId")]
    public int? ParentId { get; set; }
}

public class AdisyoOrderDetail
{
    public AdisyoOrderDetail()
    {
        Features = new List<AdisyoOrderFeature>();
    }
    [JsonPropertyName("Quantity")]
    public int? Quantity { get; set; }
    
    [JsonPropertyName("ProductUnitId")]
    public int? ProductUnitId { get; set; }
    
    [JsonPropertyName("ProductCode")]
    public string? ProductCode { get; set; }
    
    [JsonPropertyName("OrderDetailNote")]
    public string? OrderDetailNote { get; set; }
    
    [JsonPropertyName("Features")]
    public List<AdisyoOrderFeature>? Features { get; set; }
    
    [JsonPropertyName("IsMenu")]
    public bool? IsMenu { get; set; }
    
    [JsonPropertyName("MenuId")]
    public int? MenuId { get; set; }
    
    [JsonPropertyName("ParentId")]
    public int? ParentId { get; set; }
}

public class AdisyoOrderFeature
{
    [JsonPropertyName("FeatureId")]
    public int? FeatureId { get; set; }
    
    [JsonPropertyName("Name")]
    public string? Name { get; set; }
}

public class AdisyoCancelOrderRequest
{
    [JsonPropertyName("OrderId")]
    public int? OrderId { get; set; }
    
    [JsonPropertyName("CancelReason")]
    public string? CancelReason { get; set; }
}

#endregion

#region Query Models

public class AdisyoRecentOrdersRequest
{
    public int? Page { get; set; } = 1;
    public int? MinimumId { get; set; }
    public string? MinimumUpdateDate { get; set; }
    public string? Status { get; set; }
}

public class AdisyoCompletedOrdersRequest
{
    public int? Page { get; set; } = 1;
    public string? StartDate { get; set; }
    public bool? IncludeCancelled { get; set; } = false;
    public string? OrderType { get; set; }
}

public class AdisyoOrderCustomer
{
    [JsonPropertyName("customerName")]
    public string? CustomerName { get; set; }

    [JsonPropertyName("customerSurname")]
    public string? CustomerSurname { get; set; }

    [JsonPropertyName("customerEmail")]
    public object? CustomerEmail { get; set; }

    [JsonPropertyName("customerId")]
    public int? CustomerId { get; set; }

    [JsonPropertyName("customerPhone")]
    public string? CustomerPhone { get; set; }

    [JsonPropertyName("customerPhone2")]
    public object? CustomerPhone2 { get; set; }

    [JsonPropertyName("address")]
    public string? Address { get; set; }

    [JsonPropertyName("addressDescription")]
    public string? AddressDescription { get; set; }

    [JsonPropertyName("region")]
    public string? Region { get; set; }

    [JsonPropertyName("addressHeader")]
    public string? AddressHeader { get; set; }

    [JsonPropertyName("city")]
    public string? City { get; set; }

    [JsonPropertyName("company")]
    public string? Company { get; set; }

    [JsonPropertyName("phoneCode")]
    public string? PhoneCode { get; set; }

    [JsonPropertyName("addressId")]
    public int? AddressId { get; set; }

    [JsonPropertyName("isDefault")]
    public string? IsDefault { get; set; }
}

public class AdisyoOrderInfo
{
    public AdisyoOrderInfo()
    {
        Payments = new List<AdisyoOrderPayment>();
        Products = new List<AdisyoOrderItem>();
    }
    [JsonPropertyName("id")]
    public int? Id { get; set; }

    [JsonPropertyName("waiterName")]
    public string? WaiterName { get; set; }

    [JsonPropertyName("deliveryUserName")]
    public object? DeliveryUserName { get; set; }

    [JsonPropertyName("courierId")]
    public int? CourierId { get; set; }

    [JsonPropertyName("externalAppName")]
    public object? ExternalAppName { get; set; }

    [JsonPropertyName("restaurantName")]
    public object? RestaurantName { get; set; }

    [JsonPropertyName("orderTotal")]
    public double? OrderTotal { get; set; }

    [JsonPropertyName("paymentMethodName")]
    public string? PaymentMethodName { get; set; }

    [JsonPropertyName("paymentMethodId")]
    public int? PaymentMethodId { get; set; }

    [JsonPropertyName("deliveryTime")]
    public DateTime? DeliveryTime { get; set; }

    [JsonPropertyName("discountAmount")]
    public double? DiscountAmount { get; set; }

    [JsonPropertyName("currency")]
    public string? Currency { get; set; }

    [JsonPropertyName("orderNote")]
    public string? OrderNote { get; set; }

    [JsonPropertyName("externalAppId")]
    public string? ExternalAppId { get; set; }

    [JsonPropertyName("salesChannelId")]
    public int? SalesChannelId { get; set; }

    [JsonPropertyName("salesChannelName")]
    public string? SalesChannelName { get; set; }

    [JsonPropertyName("statusId")]
    public int? StatusId { get; set; }

    [JsonPropertyName("status")]
    public string? Status { get; set; }

    [JsonPropertyName("orderCancelReason")]
    public string? OrderCancelReason { get; set; }

    [JsonPropertyName("tableName")]
    public string? TableName { get; set; }

    [JsonPropertyName("orderNumber")]
    public int? OrderNumber { get; set; }

    [JsonPropertyName("taxAmount")]
    public double? TaxAmount { get; set; }

    [JsonPropertyName("insertDate")]
    public DateTime? InsertDate { get; set; }

    [JsonPropertyName("updateDate")]
    public DateTime? UpdateDate { get; set; }

    [JsonPropertyName("customerId")]
    public int? CustomerId { get; set; }

    [JsonPropertyName("customerLatitude")]
    public string? CustomerLatitude { get; set; }

    [JsonPropertyName("customerLongitude")]
    public string? CustomerLongitude { get; set; }

    [JsonPropertyName("confirmationCode")]
    public string? ConfirmationCode { get; set; }

    [JsonPropertyName("integrationRestaurantName")]
    public string? IntegrationRestaurantName { get; set; }

    [JsonPropertyName("addressId")]
    public int? AddressId { get; set; }

    [JsonPropertyName("isScheduledOrder")]
    public bool? IsScheduledOrder { get; set; }

    [JsonPropertyName("scheduledTime")]
    public DateTime? ScheduledTime { get; set; }

    [JsonPropertyName("deliveryType")]
    public int? DeliveryType { get; set; }

    [JsonPropertyName("restaurantKey")]
    public int? RestaurantKey { get; set; }

    [JsonPropertyName("externalAppKey")]
    public int? ExternalAppKey { get; set; }

    [JsonPropertyName("closedDate")]
    public DateTime? ClosedDate { get; set; }

    [JsonPropertyName("preparedDate")]
    public DateTime? PreparedDate { get; set; }

    [JsonPropertyName("customer")]
    public AdisyoOrderCustomer? AdisyoOrderCustomer { get; set; }

    [JsonPropertyName("products")]
    public List<AdisyoOrderItem>? Products { get; set; }

    [JsonPropertyName("payments")]
    public List<AdisyoOrderPayment>? Payments { get; set; }
}

public class AdisyoOrderPayment
{
    [JsonPropertyName("orderId")]
    public int? OrderId { get; set; }

    [JsonPropertyName("paymentTypeId")]
    public int? PaymentTypeId { get; set; }

    [JsonPropertyName("paymentName")]
    public string? PaymentName { get; set; }

    [JsonPropertyName("amount")]
    public double? Amount { get; set; }

    [JsonPropertyName("customerId")]
    public int? CustomerId { get; set; }

    [JsonPropertyName("customerName")]
    public string? CustomerName { get; set; }

    [JsonPropertyName("customerSurname")]
    public string? CustomerSurname { get; set; }

    [JsonPropertyName("isDebit")]
    public bool? IsDebit { get; set; }

    [JsonPropertyName("currencyId")]
    public int? CurrencyId { get; set; }

    [JsonPropertyName("currency")]
    public string? Currency { get; set; }

    [JsonPropertyName("exchangeRate")]
    public double? ExchangeRate { get; set; }

    [JsonPropertyName("insertDate")]
    public DateTime? InsertDate { get; set; }
}

public class Feature
{
    [JsonPropertyName("featureName")]
    public string? FeatureName { get; set; }

    [JsonPropertyName("additionalPrice")]
    public double? AdditionalPrice { get; set; }

    [JsonPropertyName("featureId")]
    public int? FeatureId { get; set; }

    [JsonPropertyName("orderDetailId")]
    public int? OrderDetailId { get; set; }
}

public class AdisyoOrderItem
{
    [JsonPropertyName("id")]
    public int? Id { get; set; }

    [JsonPropertyName("orderId")]
    public int? OrderId { get; set; }

    [JsonPropertyName("productUnitId")]
    public int? ProductUnitId { get; set; }

    [JsonPropertyName("quantity")]
    public double? Quantity { get; set; }

    [JsonPropertyName("unitPrice")]
    public double? UnitPrice { get; set; }

    [JsonPropertyName("productName")]
    public string? ProductName { get; set; }

    [JsonPropertyName("categoryName")]
    public string? CategoryName { get; set; }

    [JsonPropertyName("productNote")]
    public string? ProductNote { get; set; }

    [JsonPropertyName("productCode")]
    public string? ProductCode { get; set; }

    [JsonPropertyName("isMenu")]
    public bool? IsMenu { get; set; }

    [JsonPropertyName("parentId")]
    public int? ParentId { get; set; }

    [JsonPropertyName("cost")]
    public double? Cost { get; set; }

    [JsonPropertyName("totalAmount")]
    public double? TotalAmount { get; set; }

    [JsonPropertyName("groupName")]
    public string? GroupName { get; set; }

    [JsonPropertyName("groupId")]
    public int? GroupId { get; set; }

    [JsonPropertyName("discountAmount")]
    public double? DiscountAmount { get; set; }

    [JsonPropertyName("insertDate")]
    public DateTime? InsertDate { get; set; }

    [JsonPropertyName("description")]
    public string? Description { get; set; }

    [JsonPropertyName("cancelReason")]
    public string? CancelReason { get; set; }

    [JsonPropertyName("excludedComposites")]
    public object? ExcludedComposites { get; set; }

    [JsonPropertyName("excludedItems")]
    public List<object>? ExcludedItems { get; set; }

    [JsonPropertyName("features")]
    public List<Feature>? Features { get; set; }
}

public class AdisyoOrderQueryResponse
{
    [JsonPropertyName("data")]
    public List<AdisyoOrderInfo>? Data { get; set; }

    [JsonPropertyName("totalCount")]
    public int? TotalCount { get; set; }

    [JsonPropertyName("pageCount")]
    public int? PageCount { get; set; }

    [JsonPropertyName("status")]
    public int? Status { get; set; }

    [JsonPropertyName("message")]
    public object? Message { get; set; }
}

#endregion

#region Feature API Models

// New sophisticated models for Features endpoint
public class AdisyoFeaturesResponse
{
    public AdisyoFeaturesResponse()
    {
        FeatureGroups = new List<AdisyoFeatureGroupDetail>();
    }
    [JsonPropertyName("featureGroups")]
    public List<AdisyoFeatureGroupDetail>? FeatureGroups { get; set; } = new();
}

public class AdisyoFeatureGroupDetail
{
    public AdisyoFeatureGroupDetail()
    {
        Features = new List<AdisyoFeatureDetail>();
    }
    [JsonPropertyName("featureGroupId")]
    public int? FeatureGroupId { get; set; }
    
    [JsonPropertyName("featuresGroupName")]
    public string? FeaturesGroupName { get; set; }
    
    [JsonPropertyName("necessaryCount")]
    public int? NecessaryCount { get; set; }
    
    [JsonPropertyName("featureHeaderType")]
    public string? FeatureHeaderType { get; set; } // "Tekli Seçim" or "Çoklu Seçim"
    
    [JsonPropertyName("features")]
    public List<AdisyoFeatureDetail>? Features { get; set; } = new();
}

public class AdisyoFeatureDetail
{
    public AdisyoFeatureDetail()
    {
        RelatedProducts = new List<AdisyoRelatedProduct>();
    }
    [JsonPropertyName("featureName")]
    public string? FeatureName { get; set; }
    
    [JsonPropertyName("featureId")]
    public int? FeatureId { get; set; }
    
    [JsonPropertyName("relatedProducts")]
    public List<AdisyoRelatedProduct>? RelatedProducts { get; set; } = new();
}

public class CompletedOrderRequestResponse
{
    [JsonPropertyName("orders")]
    public List<AdisyoOrderInfo>? Orders { get; set; }

    [JsonPropertyName("closedOrdersReceived")]
    public int? ClosedOrdersReceived { get; set; }

    [JsonPropertyName("canceledOrdersReceived")]
    public int? CanceledOrdersReceived { get; set; }

    [JsonPropertyName("totalCount")]
    public int? TotalCount { get; set; }

    [JsonPropertyName("pageCount")]
    public int? PageCount { get; set; }

    [JsonPropertyName("status")]
    public int? Status { get; set; }

    [JsonPropertyName("message")]
    public string? Message { get; set; }
}

#endregion
