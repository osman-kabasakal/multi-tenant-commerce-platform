using Microsoft.Extensions.Configuration;
using Platform.Security;

namespace SaasManager.Infrastructure.Authentication;

/// <summary>Optional private-PKI trust for identity backchannels; system-wide TLS trust is unchanged.</summary>
public static class IdentityTransport
{
    public static SocketsHttpHandler? Create(IConfiguration configuration) =>
        PrivateCertificateAuthority.CreateHandler(configuration["AuthConfiguration:AuthorityRootCertificateFile"]);
}
