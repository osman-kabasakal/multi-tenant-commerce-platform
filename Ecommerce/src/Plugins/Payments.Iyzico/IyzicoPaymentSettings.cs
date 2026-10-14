using Grand.Domain.Configuration;

namespace Payments.Iyzico;

public class IyzicoPaymentSettings: ISettings
{
    public bool UseSandBox { get; set; }
    public string PublicKey { get; set; }
    public string PrivateKey { get; set; }
    public double AdditionalFee { get; set; }
    public bool AdditionalFeePercentage { get; set; }
    public int DisplayOrder { get; set; }
    public bool CardStorageSupported { get; set; }
    public bool Non3DSecureSupported { get; set; }
}
