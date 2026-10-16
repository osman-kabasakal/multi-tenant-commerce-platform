using Core.Models.Configs;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SaasManager.Infrastructure;
using SaasManager.Infrastructure.Authentication;

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

    private static ServiceProvider Services(string authority,string secret)
    {
        var builder=Host.CreateApplicationBuilder(new HostApplicationBuilderSettings { DisableDefaults=true,EnvironmentName=Environments.Production });
        builder.Configuration.AddInMemoryCollection(new Dictionary<string,string?> {
            ["AuthConfiguration:IdentityProviderUrl"]=authority,["AuthConfiguration:ClientId"]="portal",["ClientSecret-portal"]=secret
        });
        builder.RegisterAuthentication();return builder.Services.BuildServiceProvider();
    }
}
