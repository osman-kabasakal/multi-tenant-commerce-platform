using System;
using System.Linq;
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
            ArgumentNullException.ThrowIfNull(purpose);
            return new TenantProtector(_baseProvider, _httpContextAccessor, new[] { purpose });
        }

        // Cookie authentication options cache protectors. Resolve the tenant for each operation,
        // keeping the original first-purpose prefix and subsequent purpose chain intact.
        private sealed class TenantProtector : IDataProtector
        {
            private readonly IDataProtectionProvider _provider;
            private readonly IHttpContextAccessor _context;
            private readonly string[] _purposes;

            public TenantProtector(IDataProtectionProvider provider, IHttpContextAccessor context, string[] purposes)
            {
                _provider = provider;
                _context = context;
                _purposes = purposes;
            }

            public IDataProtector CreateProtector(string purpose)
            {
                ArgumentNullException.ThrowIfNull(purpose);
                return new TenantProtector(_provider, _context, _purposes.Append(purpose).ToArray());
            }

            public byte[] Protect(byte[] plaintext) => Current().Protect(plaintext);
            public byte[] Unprotect(byte[] protectedData) => Current().Unprotect(protectedData);

            private IDataProtector Current()
            {
                var tenant = _context.HttpContext?.GetTenantId();
                var first = string.IsNullOrEmpty(tenant) ? _purposes[0] : $"Tenant_{tenant}_{_purposes[0]}";
                var protector = _provider.CreateProtector(first);
                foreach (var purpose in _purposes.Skip(1)) protector = protector.CreateProtector(purpose);
                return protector;
            }
        }
    }
}