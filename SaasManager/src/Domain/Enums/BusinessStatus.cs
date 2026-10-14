using System.ComponentModel;

namespace SaasManager.Domain.Enums;

public enum BusinessStatus
{
    [Description("Kayıt Bekliyor")]
    Pending = 0,

    [Description("Onay Bekliyor")]
    WaitingForApproval = 1,

    [Description("Kurulum Aşamasında")]
    UnderSetup = 2,

    [Description("Deneme Sürümü")]
    Trial = 3,

    [Description("Aktif")]
    Active = 4,

    [Description("Ödeme Bekliyor")]
    WaitingForPayment = 5,

    [Description("Askıya Alındı")]
    Suspended = 6,

    [Description("Kapatıldı")]
    Closed = 7,

    [Description("İptal Edildi")]
    Cancelled = 8,

    [Description("Yasaklandı")]
    Banned = 9
}
