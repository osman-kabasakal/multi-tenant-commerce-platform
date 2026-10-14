using Grand.Domain;

namespace Misc.MobileApp.Domain.GeneratedDiscountCoupon;

public class GeneratedDiscountCouponForPhoneNumber: BaseEntity
{
    public string CouponCodeId { get; set; }
    
    public string DiscountId {
        get;
        set;
    }

    public string PhoneNumber { get; set; }
    public string CustomerId { get; set; }
}