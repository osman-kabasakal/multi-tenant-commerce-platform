using System.Security.Claims;
using System.Text.Json;
using Grand.Web.MultiTenant.MiddleWares;
using Grand.Web.MultiTenant.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Hosting;
using Platform.Security;

namespace Storefront.Binding.Tests;

[TestClass]
public sealed class CustomStoreTokenTests
{
    [DataTestMethod]
    [DataRow("owned", true)]
    [DataRow("legacy", true)]
    [DataRow("wrong-slug", false)]
    [DataRow("missing-slug", false)]
    [DataRow("wrong-store", false)]
    [DataRow("foreign-alias", false)]
    [DataRow("admin-host", false)]
    [DataRow("wrong-port", false)]
    [DataRow("http", false)]
    [DataRow("unknown-host", false)]
    [DataRow("null-principal", false)]
    public async Task RealStoreMiddlewareBindsTheTokenToTheVerifiedHost(string scenario, bool allowed)
    {
        var directory = Path.Combine(Path.GetTempPath(), "store-host-proof-" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(directory);
        try
        {
            const string slug = "contract-shop", host = "customer.example.net", store = "owned-store";
            var tenant = Guid.NewGuid().ToString("N");
            var route = new TenantCustomHostRoute(1, "Portable", tenant, slug, store, Guid.NewGuid(), host,
                scenario == "admin-host" ? "admin" : "store", "https://" + host, "https://manage." + host + "/Admin", true);
            if (scenario == "admin-host") route = route with { Host = "manage." + host };
            await File.WriteAllTextAsync(TenantCustomHostRoutes.PathFor(directory, route.Host),
                JsonSerializer.Serialize(route, new JsonSerializerOptions(JsonSerializerDefaults.Web)));
            var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?> {
                ["TenantRouting:Provider"] = "Directory", ["TenantRouting:CustomDomainsEnabled"] = "true",
                ["TenantRouting:RouteDirectory"] = directory
            }).Build();
            var secrets = new Mock<ITenantSecrets>();
            secrets.Setup(s => s.ResolveAsync(slug, It.IsAny<CancellationToken>())).ReturnsAsync(tenant);
            secrets.Setup(s => s.ResolveAsync(store, It.IsAny<CancellationToken>())).ReturnsAsync(scenario == "foreign-alias" ? Guid.NewGuid().ToString("N") : tenant);
            using var services = new ServiceCollection().AddSingleton<IConfiguration>(config).AddSingleton(secrets.Object).BuildServiceProvider();
            var context = new DefaultHttpContext { RequestServices = services };
            context.Request.Scheme = scenario == "http" ? "http" : "https";
            context.Request.Host = new HostString(scenario switch {
                "legacy" => slug + ".shops.example.net", "unknown-host" => "unregistered.example.net",
                "wrong-port" => host + ":8443", _ => route.Host
            });
            context.Request.Path = "/_platform/ready";
            context.Request.Headers["x-store-token"] = "server-issued-token";
            context.Request.Headers["X-Platform-Tenant"] = "forged-header";
            context.Response.Body = new MemoryStream();
            var claims = new List<Claim> { new("store_id", "encrypted-store"), new("db_connection", "encrypted-db") };
            if (scenario != "missing-slug") claims.Add(new("sub_domainname", scenario == "wrong-slug" ? "foreign-shop" : slug));
            var principal = scenario == "null-principal" ? null : new ClaimsPrincipal(new ClaimsIdentity(claims));
            var validator = new Mock<IKeycloakClientTokenValidation>();
            validator.Setup(v => v.ValidateJwt("server-issued-token", It.IsAny<string>(), true)).ReturnsAsync(principal);
            var encryption = new Mock<ITenantEncryptionService>();
            encryption.Setup(e => e.DecryptAsync("encrypted-store", slug)).ReturnsAsync(scenario == "wrong-store" ? "foreign-store" : store);
            encryption.Setup(e => e.DecryptAsync("encrypted-db", slug)).ReturnsAsync("owned-database");
            var calls = 0;
            var middleware = new RequestValidationMiddleware(_ => { calls++; return Task.CompletedTask; });
            await middleware.InvokeAsync(context, validator.Object, encryption.Object, new PublicRouteService());
            Assert.AreEqual(allowed ? 1 : 0, calls, scenario);
            if (allowed)
            {
                validator.Verify(v => v.ValidateJwt("server-issued-token", slug, true), Times.Once);
                Assert.AreEqual(store, context.Items["StoreId"]);
                Assert.AreEqual("owned-database", context.Items["StoreMongoConnectionString"]);
            }
            else Assert.AreEqual(400, context.Response.StatusCode, scenario);
        }
        finally { Directory.Delete(directory, true); }
    }
}
