using Grand.Business.Marketing.Services.PushNotifications;
using Grand.Data;
using Grand.Domain.PushNotifications;
using Grand.Infrastructure.MultiTenant;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Notifications;

namespace Platform.Notifications.Tests;

[TestClass]
public sealed class CommercePushTests
{
    private static (PushNotificationsService Service, Mock<ITenantPushSender> Sender, Mock<IRepository<PushMessage>> Messages) Create(
        IReadOnlyList<PushRegistration>? registrations=null, string tenant="tenant-store", int? accepted=null, bool fail=false)
    {
        var receivers=new Mock<IRepository<PushRegistration>>();receivers.SetupGet(r=>r.Table).Returns((registrations??Array.Empty<PushRegistration>()).AsQueryable());
        var messages=new Mock<IRepository<PushMessage>>();var sender=new Mock<ITenantPushSender>();
        if(fail)sender.Setup(s=>s.SendAsync(It.IsAny<string>(),It.IsAny<IReadOnlyList<string>>(),It.IsAny<TenantPushMessage>(),It.IsAny<CancellationToken>())).ThrowsAsync(new InvalidOperationException("private-secret-detail"));
        else sender.Setup(s=>s.SendAsync(It.IsAny<string>(),It.IsAny<IReadOnlyList<string>>(),It.IsAny<TenantPushMessage>(),It.IsAny<CancellationToken>()))
            .Returns((string id,IReadOnlyList<string> tokens,TenantPushMessage message,CancellationToken ct)=>Task.FromResult(new TenantPushReceipt(tokens.Count,accepted??tokens.Count,"LocalSink")));
        var accessor=new Mock<ITenantIdentityAccessor>();accessor.SetupGet(a=>a.TenantId).Returns(tenant);
        var service=new PushNotificationsService(receivers.Object,messages.Object,new Mock<IMediator>().Object,new Mock<ILogger<PushNotificationsService>>().Object,sender.Object,accessor.Object,new HttpContextAccessor());
        return(service,sender,messages);
    }

    [TestMethod]
    public async Task CommerceUsesScopedTenantAndPersistsOnlyAcceptedRecipients()
    {
        var (service,sender,messages)=Create([new(){Token="device-a",Allowed=true},new(){Token="device-a",Allowed=true},new(){Token="device-b",Allowed=false}]);
        var result=await service.SendPushNotification("Title","Message","","https://example.com/order");
        Assert.IsTrue(result.Item1);
        sender.Verify(s=>s.SendAsync("tenant-store",It.Is<IReadOnlyList<string>>(t=>t.Count==1&&t[0]=="device-a"),It.Is<TenantPushMessage>(m=>m.ClickUrl=="https://example.com/order"),It.IsAny<CancellationToken>()),Times.Once);
        messages.Verify(r=>r.InsertAsync(It.Is<PushMessage>(p=>p.NumberOfReceivers==1)),Times.Once);
    }

    [TestMethod]
    public async Task HttpRequestsUseVerifiedRouteIdentityAndRejectMissingRouteInsteadOfAmbientTenant()
    {
        var receivers=new Mock<IRepository<PushRegistration>>();var messages=new Mock<IRepository<PushMessage>>();
        var sender=new Mock<ITenantPushSender>();sender.Setup(s=>s.SendAsync(It.IsAny<string>(),It.IsAny<IReadOnlyList<string>>(),It.IsAny<TenantPushMessage>(),It.IsAny<CancellationToken>())).ReturnsAsync(new TenantPushReceipt(1,1,"LocalSink"));
        var ambient=new Mock<ITenantIdentityAccessor>();ambient.SetupGet(t=>t.TenantId).Returns("ambient-tenant");
        var context=new HttpContextAccessor{HttpContext=new DefaultHttpContext()};context.HttpContext.Items["StoreId"]="verified-route-store";
        var service=new PushNotificationsService(receivers.Object,messages.Object,new Mock<IMediator>().Object,new Mock<ILogger<PushNotificationsService>>().Object,sender.Object,ambient.Object,context);
        Assert.IsTrue((await service.SendPushNotification("Title","Body","","",new List<string>{"device"})).Item1);
        sender.Verify(s=>s.SendAsync("verified-route-store",It.IsAny<IReadOnlyList<string>>(),It.IsAny<TenantPushMessage>(),It.IsAny<CancellationToken>()),Times.Once);
        context.HttpContext.Items.Remove("StoreId");
        Assert.IsFalse((await service.SendPushNotification("Title","Body","","",new List<string>{"device"})).Item1);
        sender.Verify(s=>s.SendAsync("ambient-tenant",It.IsAny<IReadOnlyList<string>>(),It.IsAny<TenantPushMessage>(),It.IsAny<CancellationToken>()),Times.Never);
    }

    [TestMethod]
    public async Task OptedOutCustomerIsNeverSentOrReplacedByBroadcast()
    {
        var (service,sender,_)=Create([new(){CustomerId="opted-out",Token="device-a",Allowed=false},new(){CustomerId="other",Token="device-b",Allowed=true}]);
        var result=await service.SendPushNotification("Title","Message","","opted-out","https://example.com/order");
        Assert.IsFalse(result.Item1); sender.Verify(s=>s.SendAsync(It.IsAny<string>(),It.IsAny<IReadOnlyList<string>>(),It.IsAny<TenantPushMessage>(),It.IsAny<CancellationToken>()),Times.Never);
        result=await service.SendPushNotification("Title","Message","","",new List<string>{"[DENIED]"});
        Assert.IsFalse(result.Item1); sender.Verify(s=>s.SendAsync(It.IsAny<string>(),It.IsAny<IReadOnlyList<string>>(),It.IsAny<TenantPushMessage>(),It.IsAny<CancellationToken>()),Times.Never);
    }

    [TestMethod]
    public async Task MissingTenantNeverFallsBackToAnApplicationDefault()
    {
        var (service,sender,messages)=Create([new(){Token="device-a",Allowed=true}],tenant:"");
        var result=await service.SendPushNotification("Title","Message","","");
        Assert.IsFalse(result.Item1);sender.Verify(s=>s.SendAsync(It.IsAny<string>(),It.IsAny<IReadOnlyList<string>>(),It.IsAny<TenantPushMessage>(),It.IsAny<CancellationToken>()),Times.Never);
        messages.Verify(r=>r.InsertAsync(It.IsAny<PushMessage>()),Times.Never);
    }

    [TestMethod]
    public async Task NoAcceptedMessagesNeverCreatesASuccessRecord()
    {
        var (service,_,messages)=Create(accepted:0);
        var result=await service.SendPushNotification("Title","Message","","",new List<string>{"device-a"});
        Assert.IsFalse(result.Item1);messages.Verify(r=>r.InsertAsync(It.IsAny<PushMessage>()),Times.Never);
    }

    [TestMethod]
    public async Task ProviderExceptionsAreNotReturnedToTheAdmin()
    {
        var (service,_,messages)=Create(fail:true);
        var result=await service.SendPushNotification("Title","Message","","",new List<string>{"device-a"});
        Assert.IsFalse(result.Item1);Assert.AreEqual("Admin.PushNotifications.Error.SendFailed",result.Item2);
        Assert.IsFalse(result.Item2.Contains("private-secret-detail"));messages.Verify(r=>r.InsertAsync(It.IsAny<PushMessage>()),Times.Never);
    }

    [TestMethod]
    public async Task LargeRecipientListsAreSplitIntoProviderSizedBatches()
    {
        var (service,sender,messages)=Create();var tokens=Enumerable.Range(0,501).Select(i=>"device-"+i).ToList();
        var result=await service.SendPushNotification("Title","Message","","",tokens);
        Assert.IsTrue(result.Item1);
        sender.Verify(s=>s.SendAsync("tenant-store",It.Is<IReadOnlyList<string>>(t=>t.Count==500),It.IsAny<TenantPushMessage>(),It.IsAny<CancellationToken>()),Times.Once);
        sender.Verify(s=>s.SendAsync("tenant-store",It.Is<IReadOnlyList<string>>(t=>t.Count==1),It.IsAny<TenantPushMessage>(),It.IsAny<CancellationToken>()),Times.Once);
        messages.Verify(r=>r.InsertAsync(It.Is<PushMessage>(p=>p.NumberOfReceivers==501)),Times.Once);
    }
}
