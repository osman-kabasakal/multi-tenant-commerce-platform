using Grand.Business.Common.Services.Security;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Customers.Services;
using Grand.Domain.Customers;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;

namespace CustomerToken.Tests;

[TestClass]
public sealed class PasswordPolicyCompatibilityTests
{
    [DataTestMethod]
    [DataRow(HashedPasswordFormat.SHA1)]
    [DataRow(HashedPasswordFormat.SHA256)]
    [DataRow(HashedPasswordFormat.SHA384)]
    [DataRow(HashedPasswordFormat.SHA512)]
    public async Task ExistingPasswordAndHistoryStillVerifyAfterTheDefaultBecomesSha512(HashedPasswordFormat storedFormat)
    {
        var encryption=new EncryptionService();const string password="Synthetic-İstanbul-Fixture";const string salt="fixture-salt";
        var hash=encryption.CreatePasswordHash(password,salt,storedFormat);
        var customer=new Grand.Domain.Customers.Customer{Email="fixture@example.test",Password=hash,PasswordSalt=salt,PasswordFormatId=PasswordFormat.Hashed};
        var service=new Mock<ICustomerService>();service.Setup(x=>x.GetCustomerByEmail(customer.Email)).ReturnsAsync(customer);
        var manager=new CustomerManagerService(service.Object,null!,encryption,null!,null!,null!,new CustomerSettings{HashedPasswordFormat=HashedPasswordFormat.SHA512});
        Assert.AreEqual(CustomerLoginResults.Successful,await manager.LoginCustomer(customer.Email,password));
        Assert.AreEqual(CustomerLoginResults.WrongPassword,await manager.LoginCustomer(customer.Email,password+"-wrong"));
        Assert.IsTrue(manager.PasswordMatch(PasswordFormat.Hashed,hash,password,salt));
        Assert.IsFalse(manager.PasswordMatch(PasswordFormat.Hashed,hash,password,salt+"-wrong"));
        Assert.AreEqual(hash,customer.Password,"Compatibility must not replace or reset the stored password.");
        service.Verify(x=>x.UpdateCustomer(It.IsAny<Grand.Domain.Customers.Customer>()),Times.Never);
    }
    [TestMethod]
    public void NewHashesUseTheCurrentSha512PolicyAndMalformedDigestsDoNotSelectALegacyFormat()
    {
        var encryption=new EncryptionService();
        var hash=encryption.CreatePasswordHash("Synthetic-Fixture","fixture-salt",HashedPasswordFormat.SHA512);
        Assert.AreEqual(128,hash.Length);Assert.AreEqual(HashedPasswordFormat.SHA512,CustomerPasswordHash.StoredFormat(hash,HashedPasswordFormat.SHA1));
        Assert.AreEqual(HashedPasswordFormat.SHA512,CustomerPasswordHash.StoredFormat(new string('z',40),HashedPasswordFormat.SHA512));
        Assert.AreEqual(HashedPasswordFormat.SHA512,CustomerPasswordHash.StoredFormat("",HashedPasswordFormat.SHA512));
    }
}
