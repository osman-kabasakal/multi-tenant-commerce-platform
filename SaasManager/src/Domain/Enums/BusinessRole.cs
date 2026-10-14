namespace SaasManager.Domain.Enums;

public enum BusinessRole
{
    /// <summary>
    /// İşletme sahibi - Tüm yetkilere sahip
    /// </summary>
    Owner = 0,

    /// <summary>
    /// İşletme yöneticisi - Sınırlı yönetim yetkileri
    /// </summary>
    Manager = 1,

    /// <summary>
    /// Kasiyer - POS uygulaması kullanım yetkisi
    /// </summary>
    Cashier = 2,

    /// <summary>
    /// Depo sorumlusu - Stok yönetimi yetkisi
    /// </summary>
    StockManager = 3,

    /// <summary>
    /// Sipariş yöneticisi - Sipariş ve kurye yönetimi
    /// </summary>
    OrderManager = 4
}
