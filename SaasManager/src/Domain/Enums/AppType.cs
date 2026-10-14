namespace SaasManager.Domain.Enums;

public enum AppType
{
    /// <summary>
    /// İşletmenin müşterilerine sunduğu mobil uygulama
    /// </summary>
    CustomerMobile = 0,

    /// <summary>
    /// İşletmenin fiziksel satış noktalarında kullandığı POS uygulaması
    /// </summary>
    POSApplication = 1,

    /// <summary>
    /// İşletmenin kuryelerinin kullandığı mobil uygulama
    /// </summary>
    CourierMobile = 2
}
