namespace Grand.Infrastructure.MultiTenant;

public interface ITenantIdentityAccessor
{
    string TenantId { get; set; }
}