namespace Payments.Iyzico;

public static class IyzicoDefaults
{
    public const string ProviderSystemName = "Payments.Iyzico";
    public const string FriendlyName = "Payments.Iyzico.Friendlyname";
    public const string ConfigurationUrl = "/Admin/IyzicoPayment/Configure";

    public const string PaymentInfoRouteName = "Plugin.IyzicoPayment";
    public const string PaymentThreeDsCallbackRouteName = "Plugin.IyzicoThreeDsPaymentCallback";
    public const string PaymentThreeDsFormRenderRouteName = "Plugin.IyzicoThreeDsFormRender";

    public const string IyzicoUserKey = "IyzicoUserKey";
    public const string IyzicoSelectedCardTokenKey = "SelectedCardToken";

    public const string IyzicoEncryptionKey = "IyzicoEncryptionKey";

    public const string EncryptedCartFormKey ="encryptedCardForm";

    public const string SelectedCardTokenKey ="selectedCartToken";
}
