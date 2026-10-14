namespace SaasManager.Domain.Enums;

public enum BuildStatus
{
    /// <summary>
    /// Uygulama henüz derlenmedi
    /// </summary>
    NotBuilt = 0,

    /// <summary>
    /// Derleme için sırada bekliyor
    /// </summary>
    Queued = 1,

    /// <summary>
    /// Derleme işlemi devam ediyor
    /// </summary>
    Building = 2,

    /// <summary>
    /// Derleme başarılı, uygulama hazır
    /// </summary>
    Built = 3,

    /// <summary>
    /// Derleme başarısız oldu
    /// </summary>
    Failed = 4,

    /// <summary>
    /// Uygulama mağazaya yüklendi
    /// </summary>
    Published = 5,

    /// <summary>
    /// Mağaza onayı bekliyor
    /// </summary>
    WaitingForApproval = 6,

    /// <summary>
    /// Mağaza onayı reddedildi
    /// </summary>
    Rejected = 7,

    /// <summary>
    /// Güncelleştirme gerekiyor
    /// </summary>
    UpdateRequired = 8
}
