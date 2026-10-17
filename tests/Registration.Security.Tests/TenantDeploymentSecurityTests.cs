using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Provisioning;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Stores.Provisioning;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Infrastructure.Data;

namespace Registration.Security.Tests;

[TestClass]
public sealed class TenantDeploymentSecurityTests
{
    [DataTestMethod]
    [DataRow("unverified")][DataRow("different-subject")][DataRow("foreign-business")]
    public async Task EveryDeploymentActionRequiresTheVerifiedOwnerOfTheCurrentBusiness(string scenario)
    {
        await using var db=new TestContext(new DbContextOptionsBuilder<ApplicationDbContext>().UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
        var subject=Guid.NewGuid();var guest=new GuestRegistration("owner@example.test",""){Id=Guid.NewGuid()};guest.MarkAsConverted(subject.ToString());
        if(scenario!="unverified")guest.MarkEmailAsVerified();
        var business=new Business("Store","Owner","owner@example.test","5551234567","9999999901","Office","Street","City","District","00000","Company",
            scenario=="foreign-business"?Guid.NewGuid():guest.Id){Id=Guid.NewGuid()};guest.ConvertToBusiness(business);
        db.Businesses.Add(business);db.GuestRegistrations.Add(guest);await db.SaveChangesAsync();
        var work=new Mock<IWorkContext>();work.SetupGet(x=>x.KeycloakId).Returns(scenario=="different-subject"?Guid.NewGuid():subject);work.SetupProperty(x=>x.GuestRegistration,guest);
        var config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> {
            ["Provisioning:Profile"]="Portable",["Provisioning:DeploymentId"]="ownership-test",["Provisioning:CustomDomains:Enabled"]="true",
            ["Provisioning:Mobile:Provider"]="AndroidIosAppDistribution",["TenantOnboarding:MobileApplicationIdPrefix"]="com.publisher"}).Build();
        var queue=new Mock<IProvisioningQueue>(MockBehavior.Strict);
        // All actions must be refused before opening any provider/queue connection.
        const string unused="Host=127.0.0.1;Port=1;Username=unopened;Password=synthetic;Database=unused;Timeout=1";
        await using var domains=new TenantDomainRegistry(unused);await using var changes=new DomainActivationQueue(unused);await using var identities=new MobileIdentityRegistry(unused);
        var handler=new TenantDeploymentHandler(db,work.Object,config,queue.Object,domains,changes,identities);
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(()=>handler.Handle(new GetTenantDeployment(),default));
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(()=>handler.Handle(new ActivateTenantDomain(Guid.NewGuid(),true),default));
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(()=>handler.Handle(new CreateMobileIdentity(Guid.NewGuid()),default));
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(()=>handler.Handle(new RetryTenantDeployment(Guid.NewGuid(),"identity"),default));
        queue.VerifyNoOtherCalls();
    }
}
