using Grand.Business.Core.Interfaces.Marketing.PushNotifications;
using Grand.Data;
using Grand.Domain;
using Grand.Domain.PushNotifications;
using Grand.Infrastructure.Extensions;
using MediatR;
using Microsoft.AspNetCore.Http;
using Grand.Infrastructure.MultiTenant;
using Platform.Notifications;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Grand.Business.Marketing.Services.PushNotifications;

public class PushNotificationsService : IPushNotificationsService
{
    private readonly ILogger<PushNotificationsService> _logger;
    private readonly IMediator _mediator;
    private readonly IRepository<PushMessage> _pushMessagesRepository;
    private readonly IRepository<PushRegistration> _pushRegistrationRepository;
    private readonly ITenantPushSender _sender;
    private readonly ITenantIdentityAccessor _tenant;
    private readonly IHttpContextAccessor _context;

    public PushNotificationsService(
        IRepository<PushRegistration> pushRegistrationRepository,
        IRepository<PushMessage> pushMessagesRepository,
        IMediator mediator,
        ILogger<PushNotificationsService> logger,
        ITenantPushSender sender,
        ITenantIdentityAccessor tenant,
        IHttpContextAccessor context)
    {
        _pushRegistrationRepository = pushRegistrationRepository;
        _pushMessagesRepository = pushMessagesRepository;
        _mediator = mediator;
        _logger = logger;
        _sender = sender;
        _tenant = tenant;
        _context = context;
    }

    /// <summary>
    ///     Inserts push receiver
    /// </summary>
    /// <param name="registration"></param>
    public virtual async Task InsertPushReceiver(PushRegistration registration)
    {
        await _pushRegistrationRepository.InsertAsync(registration);

        await _mediator.EntityInserted(registration);
    }

    /// <summary>
    ///     Deletes push receiver
    /// </summary>
    /// <param name="registration"></param>
    public virtual async Task DeletePushReceiver(PushRegistration registration)
    {
        await _pushRegistrationRepository.DeleteAsync(registration);
        await _mediator.EntityDeleted(registration);
    }

    /// <summary>
    ///     Gets push receiver
    /// </summary>
    /// <param name="customerId"></param>
    public virtual async Task<PushRegistration> GetPushReceiverByCustomerId(string customerId)
    {
        return await Task.FromResult(_pushRegistrationRepository.Table.FirstOrDefault(x => x.CustomerId == customerId));
    }

    /// <summary>
    ///     Updates push receiver
    /// </summary>
    /// <param name="registration"></param>
    public virtual async Task UpdatePushReceiver(PushRegistration registration)
    {
        await _pushRegistrationRepository.UpdateAsync(registration);
        await _mediator.EntityUpdated(registration);
    }

    /// <summary>
    ///     Gets all push receivers
    /// </summary>
    public virtual async Task<List<PushRegistration>> GetPushReceivers()
    {
        return await Task.FromResult(_pushRegistrationRepository.Table.Where(x => x.Allowed).ToList());
    }

    /// <summary>
    ///     Gets number of customers that accepted push notifications permission popup
    /// </summary>
    public virtual async Task<int> GetAllowedReceivers()
    {
        return await Task.FromResult(_pushRegistrationRepository.Table.Count(x => x.Allowed));
    }

    /// <summary>
    ///     Gets number of customers that denied push notifications permission popup
    /// </summary>
    public virtual async Task<int> GetDeniedReceivers()
    {
        return await Task.FromResult(_pushRegistrationRepository.Table.Count(x => !x.Allowed));
    }

    /// <summary>
    ///     Inserts push message
    /// </summary>
    /// <param name="message"></param>
    public virtual async Task InsertPushMessage(PushMessage message)
    {
        await _pushMessagesRepository.InsertAsync(message);
        await _mediator.EntityInserted(message);
    }

    /// <summary>
    ///     Gets all push messages
    /// </summary>
    public virtual async Task<IPagedList<PushMessage>> GetPushMessages(int pageIndex = 0, int pageSize = int.MaxValue)
    {
        var query = _pushMessagesRepository.Table.OrderByDescending(x => x.SentOn);
        return await Task.FromResult(new PagedList<PushMessage>(query, pageIndex, pageSize));
    }

    /// <summary>
    ///     Gets all push receivers
    /// </summary>
    public virtual async Task<IPagedList<PushRegistration>> GetPushReceivers(int pageIndex = 0,
        int pageSize = int.MaxValue)
    {
        var query = _pushRegistrationRepository.Table.OrderByDescending(x => x.RegisteredOn);
        return await Task.FromResult(new PagedList<PushRegistration>(query, pageIndex, pageSize));
    }

    /// <summary>
    ///     Sends push notification to all receivers
    /// </summary>
    /// <param name="title"></param>
    /// <param name="text"></param>
    /// <param name="pictureUrl"></param>
    /// <param name="registrationIds"></param>
    /// <param name="clickUrl"></param>
    /// <returns>Bool indicating whether message was sent successfully and string result to display</returns>
    public virtual async Task<(bool, string)> SendPushNotification(string title, string text, string pictureUrl,
        string clickUrl, List<string> registrationIds = null)
    {
        var tenant = _context.HttpContext is { } http ? http.GetTenantId() : _tenant.TenantId;
        if (string.IsNullOrWhiteSpace(tenant))
            return (false, "Admin.PushNotifications.Error.MissingTenant");
        var tokens = registrationIds?.Where(t => !string.IsNullOrWhiteSpace(t) && t != "[DENIED]").Distinct().ToList();
        if (tokens == null)
            tokens = (await GetPushReceivers()).Where(r => r.Allowed && !string.IsNullOrWhiteSpace(r.Token) && r.Token != "[DENIED]")
                .Select(r => r.Token).Distinct().ToList();
        if (tokens.Count == 0) return (false, "Admin.PushNotifications.Error.NoReceivers");
        var successCount = 0;
        try
        {
            foreach (var batch in tokens.Chunk(500))
            {
                var receipt = await _sender.SendAsync(tenant, batch,
                    new TenantPushMessage(title, text, pictureUrl, clickUrl));
                successCount += receipt.Accepted;
            }
            if (successCount == 0) return (false, "Admin.PushNotifications.Error.NoSuccessfulDeliveries");
            await InsertPushMessage(new PushMessage {
                NumberOfReceivers = successCount, SentOn = DateTime.UtcNow, Text = text, Title = title
            });
            return (true, "Admin.PushNotifications.MessageSent");
        }
        catch (Exception error)
        {
            _logger.LogWarning("Tenant push notification failed ({ErrorType}).", error.GetType().Name);
            return (false, "Admin.PushNotifications.Error.SendFailed");
        }
    }

    /// <summary>
    ///     Sends push notification to specified customer
    /// </summary>
    /// <param name="title"></param>
    /// <param name="text"></param>
    /// <param name="pictureUrl"></param>
    /// <param name="customerId"></param>
    /// <param name="clickUrl"></param>
    /// <returns>Bool indicating whether message was sent successfully and string result to display</returns>
    public virtual async Task<(bool, string)> SendPushNotification(string title, string text, string pictureUrl,
        string customerId, string clickUrl)
    {
        var receiver = await GetPushReceiverByCustomerId(customerId);
        if (receiver == null || !receiver.Allowed || string.IsNullOrWhiteSpace(receiver.Token) || receiver.Token == "[DENIED]")
            return (false, "Admin.PushNotifications.Error.CustomerNotFound");

        return await SendPushNotification(title, text, pictureUrl, clickUrl,
            new List<string> { receiver.Token });
    }

    /// <summary>
    ///     Gets all push receivers
    /// </summary>
    /// <param name="id">Ident</param>
    public virtual Task<PushRegistration> GetPushReceiver(string id)
    {
        return _pushRegistrationRepository.GetByIdAsync(id);
    }
}