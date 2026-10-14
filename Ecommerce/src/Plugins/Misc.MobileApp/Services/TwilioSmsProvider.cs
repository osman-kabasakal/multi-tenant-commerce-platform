using Microsoft.Extensions.DependencyInjection;
using System.Text.RegularExpressions;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace Misc.MobileApp.Services;

public class TwilioSmsProvider(
    SendCouponCodeNotificationSettings sendCouponCodeNotificationSettings
    ): ISmsProvider
{
    public async Task SendSmsAsync(string phoneNumber, string message)
    {
        TwilioClient.Init(sendCouponCodeNotificationSettings.TwilioAccountSid,
            sendCouponCodeNotificationSettings.TwilioAuthToken);
        
        var normalizePhoneNumber =
            Regex.Replace(sendCouponCodeNotificationSettings.TwilioPhoneNumber, @"[^\d]", "");
        
        var normalizeToNumber = Regex.Replace(phoneNumber, @"[^\d]", "");
        
        await MessageResource.CreateAsync(
            body:message,
            from: new PhoneNumber($"+{normalizePhoneNumber}"),
            to: new PhoneNumber($"+{normalizeToNumber}")
        );
        
    }
}