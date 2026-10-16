using Grand.Business.Tenants.Startup;
using Grand.Business.Tenants.Services.KeycloakJwtToken;
using Grand.Domain.Tenants;
using Grand.Infrastructure.Caching;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Security;
using System.Net;

namespace LocalDemo.Tests;

[TestClass]
public class IdentityStartupTests
{
    [TestMethod]
    public void PublicHostDoesNotNeedManagementSecrets()
    {
        var secrets = new Mock<ISecretStore>(MockBehavior.Strict);
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            ["AuthConfiguration:IdentityProviderUrl"] = "https://identity.example.test/realms/commerce",
            ["AuthConfiguration:ClientId"] = "saas-manager", ["AuthConfiguration:Audience"] = "saas-manager"
        }).Build();
        var services = new ServiceCollection().AddLogging().AddSingleton(secrets.Object);
        new TenantStartup().ConfigureServices(services, config);
        using var provider = services.BuildServiceProvider();
        var settings = provider.GetRequiredService<IOptions<AuthConfiguration>>().Value;
        Assert.AreEqual("https://identity.example.test/realms/commerce", settings.IdentityProviderUrl);
        Assert.AreEqual("saas-manager", settings.Audience);
        Assert.IsTrue(string.IsNullOrEmpty(settings.ClientSecret));
        Assert.ThrowsException<InvalidOperationException>(() => provider.GetRequiredService<KeycloakSettings>());
        secrets.VerifyNoOtherCalls();
    }

    [TestMethod]
    public void ExplicitManagementLoadsItsCredentialOnlyWhenResolved()
    {
        var secrets = new Mock<ISecretStore>(MockBehavior.Strict);
        secrets.Setup(x => x.GetAsync("system", "ClientSecret-management", It.IsAny<CancellationToken>())).ReturnsAsync("synthetic-management-credential");
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            ["KeyCloakServiceClient:Authority"] = "https://identity.example.test",
            ["KeyCloakServiceClient:Realm"] = "commerce", ["KeyCloakServiceClient:ClientId"] = "management"
        }).Build();
        var services = new ServiceCollection().AddLogging().AddSingleton(secrets.Object);
        new TenantStartup().ConfigureServices(services, config);
        secrets.VerifyNoOtherCalls();
        using var provider = services.BuildServiceProvider();
        var settings = provider.GetRequiredService<KeycloakSettings>();
        Assert.AreEqual("synthetic-management-credential", settings.ClientSecret);
        Assert.AreSame(settings, provider.GetRequiredService<KeycloakSettings>());
        secrets.Verify(x => x.GetAsync("system", "ClientSecret-management", It.IsAny<CancellationToken>()), Times.Once);
        secrets.VerifyNoOtherCalls();
    }

    [TestMethod]
    public async Task IntrospectionUsesOnlyItsOwnConfiguredCredential()
    {
        var secrets = new Mock<ISecretStore>(MockBehavior.Strict);
        secrets.Setup(x => x.GetAsync("system", "ClientSecret-introspection", It.IsAny<CancellationToken>())).ReturnsAsync("synthetic-introspection-credential");
        using var handler = new IntrospectionHandler(); using var client = new HttpClient(handler);
        var factory = new Mock<IHttpClientFactory>(); factory.Setup(x => x.CreateClient(It.IsAny<string>())).Returns(client);
        var validator = new KeycloakJwtTokenValidationService(NullLogger<KeycloakJwtTokenValidationService>.Instance,
            factory.Object, Options.Create(new AuthConfiguration { IdentityProviderUrl = "https://identity.example.test/realms/commerce", ClientId = "introspection" }), Mock.Of<ICacheBase>(), secrets.Object);
        secrets.VerifyNoOtherCalls();
        Assert.IsTrue(await validator.RemoteValidationTokenAsync("synthetic-access-token"));
        Assert.AreEqual("https://identity.example.test/realms/commerce/protocol/openid-connect/token/introspect", handler.Url);
        StringAssert.Contains(handler.Body, "client_id=introspection"); StringAssert.Contains(handler.Body, "client_secret=synthetic-introspection-credential");
        secrets.Verify(x => x.GetAsync("system", "ClientSecret-introspection", It.IsAny<CancellationToken>()), Times.Once);
        secrets.VerifyNoOtherCalls();
    }

    private sealed class IntrospectionHandler : HttpMessageHandler
    {
        public string Url = "", Body = "";
        protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            Url = request.RequestUri!.AbsoluteUri; Body = await request.Content!.ReadAsStringAsync(cancellationToken);
            return new HttpResponseMessage(HttpStatusCode.OK) { Content = new StringContent("{\"active\":true}") };
        }
    }
}
