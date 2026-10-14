using Google.Cloud.ResourceManager.V3;
using SaasManager.Domain.Entities.RegisteredApps;

namespace SaasManager.Application.Common.Interfaces.Firebase;


public interface IFirebaseService
{
    Task<bool> InitializeFirebaseAdminAsync();
    Task<T?> SendRestRequestAsync<T>(HttpMethod method, string url, object? body = null);
    Task<Project?> GetProjectAsync(string projectId);
    Task<Project?> CreateProjectAsync(Project project);
    Task AddFirebaseToProjectAsync(string projectId, AppBuildsConfig appConfig);
    Task<bool> AddServiceAccountWithFCMAdminRole(string projectId, string serviceAccountName, string serviceAccountDisplayName);
    Task<bool> AddUserToOwnerRole(string projectId, string userEmail);
}
