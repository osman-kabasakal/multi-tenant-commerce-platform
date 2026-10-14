using Grand.Domain.Configuration;
using Misc.MobileApp.Domain.Enums;

namespace Misc.MobileApp;

public class SendCouponCodeNotificationSettings: ISettings
{
    public string DiscountId { get; set; }
    
    public SmsProviders SmsProvider { get; set; }
    public string TwilioAccountSid { get; set; }
    public string TwilioAuthToken { get; set; }
    public string TwilioPhoneNumber { get; set; }
    
    public string MsgHeader { get; set; }
    
    public string Username { get; set; }
    
    public string Password { get; set; }
    
}