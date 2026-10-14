using Grand.Business.Core.Events.Customers;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Catalog.Discounts;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Data;
using Grand.Domain.Customers;
using Grand.Domain.Discounts;
using Grand.Domain.Orders;
using Grand.Domain.Stores;
using Grand.Infrastructure.Events;
using MediatR;
using Microsoft.Extensions.Logging;
using Misc.MobileApp.Domain.GeneratedDiscountCoupon;
using Misc.MobileApp.Services;
using MongoDB.Driver.Linq;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace Misc.MobileApp.Events;

public class NewCustomerForDiscountCouponCodeEvent(
    SendCouponCodeNotificationSettings sendCouponCodeNotificationSettings,
    IDiscountService discountService,
    IRepository<DiscountUsageHistory> discountUsageHistoryRepository,
    IRepository<GeneratedDiscountCouponForPhoneNumber> generatedDiscountCouponForPhoneNumberRepository,
    IDateTimeService dateTimeService,
    IUserFieldService userFieldService,
    ICustomerService customerService,
    IGroupService groupService,
    ILogger<NewCustomerForDiscountCouponCodeEvent> logger,
    ISmsProviderFactory smsProviderFactory,
    IRepository<Store> storeRepository) : INotificationHandler<CustomerRegisteredEvent>
{
    public async Task Handle(CustomerRegisteredEvent notification, CancellationToken cancellationToken)
    {
        try
        {
            if (string.IsNullOrEmpty(sendCouponCodeNotificationSettings.DiscountId) ||
                string.IsNullOrEmpty(sendCouponCodeNotificationSettings.TwilioAccountSid) ||
                string.IsNullOrEmpty(sendCouponCodeNotificationSettings.TwilioAuthToken) ||
                string.IsNullOrEmpty(sendCouponCodeNotificationSettings.TwilioPhoneNumber) ||
                notification.Customer == null
               )
            {
                return;
            }

            if ((await groupService.IsGuest(notification.Customer)))
            {
                return;
            }

            var discount = await discountService.GetDiscountById(sendCouponCodeNotificationSettings.DiscountId);
            if (discount == null)
            {
                return;
            }

            if (!discount.RequiresCouponCode)
            {
                return;
            }

            if (discount.DiscountLimitationId == DiscountLimitationType.NTimes)
            {
                var discountUsageHistoryCount =
                    discountUsageHistoryRepository.Table.Count(x => x.DiscountId == discount.Id);
                if (discountUsageHistoryCount >= discount.LimitationTimes)
                {
                    return;
                }
            }

            var customer = notification.Customer;
            var phoneNumber = (await customer.GetUserField<string>(userFieldService, SystemCustomerFieldNames.Phone));

            if (string.IsNullOrEmpty(phoneNumber))
            {
                return;
            }

            var customerPhones = new List<string> { phoneNumber };
            if (!string.IsNullOrEmpty(customer.BillingAddress?.PhoneNumber) &&
                !customerPhones.Contains(customer.BillingAddress.PhoneNumber))
                customerPhones.Add(customer.BillingAddress.PhoneNumber);

            if (!string.IsNullOrEmpty(customer.ShippingAddress?.PhoneNumber) &&
                !customerPhones.Contains(customer.ShippingAddress.PhoneNumber))
                customerPhones.Add(customer.ShippingAddress.PhoneNumber);

            if (customer.Addresses is { Count: > 0 })
            {
                customerPhones.AddRange(customer.Addresses
                    .Where((a) => !string.IsNullOrEmpty(a.PhoneNumber) && !customerPhones.Contains(a.PhoneNumber))
                    .Select(a => a.PhoneNumber));
            }

            if (!string.IsNullOrEmpty(phoneNumber) && customerPhones.Count == 0)
            {
                return;
            }

            if (generatedDiscountCouponForPhoneNumberRepository.Table.Any(x =>
                    customerPhones.Contains(x.PhoneNumber) && x.DiscountId == discount.Id))
            {
                return;
            }
            
            var smsProvider = smsProviderFactory.GetSmsProvider(sendCouponCodeNotificationSettings);
            if (smsProvider == null)
            {
                logger.LogError("SMS provider not found for sending coupon code.");
                return;
            }


            var couponCode = new DiscountCoupon() {
                CouponCode = GetCouponCode(customer, phoneNumber: phoneNumber),
                DiscountId = discount.Id,
            };
            var existCouponCOde = await discountService.GetDiscountByCouponCode(couponCode.CouponCode);
            if (existCouponCOde == null)
            {
                await discountService.InsertDiscountCoupon(couponCode);
            }
            else
            {
                var allCouponCodes = await discountService.GetAllCouponCodesByDiscountId(discount.Id);
                couponCode = allCouponCodes.FirstOrDefault(x=>x.CouponCode==couponCode.CouponCode);
                if (couponCode.Used)
                {
                    return;
                }
            }

            
            var generatedDiscountCouponForPhoneNumber = new GeneratedDiscountCouponForPhoneNumber() {
                CouponCodeId = couponCode.Id,
                DiscountId = discount.Id,
                PhoneNumber = phoneNumber,
                CustomerId = notification.Customer.Id
            };

            await generatedDiscountCouponForPhoneNumberRepository.InsertAsync(generatedDiscountCouponForPhoneNumber);
            
            var normalizeToNumber = Regex.Replace(phoneNumber, @"[^\d]", "");
            var store = await storeRepository.Table.FirstOrDefaultAsync();
            var message = $"{store?.CompanyName}'dan HOŞGELDİNİZ HEDİYESİ! \n\n" +
                          $"İlk alışverişinize özel {(discount.UsePercentage ? $"{discount.DiscountPercentage}%" : $"{discount.DiscountAmount} TL")} indirim!\n\n" +
                          $"KUPON KODUNUZ:\n" +
                          $">>> {couponCode.CouponCode} <<<\n\n" +
                          $"Hemen kullanmak için: {store.Domains.FirstOrDefault(x => x.Primary)?.Url}\n\n" +
                          $"Bu özel fırsat sadece size özel ve sınırlı süre için geçerlidir.";
            
            await smsProvider.SendSmsAsync(normalizeToNumber, message);
        }
        catch (Exception e)
        {
            logger.LogError(e,"Error while sending coupon code");
        }
    }
    
    

    private string GetCouponCode(Customer customer, string phoneNumber)
    {
        var digitsOnly = Regex.Replace(phoneNumber, @"[^\d]", "");
        var last4Digits = digitsOnly.Substring(Math.Max(0, digitsOnly.Length - 4));
        var couponCode = $"{Random.Shared.Next(1000,9999)}{last4Digits}";
        return couponCode;
    }
}