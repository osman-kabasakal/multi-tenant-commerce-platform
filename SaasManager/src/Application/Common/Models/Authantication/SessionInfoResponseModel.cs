using System.ComponentModel.DataAnnotations;
using SaasManager.Application.Common.Models.IdentityManagement;

namespace SaasManager.Application.Common.Models.Authantication;

public class SessionInfoResponseModel
{
    public UserInfo? User { get; set; } // Nullable property for UserInfo
    public List<string> Roles { get; set; } = new List<string>();
    public List<string> Permissions { get; set; } = new List<string>();
    public string? BusinessId { get; set; }

    public RegistrationStepResponse? RegistrationStep { get; set; }
}

public enum UserType
{
    [Display(Name="business_owner")]
    BusinessOwner,
    [Display(Name = "business_staff")]
    BusinessStaff,
    [Display(Name = "courier")]
    Courier,
    [Display(Name = "super_admin")]
    SuperAdmin
}

public class UserInfo
{
    public string Id { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string Name { get; set; } = null!;
    public string? BusinessId { get; set; } // Optional property
    public string Type { get; set; } = null!;

    public bool IsSetupCompleted { get; set; }
}
