using Core.Models.Configs;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SaasManager.Infrastructure;
using SaasManager.Infrastructure.Authentication;
using SaasManager.Application.Common.Interfaces.Keycloak;

namespace Portable.Services.Tests;

[TestClass]
public sealed class IdentityConfigurationTests
{
    [TestMethod]
    public void ProductionRejectsHttpIdentityAndMissingCredentialsAtConfigurationValidation()
    {
        using var invalid=Services("http://identity.example.test/realms/commerce","configured");
        Assert.ThrowsException<OptionsValidationException>(() => _=invalid.GetRequiredService<IOptions<AuthConfiguration>>().Value);
        using var missing=Services("https://identity.example.test/realms/commerce","");
        Assert.ThrowsException<OptionsValidationException>(() => _=missing.GetRequiredService<IOptions<AuthConfiguration>>().Value);
        using var valid=Services("https://identity.example.test/realms/commerce","configured");
        Assert.AreEqual("portal",valid.GetRequiredService<IOptions<AuthConfiguration>>().Value.ClientId);
    }

    [TestMethod]
    public void HierarchicalClientSecretSupportsDeploymentEnvironmentVariables()
    {
        var builder=Host.CreateApplicationBuilder(new HostApplicationBuilderSettings { DisableDefaults=true,EnvironmentName=Environments.Production });
        builder.Configuration.AddInMemoryCollection(new Dictionary<string,string?> {
            ["AuthConfiguration:IdentityProviderUrl"]="https://identity.example.test/realms/commerce",
            ["AuthConfiguration:ClientId"]="portal",["AuthConfiguration:ClientSecret"]="explicit-deployment-value",
            ["ClientSecret-portal"]="legacy-value"
        });
        builder.RegisterAuthentication();using var services=builder.Services.BuildServiceProvider();
        Assert.AreEqual("explicit-deployment-value",services.GetRequiredService<IOptions<AuthConfiguration>>().Value.ClientSecret);
    }

    [TestMethod]
    public void PrivateIdentityTrustIsExplicitAndInvalidPathsCannotFallBack()
    {
        Assert.IsNull(IdentityTransport.Create(new ConfigurationBuilder().Build()));
        var invalid=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?>{
            ["AuthConfiguration:AuthorityRootCertificateFile"]="relative-or-missing.crt"}).Build();
        Assert.ThrowsException<InvalidOperationException>(() => IdentityTransport.Create(invalid));
    }

    [TestMethod]
    public void TokenOperationsUseTheConfiguredIdentityTrustAndRefuseAnInvalidAnchor()
    {
        using var valid=Services("https://identity.example.test/realms/commerce","configured");
        Assert.IsNotNull(valid.GetRequiredService<IKeycloakService>());
        using var invalid=Services("https://identity.example.test/realms/commerce","configured","relative-or-missing.crt");
        var error=Assert.ThrowsException<InvalidOperationException>(() => invalid.GetRequiredService<IKeycloakService>());
        StringAssert.Contains(error.Message,"private-CA certificate file");
    }

    private static ServiceProvider Services(string authority,string secret,string? rootCertificate=null)
    {
        var builder=Host.CreateApplicationBuilder(new HostApplicationBuilderSettings { DisableDefaults=true,EnvironmentName=Environments.Production });
        builder.Configuration.AddInMemoryCollection(new Dictionary<string,string?> {
            ["AuthConfiguration:IdentityProviderUrl"]=authority,["AuthConfiguration:ClientId"]="portal",["ClientSecret-portal"]=secret,
            ["AuthConfiguration:AuthorityRootCertificateFile"]=rootCertificate
        });
        builder.RegisterAuthentication();return builder.Services.BuildServiceProvider();
    }
}
