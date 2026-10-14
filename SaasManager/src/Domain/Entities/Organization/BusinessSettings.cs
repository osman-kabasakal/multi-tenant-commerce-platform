namespace SaasManager.Domain.Entities.Organization;

public class BusinessSettings : AuditableEntity
{
    public Guid BusinessId { get; private set; }
    public string Key { get; private set; } = null!;
    public string Value { get; private set; } = null!;
    public string DefaultValue { get; private set; } = null!;
    public string Description { get; private set; } = null!;
    public SettingType Type { get; private set; }
    public SettingDataType DataType { get; private set; }
    public bool IsSystem { get; private set; }
    public bool IsRequired { get; private set; }
    public string? ValidationRule { get; private set; }
    public int DisplayOrder { get; private set; }
    public string? GroupName { get; private set; }

    // Navigation Property
    public Business Business { get; private set; } = null!;

    // Constructor for EF Core
    protected BusinessSettings() { }

    public BusinessSettings(
        Guid businessId,
        string key,
        string value,
        string defaultValue,
        string description,
        SettingType type,
        SettingDataType dataType,
        bool isSystem = false,
        bool isRequired = false,
        string? validationRule = null,
        int displayOrder = 0,
        string? groupName = null)
    {
        BusinessId = businessId;
        Key = key;
        Value = value;
        DefaultValue = defaultValue;
        Description = description;
        Type = type;
        DataType = dataType;
        IsSystem = isSystem;
        IsRequired = isRequired;
        ValidationRule = validationRule;
        DisplayOrder = displayOrder;
        GroupName = groupName;
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
    }

    // Domain methods
    public void UpdateValue(string newValue)
    {
        if (!IsSystem)
        {
            Value = newValue;
            UpdatedAt = DateTime.UtcNow;
        }
        else
        {
            throw new InvalidOperationException("System settings cannot be modified directly.");
        }
    }

    public void UpdateSystemValue(string newValue)
    {
        if (IsSystem)
        {
            Value = newValue;
            UpdatedAt = DateTime.UtcNow;
        }
    }

    public void UpdateMetadata(
        string description,
        string validationRule,
        int displayOrder,
        string groupName)
    {
        Description = description;
        ValidationRule = validationRule;
        DisplayOrder = displayOrder;
        GroupName = groupName;
        UpdatedAt = DateTime.UtcNow;
    }

    public bool ValidateValue(string value)
    {
        if (string.IsNullOrEmpty(value) && IsRequired)
        {
            return false;
        }

        if (string.IsNullOrEmpty(ValidationRule))
        {
            return true;
        }

        // Basit regex kontrolü - gerçek uygulamada daha kapsamlı validasyon yapılmalı
        try
        {
            return System.Text.RegularExpressions.Regex.IsMatch(value, ValidationRule);
        }
        catch
        {
            return false;
        }
    }

    public string GetEffectiveValue()
    {
        return !string.IsNullOrEmpty(Value) ? Value : DefaultValue;
    }
}
