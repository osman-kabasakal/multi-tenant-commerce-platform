using System.ComponentModel;

namespace SaasManager.Domain.Enums;

public enum VerificationStatus
{
    [Description("Doğrulama Bekliyor")]
    Pending = 0,

    [Description("E-posta Doğrulandı")]
    EmailVerified = 1,

    [Description("Telefon Doğrulandı")]
    PhoneVerified = 2,

    [Description("Tümü Doğrulandı")]
    AllVerified = 3,

    [Description("Doğrulama Başarısız")]
    Failed = 4,

    [Description("Doğrulama Süresi Doldu")]
    Expired = 5
}
