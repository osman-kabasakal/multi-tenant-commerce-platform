using Grand.Infrastructure.ModelBinding;
using Grand.Infrastructure.Models;
using Microsoft.AspNetCore.Http;

namespace Grand.Web.Admin.Models.Settings;

public class PushNotificationsSettingsModel : BaseModel
{
    [GrandResourceDisplayName("Admin.Settings.PushNotifications.NotificationsEnabled")]
    public bool Enabled { get; set; }

    [GrandResourceDisplayName("Admin.Settings.PushNotifications.PrivateApiKey")]
    public string PrivateApiKey { get; set; }

    [GrandResourceDisplayName("Admin.Settings.PushNotifications.PushApiKey")]
    public string PushApiKey { get; set; }

    [GrandResourceDisplayName("Admin.Settings.PushNotifications.SenderId")]
    public string SenderId { get; set; }

    [GrandResourceDisplayName("Admin.Settings.PushNotifications.AuthDomain")]
    public string AuthDomain { get; set; }

    [GrandResourceDisplayName("Admin.Settings.PushNotifications.DatabaseUrl")]
    public string DatabaseUrl { get; set; }

    [GrandResourceDisplayName("Admin.Settings.PushNotifications.ProjectId")]
    public string ProjectId { get; set; }

    [GrandResourceDisplayName("Admin.Settings.PushNotifications.StorageBucket")]
    public string StorageBucket { get; set; }

    [GrandResourceDisplayName("Admin.Settings.PushNotifications.AppId")]
    public string AppId { get; set; }

    [GrandResourceDisplayName("Admin.Settings.PushNotifications.AllowGuestNotifications")]
    public bool AllowGuestNotifications { get; set; }
    
    [GrandResourceDisplayName("Admin.Settings.PushNotifications.ServiceAccountFile")]
    public IFormFile ServiceAccountFile { get; set; }
    
    [GrandResourceDisplayName("Admin.Settings.PushNotifications.ServiceAccountJson")]
    public string ServiceAccountJson { get; set; }
    
    [GrandResourceDisplayName("Admin.Settings.PushNotifications.UseHttpV1Api")]
    public bool UseHttpV1Api { get; set; } = true;
    
    public bool HasServiceAccountConfigured => !string.IsNullOrEmpty(ServiceAccountJson);
}