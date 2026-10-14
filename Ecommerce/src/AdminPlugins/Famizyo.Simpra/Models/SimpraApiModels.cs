using System.Globalization;
using System.Text.Json.Serialization;

namespace Famizyo.Simpra.Models;

// Base response model (Note: Simpra API doesn't use this wrapper, keeping for compatibility)
public class SimpraBaseResponse<T>
{
    [JsonPropertyName("data")]
    public T? Data { get; set; }
    public bool Success { get; set; }
    public string? Message { get; set; }
}

// Meta pagination info used by most Simpra endpoints
public class SimpraMeta
{
    [JsonPropertyName("total_count")]
    public int TotalCount { get; set; }
    
    [JsonPropertyName("current_page")]
    public int CurrentPage { get; set; }
    
    [JsonPropertyName("per_page_count")]
    public int PerPageCount { get; set; }
    
    [JsonPropertyName("total_page")]
    public int TotalPage { get; set; }
    
    [JsonPropertyName("has_next_page")]
    public bool HasNextPage { get; set; }
}

// Translation model used by many entities
public class SimpraTranslation
{
    [JsonPropertyName("name")]
    public string Name { get; set; }
    
    [JsonPropertyName("locale")]
    public string Locale { get; set; }
}
public class SimpraTranslationRequest
{
    [JsonPropertyName("text")]
    public string Text { get; set; }
    
    [JsonPropertyName("locale")]
    public string Locale { get; set; }
}

// Order Status Update Message for Redis
public class SimpraOrderStatusUpdate
{
    [JsonPropertyName("tenant")]
    public TenantInfo Tenant { get; set; }
    
    [JsonPropertyName("orderId")]
    public string OrderId { get; set; }
    
    [JsonPropertyName("newStatus")]
    public string NewStatus { get; set; }
    
    [JsonPropertyName("deliveryStatus")]
    public string DeliveryStatus { get; set; }
    
    [JsonPropertyName("timestamp")]
    public DateTime Timestamp { get; set; }
    
    [JsonPropertyName("source")]
    public string Source { get; set; } = "simpra";
}

public class TenantInfo
{
    [JsonPropertyName("storeId")]
    public string StoreId { get; set; }
}

// Revenue Centers Response
public class SimpraRevenueCentersResponse
{
    [JsonPropertyName("meta")]
    public SimpraMeta Meta { get; set; }
    
    [JsonPropertyName("revenue_centers")]
    public List<SimpraRevenueCenter> RevenueCenters { get; set; }
}

// Revenue Center
public class SimpraRevenueCenter
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("active")]
    public bool Active { get; set; }
    
    [JsonPropertyName("type")]
    public string Type { get; set; }
    
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
    
    [JsonPropertyName("metafields")]
    public List<object> Metafields { get; set; }
    
    [JsonPropertyName("translations")]
    public List<SimpraTranslation> Translations { get; set; }
    
    [JsonPropertyName("property_id")]
    public string PropertyId { get; set; }
    
    [JsonPropertyName("sales_channel_id")]
    public string SalesChannelId { get; set; }
    
    // Helper property to get name in default locale
    public string Name => Translations?.FirstOrDefault(t => t.Locale == "tr")?.Name ?? 
                         Translations?.FirstOrDefault()?.Name ?? 
                         "Unknown";
}

// Sales Channels Response
public class SimpraSalesChannelsResponse
{
    [JsonPropertyName("meta")]
    public SimpraMeta Meta { get; set; }
    
    [JsonPropertyName("sales_channels")]
    public List<SimpraSalesChannel> SalesChannels { get; set; }
}

// Sales Channel
public class SimpraSalesChannel
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("type")]
    public string Type { get; set; }
    
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
    
    [JsonPropertyName("property_id")]
    public string PropertyId { get; set; }
    
    [JsonPropertyName("name")]
    public string Name { get; set; }
}

// Employees Response
public class SimpraEmployeesResponse
{
    [JsonPropertyName("meta")]
    public SimpraMeta Meta { get; set; }
    
    [JsonPropertyName("employees")]
    public List<SimpraEmployee> Employees { get; set; }
}

// Employee
public class SimpraEmployee
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("first_name")]
    public string FirstName { get; set; }
    
    [JsonPropertyName("last_name")]
    public string LastName { get; set; }
    
    [JsonPropertyName("phone_number")]
    public string? PhoneNumber { get; set; }
    
    [JsonPropertyName("registration_no")]
    public string? RegistrationNo { get; set; }
    
    [JsonPropertyName("property_id")]
    public string PropertyId { get; set; }
    
    [JsonPropertyName("metafields")]
    public List<object> Metafields { get; set; }
    
    // Helper property to get full name
    public string Name => $"{FirstName} {LastName}".Trim();
}

// Payment Types Response
public class SimpraPaymentTypesResponse
{
    [JsonPropertyName("meta")]
    public SimpraMeta Meta { get; set; }
    
    [JsonPropertyName("payment_types")]
    public List<SimpraPaymentType> PaymentTypes { get; set; }
}

// Payment Type
public class SimpraPaymentType
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("active")]
    public bool Active { get; set; }
    
    [JsonPropertyName("type")]
    public string Type { get; set; }
    
    [JsonPropertyName("payment_group")]
    public string PaymentGroup { get; set; }
    
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
    
    [JsonPropertyName("property_id")]
    public string PropertyId { get; set; }
    
    [JsonPropertyName("metafields")]
    public List<object> Metafields { get; set; }
    
    [JsonPropertyName("translations")]
    public List<SimpraTranslation> Translations { get; set; }
    
    // Helper property to get name in default locale
    public string Name => Translations?.FirstOrDefault(t => t.Locale == "tr")?.Name ?? 
                         Translations?.FirstOrDefault()?.Name ?? 
                         "Unknown";
}

// Menu Item Groups Response
public class SimpraMenuItemGroupsResponse
{
    [JsonPropertyName("menu_item_groups")]
    public List<SimpraMenuItemGroup> MenuItemGroups { get; set; }
}

// Menu Item Groups (Categories)
public class SimpraMenuItemGroup
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("active")]
    public bool Active { get; set; }
    
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
    
    [JsonPropertyName("parent_mig_id")]
    public string? ParentMigId { get; set; }
    
    [JsonPropertyName("translations")]
    public List<SimpraTranslation> Translations { get; set; }
    
    // Helper property to get name in default locale
    public string Name => Translations?.FirstOrDefault(t => t.Locale == "tr")?.Name ?? 
                         Translations?.FirstOrDefault()?.Name ?? 
                         "Unknown";
}

// Menu Items API Models - v2 endpoint response
public class SimpraMenuItemsResponse
{
    [JsonPropertyName("meta")]
    public SimpraMeta Meta { get; set; }
    
    [JsonPropertyName("menu_items")]
    public List<SimpraMenuItemResponse> MenuItems { get; set; }
}

public class SimpraMenuItemRequest
{
    [JsonPropertyName("property_ids")]
    public List<string> PropertyIds { get; set; }

    [JsonPropertyName("name")]
    public string Name { get; set; }

    [JsonPropertyName("price")]
    public double Price { get; set; }

    [JsonPropertyName("tax_id")]
    public string TaxId { get; set; }

    [JsonPropertyName("menu_item_group_id")]
    public string MenuItemGroupId { get; set; }

    [JsonPropertyName("barcodes")]
    public List<string> Barcodes { get; set; }

    [JsonPropertyName("quantity")]
    public int Quantity { get; set; }

    [JsonPropertyName("receipe_menu_item")]
    public bool ReceipeMenuItem { get; set; }

    [JsonPropertyName("translations")]
    public List<SimpraTranslationRequest> Translations { get; set; }

    [JsonPropertyName("report_tag_ids")]
    public List<string> ReportTagIds { get; set; }
}

public class SimpraMenuItemCrudResponse
{
    [JsonPropertyName("menu_item")]
    public MenuItemCrudId MenuItem { get; set; }

    [JsonPropertyName("errors")]
    public List<MenuItemCrudErrors> Errors { get; set; }
}

public class MenuItemCrudId
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
}

public class MenuItemCrudErrors
{
    [JsonPropertyName("message")]
    public string Message { get; set; }
}
public class SimpraMenuItemResponse
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("sku")]
    public string? Sku { get; set; }
    
    [JsonPropertyName("active")]
    public bool Active { get; set; }
    
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
    
    [JsonPropertyName("receipe_menu_item")]
    public bool ReceipeMenuItem { get; set; }
    
    [JsonPropertyName("unit_type")]
    public string UnitType { get; set; }
    
    [JsonPropertyName("barcodes")]
    public List<string> Barcodes { get; set; }
    
    [JsonPropertyName("menu_item_group_id")]
    public string MenuItemGroupId { get; set; }
    
    [JsonPropertyName("translations")]
    public List<SimpraTranslation> Translations { get; set; }
    
    [JsonPropertyName("metafields")]
    public List<SimpraMetafield>? Metafields { get; set; }
    
    [JsonPropertyName("condiment_groups")]
    public List<SimpraMenuItemCondimentGroup>? CondimentGroups { get; set; }
    
    [JsonPropertyName("item_image")]
    public SimpraMenuItemImage? ItemImage { get; set; }
    
    // Helper property to get name in default locale
    public string Name => Translations?.FirstOrDefault(t => t.Locale == "tr")?.Name ?? 
                         Translations?.FirstOrDefault()?.Name ?? 
                         "Unknown";
}

// Metafield for menu items
public class SimpraMetafield
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("key")]
    public string Key { get; set; }
    
    [JsonPropertyName("value")]
    public object Value { get; set; }
    
    [JsonPropertyName("value_type")]
    public string ValueType { get; set; }
    
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
}

// Menu Item Condiment Group (different structure from standalone condiment groups)
public class SimpraMenuItemCondimentGroup
{
    [JsonPropertyName("required")]
    public bool Required { get; set; }
    
    [JsonPropertyName("min_count")]
    public int? MinCount { get; set; }
    
    [JsonPropertyName("max_count")]
    public int? MaxCount { get; set; }
    
    [JsonPropertyName("multiple")]
    public bool Multiple { get; set; }
    
    [JsonPropertyName("condiment_group_id")]
    public string CondimentGroupId { get; set; }
    
    [JsonPropertyName("menu_item_condiment_group_mapping_id")]
    public string MenuItemCondimentGroupMappingId { get; set; }
    
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
    
    [JsonPropertyName("translations")]
    public List<SimpraTranslation> Translations { get; set; }
    
    // Helper property to get name in default locale
    public string Name => Translations?.FirstOrDefault(t => t.Locale == "tr")?.Name ?? 
                         Translations?.FirstOrDefault()?.Name ?? 
                         "Unknown";
}

// Menu Item Image
public class SimpraMenuItemImage
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("name")]
    public string Name { get; set; }
    
    [JsonPropertyName("raw_url_path")]
    public string? RawUrlPath { get; set; }
    
    [JsonPropertyName("small_image_url")]
    public string? SmallImageUrl { get; set; }
    
    [JsonPropertyName("thumbnail_image_url")]
    public string? ThumbnailImageUrl { get; set; }
    
    [JsonPropertyName("medium_image_url")]
    public string? MediumImageUrl { get; set; }
    
    [JsonPropertyName("large_image_url")]
    public string? LargeImageUrl { get; set; }
}

// Item Definitions API Models
public class SimpraItemDefinitionsResponse
{
    [JsonPropertyName("meta")]
    public SimpraMeta Meta { get; set; }
    
    [JsonPropertyName("item_definitions")]
    public List<SimpraItemDefinition> ItemDefinitions { get; set; }
}

public class SimpraItemDefinition
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("price")]
    public string Price { get; set; }
    
    [JsonPropertyName("active")]
    public bool Active { get; set; }
    
    [JsonPropertyName("is_size_option")]
    public bool IsSizeOption { get; set; }
    
    [JsonPropertyName("target_id")]
    public string TargetId { get; set; }
    
    [JsonPropertyName("source_id")]
    public string SourceId { get; set; }
    
    [JsonPropertyName("property_id")]
    public string PropertyId { get; set; }
    
    [JsonPropertyName("tax_id")]
    public string TaxId { get; set; }
    
    [JsonPropertyName("price_list_id")]
    public string PriceListId { get; set; }
    
    [JsonPropertyName("source_type")]
    public string SourceType { get; set; }
    
    [JsonPropertyName("target_type")]
    public string TargetType { get; set; }
    
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
    
    [JsonPropertyName("order")]
    public int? Order { get; set; }
    
    [JsonPropertyName("translations")]
    public List<SimpraTranslation> Translations { get; set; }
    
    // Helper property to get name in default locale
    public string Name => Translations?.FirstOrDefault(t => t.Locale == "tr")?.Name ?? 
                         Translations?.FirstOrDefault()?.Name ?? 
                         "Unknown";
    
    // Helper property to get decimal price
    public decimal PriceDecimal
    {
        get
        {
            if (decimal.TryParse(Price,CultureInfo.InvariantCulture,  out var price))
                return price;
            return 0;
        }
    }
}

// Condiment Groups (Product Attributes) - Response from /condiment_groups endpoint
public class SimpraCondimentGroupsResponse
{
    [JsonPropertyName("meta")]
    public SimpraMeta Meta { get; set; }
    
    [JsonPropertyName("condiment_groups")]
    public List<SimpraCondimentGroup> CondimentGroups { get; set; } = new();
}

public class SimpraCondimentGroup
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("multiple")]
    public bool Multiple { get; set; }
    
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
    
    [JsonPropertyName("translations")]
    public List<SimpraTranslation> Translations { get; set; } = new();
    
    /// <summary>
    /// Helper property to get the name in current locale (defaults to first available name)
    /// </summary>
    public string Name => Translations?.FirstOrDefault(t => t.Locale == "tr")?.Name ?? 
                         Translations?.FirstOrDefault()?.Name ?? 
                         string.Empty;
}

// Check (Order) API Models
public class SimpraCheckRequest
{
    /// <summary>
    /// Menu items - contains order items (REQUIRED)
    /// </summary>
    [JsonPropertyName("menu_items")]
    public List<SimpraMenuItem> MenuItems { get; set; } = new List<SimpraMenuItem>();
    
    /// <summary>
    /// Discounts on check
    /// </summary>
    [JsonPropertyName("discounts")]
    public List<SimpraDiscount>? Discounts { get; set; }
    
    /// <summary>
    /// Creates check on table
    /// </summary>
    [JsonPropertyName("table_id")]
    public string? TableId { get; set; }
    
    /// <summary>
    /// Creates check on revenue_center
    /// </summary>
    [JsonPropertyName("revenue_center_id")]
    public string? RevenueCenterId { get; set; }
    
    /// <summary>
    /// Creates check on sales_channel
    /// </summary>
    [JsonPropertyName("sales_channel_id")]
    public string? SalesChannelId { get; set; }
    
    /// <summary>
    /// Add note to check
    /// </summary>
    [JsonPropertyName("note")]
    public string? Note { get; set; }
    
    /// <summary>
    /// Check name
    /// </summary>
    [JsonPropertyName("alias_name")]
    public string? AliasName { get; set; }
    
    /// <summary>
    /// Female cover on check
    /// </summary>
    [JsonPropertyName("female_cover")]
    public int? FemaleCover { get; set; }
    
    /// <summary>
    /// Male cover on check
    /// </summary>
    [JsonPropertyName("male_cover")]
    public int? MaleCover { get; set; }
    
    /// <summary>
    /// Child cover on check
    /// </summary>
    [JsonPropertyName("child_cover")]
    public int? ChildCover { get; set; }
    
    /// <summary>
    /// Add customer to check
    /// </summary>
    [JsonPropertyName("customer")]
    public SimpraCustomerRequest? Customer { get; set; }
    
    /// <summary>
    /// Delivery information for takeaway
    /// </summary>
    [JsonPropertyName("delivery")]
    public SimpraDeliveryRequest? Delivery { get; set; }
    
    /// <summary>
    /// Check custom attributes
    /// </summary>
    [JsonPropertyName("extras")]
    public List<SimpraCheckExtra>? Extras { get; set; }
}

public class SimpraCrudCheckInfo
{
    public string id { get; set; }
    public int sequence { get; set; }
}

public class SimpraCrudCheckResponse
{
    public SimpraCrudCheckInfo check { get; set; }
}

// Check Response Models for Get Checks endpoint
public class SimpraChecksResponse
{
    [JsonPropertyName("meta")]
    public SimpraMeta Meta { get; set; }
    
    [JsonPropertyName("checks")]
    public List<SimpraCheckResponse> Checks { get; set; }
}

public class SimpraCheckResponse
{
    [JsonPropertyName("alias")]
    public string? Alias { get; set; }
    
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("created_at")]
    public long CreatedAt { get; set; }
    
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
    
    [JsonPropertyName("closed_at")]
    public long? ClosedAt { get; set; }
    
    [JsonPropertyName("business_date")]
    public string BusinessDate { get; set; }
    
    [JsonPropertyName("female_cover")]
    public int FemaleCover { get; set; }
    
    [JsonPropertyName("male_cover")]
    public int MaleCover { get; set; }
    
    [JsonPropertyName("child_cover")]
    public int ChildCover { get; set; }
    
    [JsonPropertyName("note")]
    public string? Note { get; set; }
    
    [JsonPropertyName("sequence")]
    public int Sequence { get; set; }
    
    [JsonPropertyName("status")]
    public string Status { get; set; }
    
    [JsonPropertyName("delivery_status")]
    public string? DeliveryStatus { get; set; }
    
    [JsonPropertyName("sequential_id")]
    public int SequentialId { get; set; }
    
    [JsonPropertyName("property_id")]
    public string PropertyId { get; set; }
    
    [JsonPropertyName("revenue_center")]
    public SimpraRevenueCenterInfo RevenueCenter { get; set; }
    
    [JsonPropertyName("shift_id")]
    public string ShiftId { get; set; }
    
    [JsonPropertyName("employee")]
    public SimpraEmployeeInfo Employee { get; set; }
    
    [JsonPropertyName("table")]
    public SimpraTableInfo? Table { get; set; }
    
    [JsonPropertyName("sales_channel")]
    public SimpraSalesChannelInfo SalesChannel { get; set; }
    
    [JsonPropertyName("customer")]
    public SimpraCustomerInfo? Customer { get; set; }
    
    [JsonPropertyName("delivery")]
    public SimpraDeliveryInfo? Delivery { get; set; }
    
    [JsonPropertyName("extras")]
    public Dictionary<string, object>? Extras { get; set; }
    
    [JsonPropertyName("check_service_charge")]
    public SimpraCheckServiceCharge? CheckServiceCharge { get; set; }
    
    [JsonPropertyName("summary")]
    public SimpraCheckSummary Summary { get; set; }
    
    [JsonPropertyName("check_discounts")]
    public List<SimpraCheckDiscount> CheckDiscounts { get; set; }
    
    [JsonPropertyName("check_payments")]
    public List<SimpraCheckPayment> CheckPayments { get; set; }
    
    [JsonPropertyName("check_items")]
    public List<SimpraCheckItem> CheckItems { get; set; }
    
    [JsonPropertyName("check_offers")]
    public List<SimpraCheckOffer> CheckOffers { get; set; }
}

public class SimpraRevenueCenterInfo
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("name")]
    public string Name { get; set; }
}

public class SimpraEmployeeInfo
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("first_name")]
    public string FirstName { get; set; }
    
    [JsonPropertyName("last_name")]
    public string LastName { get; set; }
    
    [JsonPropertyName("phone_number")]
    public string? PhoneNumber { get; set; }
}

public class SimpraTableInfo
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("name")]
    public string Name { get; set; }
}

public class SimpraSalesChannelInfo
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("name")]
    public string Name { get; set; }
}

public class SimpraCustomerInfo
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("first_name")]
    public string FirstName { get; set; }
    
    [JsonPropertyName("last_name")]
    public string LastName { get; set; }
    
    [JsonPropertyName("email")]
    public string? Email { get; set; }
    
    [JsonPropertyName("phone_number")]
    public string? PhoneNumber { get; set; }
}

public class SimpraDeliveryInfo
{
    [JsonPropertyName("address")]
    public string Address { get; set; }
    
    [JsonPropertyName("address_id")]
    public string? AddressId { get; set; }
    
    [JsonPropertyName("recipient")]
    public string? Recipient { get; set; }
    
    [JsonPropertyName("payment_names")]
    public string? PaymentNames { get; set; }
}

public class SimpraCheckServiceCharge
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("service_charge_id")]
    public string ServiceChargeId { get; set; }
    
    [JsonPropertyName("business_date")]
    public string BusinessDate { get; set; }
    
    [JsonPropertyName("amount")]
    public string Amount { get; set; }
    
    [JsonPropertyName("tax")]
    public SimpraTaxInfo Tax { get; set; }
}

public class SimpraTaxInfo
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("rate")]
    public double Rate { get; set; }
    
    [JsonPropertyName("name")]
    public string Name { get; set; }
}

public class SimpraCheckSummary
{
    [JsonPropertyName("original_items_amount")]
    public string OriginalItemsAmount { get; set; }
    
    [JsonPropertyName("original_taxes_amount")]
    public string OriginalTaxesAmount { get; set; }
    
    [JsonPropertyName("complimentaries_amount")]
    public string ComplimentariesAmount { get; set; }
    
    [JsonPropertyName("discounts_amount")]
    public string DiscountsAmount { get; set; }
    
    [JsonPropertyName("taxes_amount")]
    public string TaxesAmount { get; set; }
    
    [JsonPropertyName("service_charge_amount")]
    public string ServiceChargeAmount { get; set; }
    
    [JsonPropertyName("paid_amount")]
    public string PaidAmount { get; set; }
    
    [JsonPropertyName("unpaid_amount")]
    public string UnpaidAmount { get; set; }
    
    [JsonPropertyName("paid_service_charge_amount")]
    public string PaidServiceChargeAmount { get; set; }
    
    [JsonPropertyName("total_amount")]
    public string TotalAmount { get; set; }
    
    [JsonPropertyName("base_amount")]
    public string BaseAmount { get; set; }
    
    [JsonPropertyName("offer_amount")]
    public string OfferAmount { get; set; }
}

public class SimpraCheckDiscount
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("business_date")]
    public string BusinessDate { get; set; }
    
    [JsonPropertyName("source")]
    public string Source { get; set; }
    
    [JsonPropertyName("value")]
    public string Value { get; set; }
    
    [JsonPropertyName("discount_amount")]
    public string DiscountAmount { get; set; }
    
    [JsonPropertyName("discount_id")]
    public string DiscountId { get; set; }
    
    [JsonPropertyName("name")]
    public string Name { get; set; }
    
    [JsonPropertyName("type")]
    public string Type { get; set; }
    
    [JsonPropertyName("annotation")]
    public string? Annotation { get; set; }
}

public class SimpraCheckPayment
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("business_date")]
    public string BusinessDate { get; set; }
    
    [JsonPropertyName("payment_type_id")]
    public string PaymentTypeId { get; set; }
    
    [JsonPropertyName("paid_amount")]
    public string PaidAmount { get; set; }
    
    [JsonPropertyName("device")]
    public SimpraDeviceInfo? Device { get; set; }
    
    [JsonPropertyName("extras")]
    public Dictionary<string, object>? Extras { get; set; }
}

public class SimpraDeviceInfo
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("name")]
    public string Name { get; set; }
}

public class SimpraCheckOffer
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("offer_id")]
    public string OfferId { get; set; }
    
    [JsonPropertyName("name")]
    public string Name { get; set; }
    
    [JsonPropertyName("value")]
    public string Value { get; set; }
}

public class SimpraCheckItem
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("parent_check_item_id")]
    public string? ParentCheckItemId { get; set; }
    
    [JsonPropertyName("reason_id")]
    public string? ReasonId { get; set; }
    
    [JsonPropertyName("business_date")]
    public string BusinessDate { get; set; }
    
    [JsonPropertyName("status")]
    public string Status { get; set; }
    
    [JsonPropertyName("payment_status")]
    public string PaymentStatus { get; set; }
    
    [JsonPropertyName("complimentary")]
    public bool Complimentary { get; set; }
    
    [JsonPropertyName("unit_type")]
    public string UnitType { get; set; }
    
    [JsonPropertyName("quantity")]
    public string Quantity { get; set; }
    
    [JsonPropertyName("notes")]
    public List<string>? Notes { get; set; }
    
    [JsonPropertyName("is_combo")]
    public bool IsCombo { get; set; }
    
    [JsonPropertyName("summary")]
    public SimpraCheckItemSummary Summary { get; set; }
    
    [JsonPropertyName("tax")]
    public SimpraTaxInfo Tax { get; set; }
    
    [JsonPropertyName("item")]
    public SimpraItemInfo Item { get; set; }
}

public class SimpraCheckItemSummary
{
    [JsonPropertyName("discount_amount")]
    public string DiscountAmount { get; set; }
    
    [JsonPropertyName("tax_amount")]
    public string TaxAmount { get; set; }
    
    [JsonPropertyName("total_amount")]
    public string TotalAmount { get; set; }
    
    [JsonPropertyName("original_amount")]
    public string OriginalAmount { get; set; }
    
    [JsonPropertyName("original_tax_amount")]
    public string OriginalTaxAmount { get; set; }
}

public class SimpraItemInfo
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("name")]
    public string Name { get; set; }
    
    [JsonPropertyName("type")]
    public string Type { get; set; }
    
    [JsonPropertyName("source_id")]
    public string? SourceId { get; set; }
}

public class SimpraCondimentSelection
{
    [JsonPropertyName("condiment_id")]
    public string CondimentId { get; set; }
    
    [JsonPropertyName("quantity")]
    public int Quantity { get; set; }
    
    [JsonPropertyName("notes")]
    public string? Notes { get; set; }
}

public class SimpraCustomer
{
    [JsonPropertyName("name")]
    public string Name { get; set; }
    
    [JsonPropertyName("phone")]
    public string Phone { get; set; }
    
    [JsonPropertyName("email")]
    public string? Email { get; set; }
}

public class SimpraDeliveryAddress
{
    [JsonPropertyName("address_line")]
    public string AddressLine { get; set; }
    
    [JsonPropertyName("city")]
    public string City { get; set; }
    
    [JsonPropertyName("district")]
    public string? District { get; set; }
    
    [JsonPropertyName("postal_code")]
    public string? PostalCode { get; set; }
}

// Payment API Models
public class SimpraCheckPaymentRequest
{
    [JsonPropertyName("payment_id")]
    public string PaymentTypeId { get; set; }
    
    [JsonPropertyName("amount")]
    public decimal Amount { get; set; }
}

// Delivery Status Update
public class SimpraDeliveryStatusRequest
{
    [JsonPropertyName("delivery_status")]
    public string DeliveryStatus { get; set; }
}

// Check Item Cancel
public class SimpraCheckItemCancelRequest
{
    [JsonPropertyName("cancel_reason")]
    public string? CancelReason { get; set; }
}

// New API Models for SimpraCheckRequest

/// <summary>
/// Menu item for check request
/// </summary>
public class SimpraMenuItem
{
    /// <summary>
    /// Ordered menu item id (REQUIRED)
    /// </summary>
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    /// <summary>
    /// Ordered menu item quantity (default: 1)
    /// </summary>
    [JsonPropertyName("quantity")]
    public int Quantity { get; set; } = 1;
    
    /// <summary>
    /// Ordered menu item name for custom menu item
    /// </summary>
    [JsonPropertyName("name")]
    public string? Name { get; set; }
    
    /// <summary>
    /// Ordered menu item amount for custom menu item
    /// </summary>
    [JsonPropertyName("unit_amount")]
    public decimal? UnitAmount { get; set; }
    
    /// <summary>
    /// Ordered item notes
    /// </summary>
    [JsonPropertyName("notes")]
    public List<string>? Notes { get; set; }
    
    /// <summary>
    /// Ordered condiments
    /// </summary>
    [JsonPropertyName("condiments")]
    public List<SimpraOrderCondiment>? Condiments { get; set; }
    
    /// <summary>
    /// Ordered combo items
    /// </summary>
    [JsonPropertyName("combo_items")]
    public List<SimpraComboItem>? ComboItems { get; set; }
}

/// <summary>
/// Condiment in order
/// </summary>
public class SimpraOrderCondiment
{
    /// <summary>
    /// Condiment id (REQUIRED)
    /// </summary>
    [JsonPropertyName("id")]
    public string Id { get; set; }
}

/// <summary>
/// Combo item in order
/// </summary>
public class SimpraComboItem
{
    /// <summary>
    /// Menu item id (REQUIRED)
    /// </summary>
    [JsonPropertyName("id")]
    public int Id { get; set; }
    
    /// <summary>
    /// Combo group item id (REQUIRED)
    /// </summary>
    [JsonPropertyName("combo_group_item_id")]
    public int ComboGroupItemId { get; set; }
}

/// <summary>
/// Discount on check
/// </summary>
public class SimpraDiscount
{
    /// <summary>
    /// Discount amount (REQUIRED)
    /// </summary>
    [JsonPropertyName("amount")]
    public decimal Amount { get; set; }
}

/// <summary>
/// Customer for check request
/// </summary>
public class SimpraCustomerRequest
{
    /// <summary>
    /// Customer phone number (REQUIRED)
    /// </summary>
    [JsonPropertyName("phone_number")]
    public string PhoneNumber { get; set; }
    
    /// <summary>
    /// Customer first name
    /// </summary>
    [JsonPropertyName("first_name")]
    public string? FirstName { get; set; }
    
    /// <summary>
    /// Customer last name
    /// </summary>
    [JsonPropertyName("last_name")]
    public string? LastName { get; set; }
    
    /// <summary>
    /// Customer email
    /// </summary>
    [JsonPropertyName("email")]
    public string? Email { get; set; }
    
    /// <summary>
    /// Gender info (female or male)
    /// </summary>
    [JsonPropertyName("gender")]
    public string? Gender { get; set; }
}

/// <summary>
/// Delivery information for takeaway
/// </summary>
public class SimpraDeliveryRequest
{
    /// <summary>
    /// Delivery address (REQUIRED)
    /// </summary>
    [JsonPropertyName("address")]
    public string Address { get; set; }
    
    /// <summary>
    /// Delivery note
    /// </summary>
    [JsonPropertyName("note")]
    public string? Note { get; set; }
}

/// <summary>
/// Check custom attribute
/// </summary>
public class SimpraCheckExtra
{
    /// <summary>
    /// Check custom attribute key
    /// </summary>
    [JsonPropertyName("key")]
    public string Key { get; set; }
    
    /// <summary>
    /// Check custom attribute value
    /// </summary>
    [JsonPropertyName("value")]
    public string Value { get; set; }
}

// =============================================================================
// TAX MODELS
// =============================================================================

/// <summary>
/// Simpra tax categories response from /taxes endpoint
/// </summary>
public class SimpraTaxesResponse
{
    [JsonPropertyName("taxes")]
    public List<SimpraTax> Taxes { get; set; } = new();
}

/// <summary>
/// Simpra tax category model
/// </summary>
public class SimpraTax
{
    /// <summary>
    /// Tax category ID
    /// </summary>
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    /// <summary>
    /// Tax rate (percentage)
    /// </summary>
    [JsonPropertyName("rate")]
    public decimal Rate { get; set; }
    
    /// <summary>
    /// Whether the tax is active
    /// </summary>
    [JsonPropertyName("active")]
    public bool Active { get; set; }
    
    /// <summary>
    /// Last update timestamp
    /// </summary>
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
    
    /// <summary>
    /// Tax category name translations
    /// </summary>
    [JsonPropertyName("translations")]
    public List<SimpraTranslation> Translations { get; set; } = new();
    
    /// <summary>
    /// Helper property to get the name in current locale (defaults to first available name)
    /// </summary>
    public string Name => Translations?.FirstOrDefault(t => t.Locale == "tr")?.Name ?? 
                          Translations?.FirstOrDefault()?.Name ?? 
                          $"Tax {Rate}%";
}

// =============================================================================
// CONDIMENT MODELS
// =============================================================================

/// <summary>
/// Simpra condiments response from /condiments endpoint
/// </summary>
public class SimpraCondimentsResponse
{
    [JsonPropertyName("condiments")]
    public List<SimpraCondiment> Condiments { get; set; } = new();
}

/// <summary>
/// Simpra condiment model
/// </summary>
public class SimpraCondiment
{
    /// <summary>
    /// Condiment ID
    /// </summary>
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    /// <summary>
    /// Whether the condiment is active
    /// </summary>
    [JsonPropertyName("active")]
    public bool Active { get; set; }
    
    /// <summary>
    /// Last update timestamp
    /// </summary>
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
    
    /// <summary>
    /// Condiment group ID this condiment belongs to
    /// </summary>
    [JsonPropertyName("condiment_group_id")]
    public string CondimentGroupId { get; set; }
    
    /// <summary>
    /// Condiment name translations
    /// </summary>
    [JsonPropertyName("translations")]
    public List<SimpraTranslation> Translations { get; set; } = new();
    
    /// <summary>
    /// Item definitions for pricing
    /// </summary>
    [JsonPropertyName("item_definitions")]
    public List<SimpraItemDefinition> ItemDefinitions { get; set; } = new();
    
    /// <summary>
    /// Metafields for additional data
    /// </summary>
    [JsonPropertyName("metafields")]
    public List<object> Metafields { get; set; } = new();
    
    /// <summary>
    /// Report tags
    /// </summary>
    [JsonPropertyName("report_tags")]
    public List<object> ReportTags { get; set; } = new();
    
    /// <summary>
    /// Helper property to get the name in current locale (defaults to first available name)
    /// </summary>
    public string Name => Translations?.FirstOrDefault(t => t.Locale == "tr")?.Name ?? 
                          Translations?.FirstOrDefault()?.Name ?? string.Empty;
}

// =============================================================================
// SERVICE CHARGES MODELS
// =============================================================================

/// <summary>
/// Simpra service charges response from /service_charges endpoint
/// </summary>
public class SimpraServiceChargesResponse
{
    [JsonPropertyName("service_charges")]
    public List<SimpraServiceCharge> ServiceCharges { get; set; } = new();
}

/// <summary>
/// Simpra service charge model
/// </summary>
public class SimpraServiceCharge
{
    /// <summary>
    /// Service charge ID
    /// </summary>
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    /// <summary>
    /// Whether the service charge is fixed or percentage
    /// </summary>
    [JsonPropertyName("is_fixed")]
    public bool IsFixed { get; set; }
    
    /// <summary>
    /// Whether this is the default service charge
    /// </summary>
    [JsonPropertyName("default")]
    public bool Default { get; set; }
    
    /// <summary>
    /// Tax ID associated with this service charge
    /// </summary>
    [JsonPropertyName("tax_id")]
    public string TaxId { get; set; }
    
    /// <summary>
    /// Service charge value (amount if fixed, percentage if not fixed)
    /// </summary>
    [JsonPropertyName("value")]
    public string Value { get; set; }
    
    /// <summary>
    /// Service charge type (e.g., "percentage", "fixed")
    /// </summary>
    [JsonPropertyName("type")]
    public string Type { get; set; }
    
    /// <summary>
    /// Metafields for additional data
    /// </summary>
    [JsonPropertyName("metafields")]
    public List<SimpraServiceChargeMetafield> Metafields { get; set; } = new();
    
    /// <summary>
    /// Service charge name translations
    /// </summary>
    [JsonPropertyName("translations")]
    public List<SimpraTranslation> Translations { get; set; } = new();
    
    /// <summary>
    /// Helper property to get the name in current locale (defaults to first available name)
    /// </summary>
    public string Name => Translations?.FirstOrDefault(t => t.Locale == "tr")?.Name ?? 
                          Translations?.FirstOrDefault()?.Name ?? 
                          $"Service Charge {Value}";
    
    /// <summary>
    /// Helper property to get decimal value
    /// </summary>
    public decimal ValueDecimal
    {
        get
        {
            if (decimal.TryParse(Value, System.Globalization.CultureInfo.InvariantCulture, out var value))
                return value;
            return 0;
        }
    }
}

/// <summary>
/// Service charge metafield
/// </summary>
public class SimpraServiceChargeMetafield
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    
    [JsonPropertyName("key")]
    public string Key { get; set; }
    
    [JsonPropertyName("value")]
    public object Value { get; set; }
    
    [JsonPropertyName("value_type")]
    public string ValueType { get; set; }
    
    [JsonPropertyName("updated_at")]
    public long UpdatedAt { get; set; }
}

/// <summary>
/// Request model for creating service charge on a check
/// </summary>
public class SimpraCheckServiceChargeRequest
{
    /// <summary>
    /// Service charge ID from /service_charges endpoint (REQUIRED)
    /// </summary>
    [JsonPropertyName("service_charge_id")]
    public string ServiceChargeId { get; set; }
    
    /// <summary>
    /// Service charge amount (REQUIRED)
    /// </summary>
    [JsonPropertyName("amount")]
    public decimal Amount { get; set; }
}

/// <summary>
/// Response model for creating service charge on a check
/// </summary>
public class SimpraCheckServiceChargeResponse
{
    /// <summary>
    /// Created check service charge ID
    /// </summary>
    [JsonPropertyName("check_service_charge_id")]
    public string CheckServiceChargeId { get; set; }
}