using System;
using System.IO;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using FirebaseAdmin;
using FirebaseAdmin.Auth;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using Grand.Domain.PushNotifications;
using Microsoft.Extensions.Logging;

namespace Grand.Business.Marketing.Services.PushNotifications
{
    public class FirebaseService 
    {
        private readonly ILogger<FirebaseService> _logger;
        private static GoogleCredential _credential;
        private static FirebaseApp _firebaseApp;
        private static SemaphoreSlim _semaphore = new SemaphoreSlim(1, 1);
        private static string _configuredProjectId = null;
        private readonly PushNotificationsSettings _pushNotificationsSettings;
        private bool _initialized = false;

        public FirebaseService(
            ILogger<FirebaseService> logger,
            PushNotificationsSettings pushNotificationsSettings)
        {
            _logger = logger;
            _pushNotificationsSettings = pushNotificationsSettings;
        }

        /// <summary>
        /// Initialize Firebase Admin SDK
        /// </summary>
        public async Task<bool> InitializeFirebaseAdminAsync()
        {
            try
            {
                // Ensure we don't have multiple threads initializing Firebase at the same time
                await _semaphore.WaitAsync();
                
                try
                {
                    // Check if we need to reinitialize
                    if (_firebaseApp != null && _configuredProjectId == _pushNotificationsSettings.ProjectId)
                    {
                        _initialized = true;
                        return true;
                    }
                    
                    // Close any existing app
                    if (_firebaseApp != null)
                    {
                        try
                        {
                            _firebaseApp.Delete();
                        }
                        catch (Exception ex)
                        {
                            _logger.LogWarning(ex, "Error during Firebase app deletion");
                        }
                        _firebaseApp = null;
                    }
                    
                    // No service account JSON provided
                    if (string.IsNullOrEmpty(_pushNotificationsSettings.ServiceAccountJson))
                    {
                        _logger.LogWarning("No Firebase service account JSON provided");
                        return false;
                    }
                    
                    // Create credential from JSON
                    using var stream = new MemoryStream(Encoding.UTF8.GetBytes(_pushNotificationsSettings.ServiceAccountJson));
                    _credential = GoogleCredential.FromStream(stream)
                        .CreateScoped("https://www.googleapis.com/auth/firebase.messaging");
                    
                    // Initialize the app with admin credentials
                    var options = new AppOptions
                    {
                        Credential = _credential,
                        ProjectId = _pushNotificationsSettings.ProjectId
                    };
                    
                    _firebaseApp = FirebaseApp.Create(options);
                    _configuredProjectId = _pushNotificationsSettings.ProjectId;
                    _initialized = true;
                    
                    _logger.LogInformation("Firebase Admin SDK initialized successfully");
                    return true;
                }
                finally
                {
                    _semaphore.Release();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error initializing Firebase Admin SDK");
                return false;
            }
        }

        /// <summary>
        /// Get an OAuth2 access token for the Firebase Admin SDK
        /// </summary>
        public async Task<string> GetAccessTokenAsync()
        {
            if (!_initialized)
            {
                var initialized = await InitializeFirebaseAdminAsync();
                if (!initialized)
                    return null;
            }
            
            try
            {
                var accountJson = JsonSerializer.Deserialize<dynamic>( _pushNotificationsSettings.ServiceAccountJson);
                var token = await ((ITokenAccess)_credential).GetAccessTokenForRequestAsync();
                return token;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting Firebase access token");
                return null;
            }
        }
        
        /// <summary>
        /// Send a message directly using Firebase Admin SDK
        /// </summary>
        public async Task<string> SendMessageAsync(Message message)
        {
            if (!_initialized)
            {
                var initialized = await InitializeFirebaseAdminAsync();
                if (!initialized)
                    return null;
            }
            
            try
            {
                var response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
                return response;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending Firebase message");
                return null;
            }
        }
        
        
        /// <summary>
        /// Send miltixast messages
        /// </summary>
        public async Task<int> SendMultiCastMessageAsync(MulticastMessage message)
        {
            if (!_initialized)
            {
                var initialized = await InitializeFirebaseAdminAsync();
                if (!initialized)
                    return 0;
            }
            
            try
            {
                var response = await FirebaseMessaging.DefaultInstance.SendEachForMulticastAsync(message);
                return response.SuccessCount;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending Firebase message");
                return 0;
            }
        }
    }
}