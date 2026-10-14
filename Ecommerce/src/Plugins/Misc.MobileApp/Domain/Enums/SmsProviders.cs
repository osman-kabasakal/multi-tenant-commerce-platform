using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Misc.MobileApp.Domain.Enums;

public enum SmsProviders
{
    [Display(Name = "Twilio")]
    Twilio,
    [Display(Name = "NetGsm")]
    NetGsm
}