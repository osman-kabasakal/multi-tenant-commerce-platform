using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Core.Interfaces.Messages;
using Grand.Data;
using Grand.Domain;
using Grand.Domain.Messages;
using Grand.Infrastructure;
using Grand.Web.Common.Controllers;
using Grand.Web.Common.DataSource;
using Microsoft.AspNetCore.Mvc;

namespace Misc.MobileApp.Controllers;

public class CustomerMessagesController : BasePublicController
{
    private readonly IQueuedEmailService _queuedEmailService;
    private readonly IRepository<QueuedEmail> _queuedEmailRepository;
    private readonly ICustomerService _customerService;
    private readonly IWorkContext _workContext;

    public CustomerMessagesController(
        IQueuedEmailService queuedEmailService,
        IRepository<QueuedEmail> queuedEmailRepository,
        ICustomerService customerService,
        IWorkContext workContext
    )
    {
        _queuedEmailService = queuedEmailService;
        _queuedEmailRepository = queuedEmailRepository;
        _customerService = customerService;
        _workContext = workContext;
    }

    [HttpPost]
    public async Task<IActionResult> UnreadMessages(DataSourceRequest command)
    {
        var customer = _workContext.CurrentCustomer;
        // Get all registered email addresses for the customer (orders, address, registered email)
        var customerEmails = new List<string> { customer.Email };
        if (!string.IsNullOrEmpty(customer.BillingAddress?.Email) &&
            !customerEmails.Contains(customer.BillingAddress.Email))
            customerEmails.Add(customer.BillingAddress.Email);

        if (!string.IsNullOrEmpty(customer.ShippingAddress?.Email) &&
            !customerEmails.Contains(customer.ShippingAddress.Email))
            customerEmails.Add(customer.ShippingAddress.Email);

        if (customer.Addresses is { Count: > 0 })
        {
            customerEmails.AddRange(customer.Addresses
                .Where((a) => !string.IsNullOrEmpty(a.Email) && !customerEmails.Contains(a.Email))
                .Select(a => a.Email));
        }

        // Get unread messages (ReadOnUtc is null) for all customer emails without Body content
        var unreadMessages = _queuedEmailRepository.Table.Where(
            x => !x.ReadOnUtc.HasValue &&
                 customerEmails.Contains(x.To) &&
                 x.CreatedOnUtc> DateTime.UtcNow.AddDays(-7) 
        ).OrderByDescending(qe => qe.CreatedOnUtc).ThenByDescending(qe => qe.PriorityId);


        // Project to simplified model without body content
        var messages = unreadMessages.Select(email => new QueuedEmail {
            Id = email.Id,
            Subject = email.Subject,
            From = email.From,
            To = email.To,
            CreatedOnUtc = email.CreatedOnUtc,
            SentOnUtc = email.SentOnUtc,
        });

        var messagesPagination = await PagedList<QueuedEmail>.Create(messages, command.Page - 1, command.PageSize);
        return Json(new DataSourceResult {
            Data = messagesPagination,
            Total = messagesPagination.TotalCount
        });
    }

    [HttpGet]
    public async Task<IActionResult> GetMessageDetail(string queuedEmailId)
    {
        var customer = _workContext.CurrentCustomer;

        // Get message details including body
        var email = await _queuedEmailService.GetQueuedEmailById(queuedEmailId);
        if (email == null)
            return Json(new { success = false, message = "Message not found" });

        // Verify the email belongs to the current customer
        var customerEmails = new List<string> { customer.Email };
        if (!string.IsNullOrEmpty(customer.BillingAddress?.Email))
            customerEmails.Add(customer.BillingAddress.Email);
        if (!string.IsNullOrEmpty(customer.ShippingAddress?.Email))
            customerEmails.Add(customer.ShippingAddress.Email);

        if (!customerEmails.Contains(email.To))
            return Json(new { success = false, message = "Unauthorized access" });

        // Return message details
        var message = new QueuedEmail{
            Id = email.Id,
            Subject = email.Subject,
            Body = email.Body,
            From = email.From,
            To = email.To,
            CreatedOnUtc = email.CreatedOnUtc,
            SentOnUtc = email.SentOnUtc,
            ReadOnUtc = email.ReadOnUtc,
            Reference = email.Reference
        };

        return Json(new { success = true, message });
    }

    [HttpGet]
    public async Task<IActionResult> SetMessageRead(string queuedEmailId)
    {
        var customer = _workContext.CurrentCustomer;

        // Get the email
        var email = await _queuedEmailService.GetQueuedEmailById(queuedEmailId);
        if (email == null)
            return Json(new { success = false, message = "Message not found" });

        // Verify the email belongs to the current customer
        var customerEmails = new List<string> { customer.Email };
        if (!string.IsNullOrEmpty(customer.BillingAddress?.Email))
            customerEmails.Add(customer.BillingAddress.Email);
        if (!string.IsNullOrEmpty(customer.ShippingAddress?.Email))
            customerEmails.Add(customer.ShippingAddress.Email);

        if (!customerEmails.Contains(email.To))
            return Json(new { success = false, message = "Unauthorized access" });

        // Set as read if not already
        if (!email.ReadOnUtc.HasValue)
        {
            email.ReadOnUtc = DateTime.UtcNow;
            await _queuedEmailService.UpdateQueuedEmail(email);
        }

        return Json(new { success = true });
    }
}