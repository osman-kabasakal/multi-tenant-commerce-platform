using System.ComponentModel;

namespace SaasManager.Domain.Enums;


public enum RegistrationStep
{
    [Description("Başlangıç")]
    Initial = 0,

    [Description("Doğrulama")]
    Verification = 1,

    [Description("İşletme Bilgileri")]
    BusinessInfo = 2,

    [Description("Ödeme Yöntemi")]
    PaymentMethod = 3,

    [Description("Sözleşme Onayı")]
    TermsAccepted = 4,

    [Description("Tamamlandı")]
    Completed = 5
}
