using Grand.Api.Controllers;
using Grand.Api.DTOs;
using Grand.Api.Models.Common;
using Grand.Business.Core.Interfaces.Authentication;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Domain;
using Grand.Domain.Customers;
using Grand.Domain.Security;
using Grand.Infrastructure;
using Grand.Infrastructure.Configuration;
using MediatR;
using Microsoft.AspNetCore.Antiforgery;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;

namespace CustomerToken.Tests;

[TestClass]
public sealed class LoginTests
{
    [DataTestMethod]
    [DataRow(false,"wrong")][DataRow(true,"wrong")]
    [DataRow(false,"missing-password")][DataRow(true,"missing-password")]
    [DataRow(false,"unknown")][DataRow(true,"unknown")]
    [DataRow(false,"inactive")][DataRow(true,"inactive")]
    [DataRow(false,"deleted")][DataRow(true,"deleted")]
    [DataRow(false,"locked")][DataRow(true,"locked")]
    [DataRow(false,"two-factor")][DataRow(true,"two-factor")]
    [DataRow(false,"private-error")][DataRow(true,"private-error")]
    public async Task PasswordAndAccountFailuresCannotIssueOrRotateTokens(bool tenant,string scenario)
    {
        var f=new Fixture(tenant);var model=new LoginWebModel{Email="owner@example.test",Password=Encode("wrong-password")};
        f.Manager.Setup(m=>m.LoginCustomer(It.IsAny<string>(),It.IsAny<string>())).ReturnsAsync(CustomerLoginResults.WrongPassword);
        if(scenario=="missing-password")model.Password="";
        if(scenario=="unknown")f.Customers.Setup(c=>c.GetCustomerByEmail(It.IsAny<string>())).ReturnsAsync((Customer)null!);
        if(scenario=="inactive")f.Customer.Active=false;
        if(scenario=="deleted")f.Customer.Deleted=true;
        if(scenario=="locked")f.Customer.CannotLoginUntilDateUtc=DateTime.UtcNow.AddMinutes(5);
        if(scenario=="two-factor")f.Manager.Setup(m=>m.LoginCustomer(It.IsAny<string>(),It.IsAny<string>())).ReturnsAsync(CustomerLoginResults.RequiresTwoFactor);
        if(scenario=="private-error")f.Manager.Setup(m=>m.LoginCustomer(It.IsAny<string>(),It.IsAny<string>())).ThrowsAsync(new InvalidOperationException("private-provider-detail"));
        var result=await f.Login(model);Assert.IsInstanceOfType<UnauthorizedObjectResult>(result);Assert.AreEqual("Invalid credentials.",((UnauthorizedObjectResult)result).Value);
        f.Refresh.Verify(r=>r.SaveRefreshTokenToCustomer(It.IsAny<Customer>(),It.IsAny<string>()),Times.Never);
        f.Mediator.Verify(m=>m.Send(It.IsAny<IRequest<string>>(),It.IsAny<CancellationToken>()),Times.Never);
    }
    [DataTestMethod]
    [DataRow(false,false)][DataRow(true,false)][DataRow(false,true)][DataRow(true,true)]
    public async Task VerifiedPasswordUsesConfiguredIdentifierAndIssuesOneSession(bool tenant,bool username)
    {
        var f=new Fixture(tenant,username);var result=await f.Login(new(){Email="owner@example.test",Password=Encode("correct-password")});Assert.IsInstanceOfType<OkObjectResult>(result);
        var value=(TokenDto)((OkObjectResult)result).Value!;Assert.AreEqual("issued-token",value.AccessToken);Assert.AreEqual("refresh-value",value.RefreshToken);
        f.Manager.Verify(m=>m.LoginCustomer(username?"owner-name":"owner@example.test","correct-password"),Times.Once);
        f.Refresh.Verify(r=>r.SaveRefreshTokenToCustomer(f.Customer,"refresh-value"),Times.Once);
    }
    [DataTestMethod]
    [DataRow(false)][DataRow(true)]
    public async Task DisabledApiCannotAuthenticateCustomers(bool tenant)
    {var f=new Fixture(tenant);f.Config.Enabled=false;Assert.IsInstanceOfType<BadRequestObjectResult>(await f.Login(new(){Email="owner@example.test",Password=Encode("correct-password")}));f.Manager.Verify(m=>m.LoginCustomer(It.IsAny<string>(),It.IsAny<string>()),Times.Never);}
    [DataTestMethod]
    [DataRow("%%%",false)][DataRow("",false)][DataRow("wyg=",false)][DataRow("Y29ycmVjdA==",true)][DataRow("YQ==",true)]
    public async Task MalformedMobileWirePasswordsAreValidationErrors(string encoded,bool valid)
    {
        var validator=new Grand.Api.Validators.Common.LoginWebValidator(Array.Empty<Grand.Infrastructure.Validators.IValidatorConsumer<LoginWebModel>>(),new FrontendAPIConfig{Enabled=true});
        var result=await validator.ValidateAsync(new LoginWebModel{Email="owner@example.test",Password=encoded});Assert.AreEqual(valid,result.IsValid);
    }
    [TestMethod]
    public async Task UnicodeMobilePasswordReachesTheOrdinaryVerifierWithoutChangingCharacters()
    {
        var f=new Fixture(true);const string password="Şifre-İstanbul-🔐";Assert.IsInstanceOfType<OkObjectResult>(await f.Login(new(){Email="owner@example.test",Password=Encode(password)}));
        f.Manager.Verify(manager=>manager.LoginCustomer("owner@example.test",password),Times.Once);
    }
    private static string Encode(string password)=>Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(password));
    private sealed class Fixture
    {
        public Customer Customer {get;}=new(){Id="owned-customer",Email="owner@example.test",Username="owner-name",Active=true,Password="encoded-test-password"};
        public Mock<ICustomerService> Customers {get;}=new();public Mock<ICustomerManagerService> Manager {get;}=new();public Mock<IMediator> Mediator {get;}=new();public Mock<IRefreshTokenService> Refresh {get;}=new();
        public FrontendAPIConfig Config {get;}=new(){Enabled=true};public Func<LoginWebModel,Task<IActionResult>> Login {get;}
        public Fixture(bool tenant,bool username=false)
        {
            Customers.Setup(c=>c.GetCustomerByEmail(It.IsAny<string>())).ReturnsAsync(Customer);Manager.Setup(m=>m.LoginCustomer(It.IsAny<string>(),It.IsAny<string>())).ReturnsAsync(CustomerLoginResults.Successful);
            var fields=new Mock<IUserFieldService>();fields.Setup(f=>f.GetFieldsForEntity<string>(It.IsAny<BaseEntity>(),SystemCustomerFieldNames.PasswordToken,"")).ReturnsAsync("password-version");
            Refresh.Setup(r=>r.GenerateRefreshToken()).Returns("refresh-value");Refresh.Setup(r=>r.SaveRefreshTokenToCustomer(Customer,"refresh-value")).ReturnsAsync(new RefreshToken{RefreshId="refresh-id",Token="refresh-value"});
            Mediator.Setup(m=>m.Send(It.IsAny<IRequest<string>>(),It.IsAny<CancellationToken>())).ReturnsAsync("issued-token");
            var accessor=new HttpContextAccessor{HttpContext=new DefaultHttpContext()};accessor.HttpContext.Items["StoreId"]="owned-store";var settings=new CustomerSettings{UsernamesEnabled=username};
            if(tenant){var controller=new TenantTokenWebController(Customers.Object,Mediator.Object,Mock.Of<IStoreHelper>(),Refresh.Object,fields.Object,Mock.Of<IAntiforgery>(),Config,accessor,Manager.Object,settings);Login=controller.Login;}
            else{var controller=new TokenWebController(Customers.Object,Mediator.Object,Mock.Of<IStoreHelper>(),Refresh.Object,fields.Object,Mock.Of<IAntiforgery>(),Config,Manager.Object,settings);Login=controller.Login;}
        }
    }
}
