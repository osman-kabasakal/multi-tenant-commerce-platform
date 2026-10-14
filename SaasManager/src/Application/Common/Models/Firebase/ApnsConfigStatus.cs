namespace SaasManager.Application.Common.Models.Firebase;

/// <summary>
/// APNs yapılandırma durumunu tutar
/// </summary>
public class ApnsConfigStatus
{
    /// <summary>
    /// APNs Authentication Key yapılandırması var mı?
    /// </summary>
    public bool HasApnsKey { get; set; }
        
    /// <summary>
    /// APNs Authentication Key ID
    /// </summary>
    public string ApnsKeyId { get; set; }
        
    /// <summary>
    /// Apple Developer Team ID
    /// </summary>
    public string TeamId { get; set; }
        
    /// <summary>
    /// APNs Sertifika yapılandırması var mı?
    /// </summary>
    public bool HasApnsCertificate { get; set; }
}
