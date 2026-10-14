
using Payments.Iyzico.Utilities;
using System.ComponentModel.DataAnnotations;

public class CreditCardFormModel
{
    [DynamicFormFieldName("cardAlias")]
    [Display(Name = "Kart Adı")]
    
    public string? CardAlias { get; set; }

    [DynamicFormFieldName("cardToken")]
    [Display(Name = "Kart Token")]
    public string? CardToken { get; set; }

    [DynamicFormFieldName("cardHolderName")]
    [Required(ErrorMessage = "Kart üzerindeki isim zorunludur.")]
    [Display(Name = "Kart Üzerindeki İsim")]
    public string? CardHolderName { get; set; }

    [DynamicFormFieldName("cardNumber")]
    [Required(ErrorMessage = "Kart numarası zorunludur.")]
    [RegularExpression(@"^\d{16}$", ErrorMessage = "Kart numarası 16 haneli olmalıdır.")]
    [Display(Name = "Kart Numarası")]
    [DataType(DataType.CreditCard)]
    public string? CardNumber { get; set; }

    [DynamicFormFieldName("expireMonth")]
    [Required(ErrorMessage = "Son kullanma ayı zorunludur.")]
    [RegularExpression(@"^(0[1-9]|1[0-2])$", ErrorMessage = "Son kullanma ayı 01 ile 12 arasında olmalıdır.")]
    [Display(Name = "Son Kullanma Ay")]
    [Range(1, 12)]
    [DataType(DataType.Currency)]
    public string? ExpireMonth { get; set; }

    [DynamicFormFieldName("expireYear")]
    [Required(ErrorMessage = "Son kullanma yılı zorunludur.")]
    [RegularExpression(@"^\d{2}$", ErrorMessage = "Son kullanma yılı 2 haneli olmalıdır.")]
    [Display(Name = "Son Kullanma Yıl")]
    [Range(24, 50)]
    [DataType(DataType.Currency)]
    public string? ExpireYear { get; set; }

    [DynamicFormFieldName("cvc")]
    [Required(ErrorMessage = "Güvenlik kodu zorunludur.")]
    [RegularExpression(@"^\d{3}$", ErrorMessage = "Güvenlik kodu 3 haneli olmalıdır.")]
    [Display(Name = "Güvenlik Kodu")]
    [DataType(DataType.Currency)]
    [Range(100, 9999)]
    public string? Cvc { get; set; }

    [DynamicFormFieldName("installment")]
    [Display(Name = "Taksit")]
    public int? Installment { get; set; }

    [DynamicFormFieldName("approveCartStoreWithIyzico")]
    [Display(Name = "Iyzico tarafından kart bilgilerimin saklanmasını onaylıyorum.")]
    public bool? ApproveCartStoreWithIyzico { get; set; }

    [DynamicFormFieldName("use3dPayment")]
    [Display(Name = "3D kullanarak ödeme yapmak istiyorum.")]
    public bool? Use3dPayment { get; set; }
}