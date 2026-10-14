using Grand.Business.Tenants.Extensions;
using Grand.Infrastructure.Extensions;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Http;

namespace Grand.Web.ExternalSettings.DataProtection
{
    /// <summary>
    /// Simple wrapper to hold a reference to the IDataProtectionProvider
    /// </summary>
    public class DataProtectionProviderWrapper
    {
        public IDataProtectionProvider Provider { get; }

        public DataProtectionProviderWrapper(IDataProtectionProvider provider)
        {
            Provider = provider;
        }
    }

    /// <summary>
    /// Tenant-aware data protection provider that creates tenant-specific protectors
    /// </summary>
    public class TenantAwareDataProtectionProvider : IDataProtectionProvider
    {
        private readonly IDataProtectionProvider _baseProvider;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public TenantAwareDataProtectionProvider(
            IDataProtectionProvider baseProvider,
            IHttpContextAccessor httpContextAccessor)
        {
            _baseProvider = baseProvider;
            _httpContextAccessor = httpContextAccessor;
        }

        public IDataProtector CreateProtector(string purpose)
        {
            // Get the current tenant ID
            var tenantId = _httpContextAccessor.HttpContext?.GetTenantId();
            
            // Create a tenant-specific purpose string
            var tenantPurpose = !string.IsNullOrEmpty(tenantId)
                ? $"Tenant_{tenantId}_{purpose}"
                : purpose;

            // Create a protector with the tenant-specific purpose
            return _baseProvider.CreateProtector(tenantPurpose);
        }
    }
}