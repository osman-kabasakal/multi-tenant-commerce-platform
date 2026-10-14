namespace Grand.Business.Core.Utilities.Checkout;

/// <summary>
/// Represents free shipping information from a shipping provider
/// </summary>
public class FreeShippingInfo
{
    /// <summary>
    /// Indicates whether free shipping is available for this provider
    /// </summary>
    public bool IsFreeShippingAvailable { get; set; }

    /// <summary>
    /// The minimum order amount required for free shipping (if applicable)
    /// </summary>
    public double? MinimumOrderAmountForFreeShipping { get; set; }

    /// <summary>
    /// Description of the free shipping conditions
    /// </summary>
    public string FreeShippingConditionDescription { get; set; }

    /// <summary>
    /// Indicates whether the current cart meets free shipping conditions
    /// </summary>
    public bool MeetsFreeShippingConditions { get; set; }

    /// <summary>
    /// Additional amount needed to qualify for free shipping
    /// </summary>
    public double? AmountRemainingForFreeShipping { get; set; }
}