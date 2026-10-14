using System.Text.Json;

namespace SaasManager.Domain.Entities.Organization;

public class BusinessUser : AuditableEntity
{
    public Guid BusinessId { get; private set; }
    public string Name { get; private set; } = null!;
    public string Email { get; private set; } = null!;
    public string Phone { get; private set; } = null!;
    public BusinessRole Role { get; private set; }
    public string KeycloakUserId { get; private set; } = null!;
    public DateTime? LastLoginAt { get; private set; }
    public string ProfilePhotoUrl { get; private set; } = null!;
    public JsonDocument Permissions { get; private set; } = null!;
    public bool RequirePasswordChange { get; private set; }
    public DateTime? PasswordChangedAt { get; private set; }
    public int FailedLoginAttempts { get; private set; }
    public DateTime? LockedUntil { get; private set; }

    // Navigation Property
    public Business Business { get; private set; } = null!;

    // Constructor for EF Core
    protected BusinessUser() { }

    public BusinessUser(
        Guid businessId,
        string name,
        string email,
        string phone,
        BusinessRole role,
        string keycloakUserId)
    {
        BusinessId = businessId;
        Name = name;
        Email = email;
        Phone = phone;
        Role = role;
        KeycloakUserId = keycloakUserId;
        RequirePasswordChange = true;
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
    }

    // Domain methods
    public void UpdateProfile(string name, string phone, string profilePhotoUrl)
    {
        Name = name;
        Phone = phone;
        ProfilePhotoUrl = profilePhotoUrl;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateRole(BusinessRole newRole)
    {
        Role = newRole;
        UpdatedAt = DateTime.UtcNow;
    }

    public void RecordLogin()
    {
        LastLoginAt = DateTime.UtcNow;
        FailedLoginAttempts = 0;
        LockedUntil = null;
        UpdatedAt = DateTime.UtcNow;
    }

    public void RecordFailedLogin()
    {
        FailedLoginAttempts++;
            
        if (FailedLoginAttempts >= 5)
        {
            LockedUntil = DateTime.UtcNow.AddMinutes(30);
        }
            
        UpdatedAt = DateTime.UtcNow;
    }

    public void RecordPasswordChange()
    {
        RequirePasswordChange = false;
        PasswordChangedAt = DateTime.UtcNow;
        UpdatedAt = DateTime.UtcNow;
    }

    public void SetPermissions(JsonDocument permissions)
    {
        Permissions = permissions;
        UpdatedAt = DateTime.UtcNow;
    }

    public bool IsLocked()
    {
        return LockedUntil.HasValue && LockedUntil.Value > DateTime.UtcNow;
    }
}
