using Grand.Infrastructure.ModelBinding;
using Grand.Infrastructure.Models;
using System.ComponentModel.DataAnnotations;

namespace Payments.Iyzico.Models;

public class ConfigurationModel : BaseModel
{
    [GrandResourceDisplayName("Payments.Iyzico.Fields.AdditionalFeePercentage")]
    [Display(Name="İşlem Ücreti Yüzdelik Uygulansın",Description ="İşlem ücreti ücreti sepet tutarına göre hesaplanır.")]
    public bool AdditionalFeePercentage { get; set; }

    [GrandResourceDisplayName("Payments.Iyzico.Fields.AdditionalFee")]
    [Display(Name="İşlem Ücreti", Description ="Kart toplamı hesaplanırken uygulanacak ekstra maliyet miktarı. Eğer yüzdelik uygulanması seçili ise kart toplamına göre %X'lik maliyet eklenir.")]
    public double AdditionalFee { get; set; }

    [GrandResourceDisplayName("Payments.Iyzico.Fields.UseSandbox")]
    [Display(Name="Test Ortamı Kullan", Description="Iyzico onay aşamasında kullanılmalıdır. Sadece test kartları ile işlem yapılabilir.")]
    public bool UseSandbox { get; set; }

    [GrandResourceDisplayName("Payments.Iyzico.Fields.ApiKey")]
    [Display(Name="API Anahtarı",Description ="Iyzico tarafından verilen anahtarınız")]
    public string ApiKey {
        get;
        set;
    }
    [GrandResourceDisplayName("Payments.Iyzico.Fields.ApiSecretKey")]
    [Display(Name="API Gizli Anahtarı",Description ="Iyzico tarafından verilen gizili anahtarınız")]
    public string ApiSecretKey {
        get;
        set;
    }

    [GrandResourceDisplayName("Payments.Iyzico.Fields.CardStorageSupported")]
    [Display(Name="Kart Saklama Destekleniyor", Description ="Kart saklama özelliği destekleniyorsa işaretleyin")]
    public bool CardStorageSupported { get; set; }

    [GrandResourceDisplayName("Payments.Iyzico.Fields.Non3DSecureSupported")]
    [Display(Name="Non 3D Secure Destekleniyor", Description ="Non 3D Secure ödeme yöntemi destekleniyorsa işaretleyin")]
    public bool Non3DSecureSupported { get; set; }

}
