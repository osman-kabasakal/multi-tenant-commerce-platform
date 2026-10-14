using FirebaseAdmin.Messaging;
using Grand.Business.Core.Interfaces.Marketing.PushNotifications;
using Grand.Business.Marketing.Utilities;
using Grand.Data;
using Grand.Domain;
using Grand.Domain.PushNotifications;
using Grand.Infrastructure.Extensions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Action = FirebaseAdmin.Messaging.Action;
using Message = FirebaseAdmin.Messaging.Message;

namespace Grand.Business.Marketing.Services.PushNotifications;

public class PushNotificationsService : IPushNotificationsService
{
    private const string FcmUrl = "https://fcm.googleapis.com/v1/projects/{0}/messages:send";
    private readonly HttpClient _httpClient;
    private readonly ILogger<PushNotificationsService> _logger;
    private readonly IMediator _mediator;
    private readonly IRepository<PushMessage> _pushMessagesRepository;
    private readonly PushNotificationsSettings _pushNotificationsSettings;
    private readonly IRepository<PushRegistration> _pushRegistrationRepository;
    private readonly FirebaseService _firebaseService;

    public PushNotificationsService(
        IRepository<PushRegistration> pushRegistrationRepository,
        IRepository<PushMessage> pushMessagesRepository,
        IMediator mediator,
        PushNotificationsSettings pushNotificationsSettings,
        ILogger<PushNotificationsService> logger,
        HttpClient httpClient,
        FirebaseService firebaseService)
    {
        _pushRegistrationRepository = pushRegistrationRepository;
        _pushMessagesRepository = pushMessagesRepository;
        _mediator = mediator;
        _pushNotificationsSettings = pushNotificationsSettings;
        _logger = logger;
        _httpClient = httpClient;
        _firebaseService = firebaseService;
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
        var tokens = new List<string>();

        if (registrationIds != null && registrationIds.Any())
        {
            tokens = registrationIds;
        }
        else
        {
            var receivers = await GetPushReceivers();
            if (!receivers.Any()) return (false, "Admin.PushNotifications.Error.NoReceivers");

            const int batchSize = 1000;
            for (var batch = 0;
                 batch <= Math.Round((double)(receivers.Count / batchSize), 0, MidpointRounding.ToEven);
                 batch++)
            {
                var t = receivers.Skip(batch * batchSize).Take(batchSize);
                foreach (var receiver in receivers.Where(receiver => !tokens.Contains(receiver.Token)))
                    tokens.Add(receiver.Token);
            }
        }

        var successCount = 0;

        try
        {
            if (_pushNotificationsSettings.UseHttpV1Api &&
                !string.IsNullOrEmpty(_pushNotificationsSettings.ServiceAccountJson))
            {
                // Get Firebase access token using service account
                var accessToken = await _firebaseService.GetAccessTokenAsync();

                if (string.IsNullOrEmpty(accessToken))
                {
                    _logger.LogError("Failed to obtain Firebase access token");
                    return (false, "Admin.PushNotifications.Error.FailedToObtainToken");
                }

                var multicastMessage = new MulticastMessage {
                        Tokens = tokens,
                        Data = new Dictionary<string, string>() {
                            {"action_link",clickUrl}
                        },
                        Notification = new Notification() {
                            Title = title,
                            Body = text,
                        },
                        Android = new AndroidConfig() {
                            Notification = new AndroidNotification() {
                                Body = text,
                                Title = title,
                                DefaultSound = true,
                                ChannelId = "high_importance_channel",
                            }
                        },
                    Apns = new ApnsConfig {
                        Headers = new Dictionary<string, string>() {
                            { "apns-priority", "10" }
                        },
                        Aps = new Aps {
                            Alert = new ApsAlert {
                                Title = title,
                                Body = text,
                            },
                            Sound = "default",
                            MutableContent = true,
                            ContentAvailable = true,
                        },
                    }
                };

                successCount= await _firebaseService.SendMultiCastMessageAsync(multicastMessage);
            }
            else
            {
                // Use legacy FCM API
                var data = new {
                    registration_ids = tokens,
                    notification = new {
                        body = text,
                        title,
                        icon = pictureUrl,
                        click_action = clickUrl
                    },
                    apns = new {
                        payload = new {
                            aps = new {
                                alert = new {
                                    title = title,
                                    body = text
                                },
                                sound = "default",
                                badge = 1,
                                mutable_content = true,
                                category = "NEW_MESSAGE_CATEGORY"
                            },
                            url = clickUrl
                        },
                        fcm_options = new {
                            image = pictureUrl
                        }
                    }
                };

                var json = JsonSerializer.Serialize(data);

                using var httpRequest = new HttpRequestMessage(HttpMethod.Post, "https://fcm.googleapis.com/fcm/send");
                httpRequest.Headers.Add("Authorization", $"key={_pushNotificationsSettings.PrivateApiKey}");
                httpRequest.Headers.Add("Sender", $"id={_pushNotificationsSettings.SenderId}");
                httpRequest.Content = new StringContent(json, Encoding.UTF8, "application/json");

                using var response = await _httpClient.SendAsync(httpRequest);
                var responseString = await response.Content.ReadAsStringAsync();
                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogError("Error occured while sending push notification {ResponseString}", responseString);
                    return (false, responseString);
                }

                var responseMessage = JsonSerializer.Deserialize<JsonResponse>(responseString);
                if (responseMessage == null) return (false, "PushNotifications.ResponseMessage.Empty");
                successCount = responseMessage.success;
            }

            if (successCount == 0)
            {
                return (false, "Admin.PushNotifications.Error.NoSuccessfulDeliveries");
            }

            await InsertPushMessage(new PushMessage {
                NumberOfReceivers = successCount,
                SentOn = DateTime.UtcNow,
                Text = text,
                Title = title
            });

            return (true, "Admin.PushNotifications.MessageSent");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception when sending push notifications");
            return (false, ex.Message);
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
        if (receiver == null)
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