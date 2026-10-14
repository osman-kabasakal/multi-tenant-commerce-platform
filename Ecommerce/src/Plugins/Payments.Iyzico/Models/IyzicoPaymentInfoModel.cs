using Grand.Infrastructure.Models;
using Iyzipay.Model;
using Payments.Iyzico.Utilities;

namespace Payments.Iyzico.Models;

public class IyzicoPaymentInfoModel: BaseModel
{
    public Dictionary<string, FieldDefinition> CreditCardFormData { get; set; }

    public List<Card> StoredUserCards { get; set; }

    public bool SandBox { get; set; }

    public string SelectedCardToken { get; set; }

    public string InstallmentQueryUrl { get; set; }
    
    public string IyzicoBrandImageUrl { get; set; }="/Plugins/Payments.Iyzico/Assets/iyzico_ile_ode_colored_horizontal.svg";

    public string CreditCardBrandUrl { get; set; }="/Plugins/Payments.Iyzico/Assets/logo_band_colored.svg";

}
