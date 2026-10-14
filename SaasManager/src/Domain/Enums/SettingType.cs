namespace SaasManager.Domain.Enums;

public enum SettingType
{
    /// <summary>
    /// Sistem tarafından yönetilen ayarlar
    /// </summary>
    System = 0,

    /// <summary>
    /// İşletme tarafından özelleştirilebilen ayarlar
    /// </summary>
    Custom = 1,

    /// <summary>
    /// Uygulama özellikleri ile ilgili ayarlar
    /// </summary>
    Feature = 2,

    /// <summary>
    /// Entegrasyon ayarları
    /// </summary>
    Integration = 3,

    /// <summary>
    /// Bildirim ayarları
    /// </summary>
    Notification = 4,

    /// <summary>
    /// Görünüm/tema ayarları
    /// </summary>
    Theme = 5
}
