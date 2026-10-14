using Google.Apis.FirebaseManagement.v1beta1.Data;
using TenantManager.Models;

namespace TenantManager;

public interface IFirebaseSetupManager
{
    Task<bool> AddFirebaseToProjectAsync();
    Task<AndroidAppConfig> AddAndroidAppAsync(string packageName, string displayName);
    Task<IosAppConfig> AddIosAppAsync(string bundleId, string displayName, string teamId, string appStoreId = null);
    Task<bool> AddApnsKeyToIosAppAsync(string iosAppId, string apnsKeyPath, string apnsKeyId, string teamId);
    Task<bool> AddApnsCertificateToIosAppAsync(string iosAppId, string p12CertPath, string p12Password);
    Task<ApnsConfigStatus> GetApnsConfigStatusAsync(string iosAppId);
    Task<string> ConfigureFCMAsync();
    Task<string> SendTestFCMMessageAsync(string deviceToken);

    Task<AndroidAppConfig?> GetAndroidConfig(string packageName);

    Task<CertificatesResponse?> GetFirebaseSha256List(string androidPackageName);
}