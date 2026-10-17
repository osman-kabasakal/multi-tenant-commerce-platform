using System.Net;
using System.Text;
using Grand.Business.Core.Interfaces.Marketing.PushNotifications;
using Grand.Domain.Customers;
using Grand.Domain.PushNotifications;
using Grand.Infrastructure;
using Grand.Web.Controllers;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ApplicationModels;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;

namespace Platform.Notifications.Tests;

[TestClass]
public sealed class RegistrationBindingTests
{
    // This fixture tests MVC action selection and wire binding. Tenant/auth filters remain
    // unchanged in production and are covered separately by the actual mobile acceptance.
    private sealed class BindingOnly : IApplicationModelConvention
    {
        public void Apply(ApplicationModel model)
        {
            foreach (var controller in model.Controllers)
            {
                controller.Filters.Clear();
                foreach (var action in controller.Actions)
                    foreach (var filter in action.Filters.Where(x => x is not ConsumesAttribute).ToArray())
                        action.Filters.Remove(filter);
            }
        }
    }
    private sealed class Fixture : IDisposable
    {
        public List<PushRegistration> Inserted { get; } = [];
        public TestServer Server { get; }
        public HttpClient Client { get; }
        public Fixture()
        {
            var context = new Mock<IWorkContext>();
            context.SetupGet(x => x.CurrentCustomer).Returns(new Customer { Id = "owned-customer" });
            var pushes = new Mock<IPushNotificationsService>();
            pushes.Setup(x => x.GetPushReceiverByCustomerId("owned-customer")).ReturnsAsync((PushRegistration)null!);
            pushes.Setup(x => x.InsertPushReceiver(It.IsAny<PushRegistration>())).Callback<PushRegistration>(Inserted.Add).Returns(Task.CompletedTask);
            Server = new TestServer(new WebHostBuilder().ConfigureServices(s => {
                s.AddSingleton(context.Object); s.AddSingleton(pushes.Object);
                s.AddControllers(o => o.Conventions.Add(new BindingOnly())).AddApplicationPart(typeof(PushNotificationsController).Assembly);
            }).Configure(app => app.UseRouting().UseEndpoints(e => e.MapControllerRoute("default", "{controller}/{action}"))));
            Client = Server.CreateClient();
        }
        public void Dispose() { Client.Dispose(); Server.Dispose(); }
    }
    [DataTestMethod]
    [DataRow(true)] [DataRow(false)]
    public async Task JsonAndLegacyFormRegisterTheCurrentCustomer(bool json)
    {
        using var f = new Fixture();
        using HttpContent content = json ? new StringContent("{\"success\":true,\"value\":\"synthetic-token\",\"customerId\":\"foreign\"}", Encoding.UTF8, "application/json")
            : new FormUrlEncodedContent(new Dictionary<string,string> { ["success"]="true", ["value"]="synthetic-token" });
        var response = await f.Client.PostAsync("/PushNotifications/ProcessRegistration", content);
        Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        Assert.AreEqual(1, f.Inserted.Count); Assert.AreEqual("owned-customer", f.Inserted[0].CustomerId);
        Assert.AreEqual("synthetic-token", f.Inserted[0].Token); Assert.IsTrue(f.Inserted[0].Allowed);
    }
    [TestMethod]
    public async Task JsonPermissionDenialUsesTheSameExistingRegistrationFlow()
    {
        using var f = new Fixture();
        var response=await f.Client.PostAsync("/PushNotifications/ProcessRegistration",new StringContent("{\"success\":false,\"value\":\"Permission denied\"}",Encoding.UTF8,"application/json"));
        Assert.AreEqual(HttpStatusCode.OK,response.StatusCode);Assert.AreEqual(1,f.Inserted.Count);
        Assert.IsFalse(f.Inserted[0].Allowed);Assert.AreEqual("[DENIED]",f.Inserted[0].Token);
    }
    [DataTestMethod]
    [DataRow("{\"success\":\"secret-invalid-value\",\"value\":\"private-token\"}")]
    [DataRow("{\"success\":true,\"value\":\"\"}")]
    [DataRow("null")]
    [DataRow("{\"value\":\"private-token\"}")]
    public async Task InvalidJsonCannotSilentlySucceedOrEchoPrivateInput(string json)
    {
        using var f=new Fixture();var response=await f.Client.PostAsync("/PushNotifications/ProcessRegistration",new StringContent(json,Encoding.UTF8,"application/json"));
        Assert.AreEqual(HttpStatusCode.BadRequest,response.StatusCode);Assert.AreEqual(0,f.Inserted.Count);
        Assert.IsFalse((await response.Content.ReadAsStringAsync()).Contains("private-token"));
    }
}
