using Google.Apis.FirebaseManagement.v1beta1.Data;
using Google.Cloud.ResourceManager.V3;
using TenantManager.Models;
using TenantManagerClaude;

namespace TenantManager;


public interface IFirebaseService
{
    Task<bool> InitializeFirebaseAdminAsync();
    Task<T?> SendRestRequestAsync<T>(HttpMethod method, string url, object? body = null);
    Task<Project?> GetProjectAsync(string projectId);
    Task<Project?> CreateProjectAsync(Project project);
    Task AddFirebaseToProjectAsync(string projectId, AppBuildsConfig appConfig);
    Task<bool> AddServiceAccountWithFCMAdminRole(string projectId, string serviceAccountName, string serviceAccountDisplayName);
    Task<bool> AddUserToOwnerRole(string projectId, string userEmail);
    
    Task<AndroidAppConfig?> GetAndroidConfig(string packageName, string projectId);
    Task<CertificatesResponse?> GetFirebaseAndroidSha256(string projectId, string packageNameAndroid);
}