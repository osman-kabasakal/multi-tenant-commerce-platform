using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Api.Gax.ResourceNames;
using Google.Apis.Auth.OAuth2;
using Google.Apis.FirebaseAppDistribution.v1;
using Google.Apis.FirebaseManagement.v1beta1;
using Google.Apis.FirebaseManagement.v1beta1.Data;
using Google.Apis.Services;
using TenantManager.Models;

namespace TenantManager
{
    public class FirebaseSetupManager : IFirebaseSetupManager
    {
        private GoogleCredential _credential;
        private string _projectId;
        private FirebaseManagementService _firebaseManagementService;
        private HttpClient _httpClient;

        /// <summary>
        /// Firebase Kurulum Yöneticisini başlatır
        /// </summary>
        /// <param name="serviceAccountPath">Service Account anahtar dosyasının yolu</param>
        /// <param name="projectId">Google Cloud Proje ID'si</param>
        public FirebaseSetupManager(GoogleCredential credential, string projectId)
        {
            // Service account kimlik bilgilerini yükle
            _credential = credential
                .CreateScoped(new[]
                {
                    "https://www.googleapis.com/auth/cloud-platform",
                    "https://www.googleapis.com/auth/firebase"
                });

            _projectId = projectId;

            // Firebase Yönetim API'sini başlat
            _firebaseManagementService = new FirebaseManagementService(new BaseClientService.Initializer
            {
                HttpClientInitializer = _credential,
                ApplicationName = "FirebaseSetupApp"
            });

            // API istekleri için HTTP istemcisini yapılandır
            _httpClient = new HttpClient();
        }

        /// <summary>
        /// Mevcut Google Cloud projesine Firebase ekler
        /// </summary>
        public async Task<bool> AddFirebaseToProjectAsync()
        {
            try
            {
                Console.WriteLine($"Firebase, {_projectId} projesine ekleniyor...");

                // Firebase REST API'sini kullanarak projeye Firebase ekleme
                var firebaseRequest = await _firebaseManagementService.Projects.AddFirebase(new AddFirebaseRequest(),
                    ProjectName.Format(_projectId)).ExecuteAsync();

                if (await WaitForOperationCompletionAsync(firebaseRequest.Name))
                {
                    Console.WriteLine("Firebase başarıyla eklendi!");
                    return true;
                }
                else
                {
                    Console.WriteLine($"Firebase eklenemedi. Hata:");
                    return false;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Firebase eklenirken hata oluştu: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Firebase projesine Android uygulaması ekler
        /// </summary>
        /// <param name="packageName">Android uygulama paket adı</param>
        /// <param name="displayName">Uygulama görünür adı</param>
        /// <returns>Android uygulamasının yapılandırma bilgileri</returns>
        public async Task<AndroidAppConfig> AddAndroidAppAsync(string packageName, string displayName)
        {
            try
            {
                Console.WriteLine($"Android uygulaması ekleniyor: {packageName}");

                // Android uygulaması eklemek için API isteği
                // var accessToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
                // var url = $"https://firebase.googleapis.com/v1beta1/projects/{_projectId}/androidApps";

                var listAndroidAppRequest =
                    _firebaseManagementService.Projects.AndroidApps.List(ProjectName.Format(_projectId));
                var listAndroidAppResponse = await listAndroidAppRequest.ExecuteAsync();
                if (listAndroidAppResponse.Apps is { Count: > 0 })
                {
                    foreach (var app in listAndroidAppResponse.Apps)
                    {
                        if (app.PackageName == packageName)
                        {
                            return await GetAndroidAppConfigAsync(app.AppId);
                        }
                    }
                }

                var createAndroidAppRequest = new AndroidApp()
                {
                    PackageName = packageName,
                    DisplayName = displayName,
                };

                var createRequest =
                    _firebaseManagementService.Projects.AndroidApps.Create(createAndroidAppRequest,
                        ProjectName.Format(_projectId));
                var response = await createRequest.ExecuteAsync();

                if (response.Error == null || response.Error.Code == 0)
                {
                    // Operasyon adını al
                    string operationName = response.Name;

                    // Operasyon tamamlanana kadar bekle
                    await WaitForOperationCompletionAsync(operationName);

                    // App ID'yi al
                    var appId = await GetAndroidAppIdAsync(packageName);
                    if (string.IsNullOrEmpty(appId))
                    {
                        throw new Exception("Android uygulama ID'si alınamadı");
                    }

                    // Yapılandırma dosyasını al
                    var config = await GetAndroidAppConfigAsync(appId);
                    Console.WriteLine($"Android uygulaması başarıyla eklendi. App ID: {appId}");

                    return config;
                }
                else
                {
                    var errorContent = response.Error.Message;
                    Console.WriteLine($"Android uygulaması eklenemedi. Hata: {errorContent}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Android uygulaması eklenirken hata oluştu: {ex.Message}");
                return null;
            }
        }

        public async Task<AndroidAppConfig?> GetAndroidConfig(string packageName)
        {
            var listAndroidAppRequest =
                _firebaseManagementService.Projects.AndroidApps.List(ProjectName.Format(_projectId));
            var listAndroidAppResponse = await listAndroidAppRequest.ExecuteAsync();
            if (listAndroidAppResponse.Apps is not { Count: > 0 }) return null;
            foreach (var app in listAndroidAppResponse.Apps)
            {
                if (app.PackageName == packageName)
                {
                    return await GetAndroidAppConfigAsync(app.AppId);
                }
            }

            return null;
        }

        public async Task<IosAppConfig?> GetIosConfig(string packageName)
        {
            var appId = await GetIosAppIdAsync(packageName);
            return await GetIosAppConfigAsync(appId);
        }

        /// <summary>
        /// Firebase projesine iOS uygulaması ekler
        /// </summary>
        /// <param name="bundleId">iOS uygulama bundle ID</param>
        /// <param name="displayName">Uygulama görünür adı</param>
        /// <param name="appStoreId">App Store ID (isteğe bağlı)</param>
        /// <returns>iOS uygulamasının yapılandırma bilgileri</returns>
        public async Task<IosAppConfig> AddIosAppAsync(string bundleId, string displayName, string teamId,
            string appStoreId = null)
        {
            try
            {
                Console.WriteLine($"iOS uygulaması ekleniyor: {bundleId}");

                // iOS uygulaması eklemek için API isteği
                var accessToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
                var url = $"https://firebase.googleapis.com/v1beta1/projects/{_projectId}/iosApps";

                var existingAppId = await GetIosAppIdAsync(bundleId);
                if (!string.IsNullOrEmpty(existingAppId))
                {
                    return await GetIosAppConfigAsync(existingAppId);
                }

                var appData = new Dictionary<string, string>
                {
                    { "bundleId", bundleId },
                    { "displayName", displayName },
                    { "teamId", teamId }
                };

                if (!string.IsNullOrEmpty(appStoreId))
                {
                    appData.Add("appStoreId", appStoreId);
                }

                var content = new StringContent(
                    JsonSerializer.Serialize(appData),
                    Encoding.UTF8,
                    "application/json");

                var request = new HttpRequestMessage(HttpMethod.Post, url) { Content = content };
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                var response = await _httpClient.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var responseData = JsonSerializer.Deserialize<Dictionary<string, object>>(responseContent);

                    // Operasyon adını al
                    string operationName = responseData["name"].ToString();

                    // Operasyon tamamlanana kadar bekle
                    await WaitForOperationCompletionAsync(operationName);

                    // App ID'yi al
                    var appId = await GetIosAppIdAsync(bundleId);
                    if (string.IsNullOrEmpty(appId))
                    {
                        throw new Exception("iOS uygulama ID'si alınamadı");
                    }

                    // Yapılandırma dosyasını al
                    var config = await GetIosAppConfigAsync(appId);
                    Console.WriteLine($"iOS uygulaması başarıyla eklendi. App ID: {appId}");

                    return config;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"iOS uygulaması eklenemedi. Hata: {errorContent}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"iOS uygulaması eklenirken hata oluştu: {ex.Message}");
                return null;
            }
        }

        /// <summary>
        /// iOS uygulaması için APNs Authentication Key ekler
        /// </summary>
        /// <param name="iosAppId">iOS uygulama ID'si</param>
        /// <param name="apnsKeyPath">APNs p8 key dosya yolu</param>
        /// <param name="apnsKeyId">APNs Key ID</param>
        /// <param name="teamId">Apple Developer Team ID</param>
        /// <returns>İşlemin başarılı olup olmadığı</returns>
        public async Task<bool> AddApnsKeyToIosAppAsync(string iosAppId, string apnsKeyPath, string apnsKeyId,
            string teamId)
        {
            try
            {
                Console.WriteLine($"iOS uygulamasına APNs Authentication Key ekleniyor...");

                // APNs key dosyasını oku
                if (!File.Exists(apnsKeyPath))
                {
                    throw new FileNotFoundException($"APNs key dosyası bulunamadı: {apnsKeyPath}");
                }

                string apnsKeyContent = await File.ReadAllTextAsync(apnsKeyPath);

                // APNs key'i Firebase'e yükle
                var accessToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
                var url =
                    $"https://firebase.googleapis.com/v1beta1/projects/{_projectId}/iosApps/{iosAppId}:uploadApnsCredential";

                var requestData = new
                {
                    apnsCredential = new
                    {
                        keyCredential = new
                        {
                            privateKey = apnsKeyContent,
                            keyId = apnsKeyId,
                            teamId = teamId
                        }
                    }
                };

                var content = new StringContent(
                    JsonSerializer.Serialize(requestData),
                    Encoding.UTF8,
                    "application/json");

                var request = new HttpRequestMessage(HttpMethod.Post, url) { Content = content };
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                var response = await _httpClient.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var responseData = JsonSerializer.Deserialize<Dictionary<string, object>>(responseContent);

                    // Operasyon adını al (varsa)
                    if (responseData.ContainsKey("name"))
                    {
                        string operationName = responseData["name"].ToString();
                        await WaitForOperationCompletionAsync(operationName);
                    }

                    Console.WriteLine("APNs Authentication Key başarıyla eklendi!");
                    return true;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"APNs Authentication Key eklenemedi. Hata: {errorContent}");
                    return false;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"APNs Authentication Key eklenirken hata oluştu: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// iOS uygulamasına APNs sertifikası ekler (alternatif yöntem)
        /// </summary>
        /// <param name="iosAppId">iOS uygulama ID'si</param>
        /// <param name="p12CertPath">p12 sertifika dosya yolu</param>
        /// <param name="p12Password">p12 sertifika şifresi</param>
        /// <returns>İşlemin başarılı olup olmadığı</returns>
        public async Task<bool> AddApnsCertificateToIosAppAsync(string iosAppId, string p12CertPath, string p12Password)
        {
            try
            {
                Console.WriteLine($"iOS uygulamasına APNs sertifikası ekleniyor...");

                // p12 sertifika dosyasını oku
                if (!File.Exists(p12CertPath))
                {
                    throw new FileNotFoundException($"APNs sertifika dosyası bulunamadı: {p12CertPath}");
                }

                byte[] certBytes = await File.ReadAllBytesAsync(p12CertPath);
                string certBase64 = Convert.ToBase64String(certBytes);

                // APNs sertifikayı Firebase'e yükle
                var accessToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
                var url =
                    $"https://firebase.googleapis.com/v1beta1/projects/{_projectId}/iosApps/{iosAppId}:uploadApnsCredential";

                var requestData = new
                {
                    apnsCredential = new
                    {
                        certificateCredential = new
                        {
                            certificate = certBase64,
                            password = p12Password
                        }
                    }
                };

                var content = new StringContent(
                    JsonSerializer.Serialize(requestData),
                    Encoding.UTF8,
                    "application/json");

                var request = new HttpRequestMessage(HttpMethod.Post, url) { Content = content };
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                var response = await _httpClient.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var responseData = JsonSerializer.Deserialize<Dictionary<string, object>>(responseContent);

                    // Operasyon adını al (varsa)
                    if (responseData.ContainsKey("name"))
                    {
                        string operationName = responseData["name"].ToString();
                        await WaitForOperationCompletionAsync(operationName);
                    }

                    Console.WriteLine("APNs sertifikası başarıyla eklendi!");
                    return true;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"APNs sertifikası eklenemedi. Hata: {errorContent}");
                    return false;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"APNs sertifikası eklenirken hata oluştu: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Mevcut APNs yapılandırmasını kontrol eder
        /// </summary>
        /// <param name="iosAppId">iOS uygulama ID'si</param>
        /// <returns>APNs yapılandırmasının durumu</returns>
        public async Task<ApnsConfigStatus> GetApnsConfigStatusAsync(string iosAppId)
        {
            try
            {
                var accessToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
                var url = $"https://firebase.googleapis.com/v1beta1/projects/{_projectId}/iosApps/{iosAppId}";

                var request = new HttpRequestMessage(HttpMethod.Get, url);
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                var response = await _httpClient.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var appData = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(content);

                    var status = new ApnsConfigStatus();

                    if (appData.ContainsKey("apnsCredential"))
                    {
                        var apnsCredential = appData["apnsCredential"];

                        if (apnsCredential.TryGetProperty("keyCredential", out var keyCredential))
                        {
                            status.HasApnsKey = true;
                            if (keyCredential.TryGetProperty("keyId", out var keyId))
                            {
                                status.ApnsKeyId = keyId.GetString();
                            }

                            if (keyCredential.TryGetProperty("teamId", out var teamId))
                            {
                                status.TeamId = teamId.GetString();
                            }
                        }

                        if (apnsCredential.TryGetProperty("certificateCredential", out var certCredential))
                        {
                            status.HasApnsCertificate = true;
                        }
                    }

                    return status;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"APNs yapılandırması kontrol edilemedi. Hata: {errorContent}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"APNs yapılandırması kontrol edilirken hata oluştu: {ex.Message}");
                return null;
            }
        }

        /// <summary>
        /// Firebase Cloud Messaging'i yapılandırır
        /// </summary>
        /// <returns>FCM Sunucu Anahtarı</returns>
        public async Task<string> ConfigureFCMAsync()
        {
            try
            {
                Console.WriteLine("Firebase Cloud Messaging yapılandırılıyor...");

                // FCM için Firebase Admin SDK'yı başlat (eğer daha önce başlatılmadıysa)
                if (FirebaseApp.DefaultInstance == null)
                {
                    FirebaseApp.Create(new AppOptions
                    {
                        Credential = _credential
                    });
                }

                // Firebase projesi ayarlarını almak için API isteği
                var accessToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
                var url = $"https://firebase.googleapis.com/v1beta1/projects/{_projectId}";

                var request = new HttpRequestMessage(HttpMethod.Get, url);
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                var response = await _httpClient.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var projectInfo = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(responseContent);

                    // Cloud Messaging API'sini etkinleştir
                    await EnableCloudMessagingAPIAsync();

                    // FCM Sunucu Anahtarını almak için Firebase Project Settings API isteği
                    var settingsUrl = $"https://firebase.googleapis.com/v1beta1/projects/{_projectId}/adminSdkConfig";
                    var settingsRequest = new HttpRequestMessage(HttpMethod.Get, settingsUrl);
                    settingsRequest.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                    var settingsResponse = await _httpClient.SendAsync(settingsRequest);

                    if (settingsResponse.IsSuccessStatusCode)
                    {
                        var settingsContent = await settingsResponse.Content.ReadAsStringAsync();
                        var settingsData = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(settingsContent);

                        if (settingsData.ContainsKey("fcmKey"))
                        {
                            var serverKey = settingsData["fcmKey"].GetString();
                            Console.WriteLine("FCM başarıyla yapılandırıldı!");
                            return serverKey;
                        }
                        else
                        {
                            Console.WriteLine("FCM yapılandırıldı, ancak sunucu anahtarı bulunamadı.");
                            return null;
                        }
                    }
                    else
                    {
                        var errorContent = await settingsResponse.Content.ReadAsStringAsync();
                        Console.WriteLine($"FCM ayarları alınamadı. Hata: {errorContent}");
                        return null;
                    }
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Firebase proje bilgileri alınamadı. Hata: {errorContent}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"FCM yapılandırılırken hata oluştu: {ex.Message}");
                return null;
            }
        }

        /// <summary>
        /// Örnek bir FCM mesajı gönderir
        /// </summary>
        /// <param name="deviceToken">Hedef cihaz token'ı</param>
        /// <returns>Mesaj gönderim sonucu</returns>
        public async Task<string> SendTestFCMMessageAsync(string deviceToken)
        {
            try
            {
                // FCM için Firebase Admin SDK'yı başlat (eğer daha önce başlatılmadıysa)
                if (FirebaseApp.DefaultInstance == null)
                {
                    FirebaseApp.Create(new AppOptions
                    {
                        Credential = _credential
                    });
                }

                // Test mesajını oluştur
                var message = new Message()
                {
                    Notification = new Notification
                    {
                        Title = "Test Bildirimi",
                        Body = "Firebase Cloud Messaging test bildirimi"
                    },
                    Data = new Dictionary<string, string>()
                    {
                        { "key1", "value1" },
                        { "key2", "value2" }
                    },
                    Token = deviceToken,
                };

                // Mesajı gönder
                string response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
                Console.WriteLine($"Test mesajı başarıyla gönderildi. Mesaj ID: {response}");
                return response;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Test mesajı gönderilirken hata oluştu: {ex.Message}");
                return null;
            }
        }

        public async Task<CertificatesResponse?> GetFirebaseSha256List(string androidAppId)
        {
            var accessToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
            var url = $"https://firebase.googleapis.com/v1beta1/projects/{_projectId}/androidApps/{androidAppId}/sha";

            var request = new HttpRequestMessage(HttpMethod.Get, url);
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var response = await _httpClient.SendAsync(request);
            if (response.IsSuccessStatusCode)
            {
                return JsonSerializer.Deserialize<CertificatesResponse>(
                    await response.Content.ReadAsStringAsync());
            }
            else
            {
                return new CertificatesResponse();
            }
        }

        public async Task<bool> UploadSha256ToAndroidAppAsync(string androidPackageName, params string[] sha256)
        {
            try
            {
                var androidAppId = await GetAndroidAppIdAsync(androidPackageName);
                var sha256List = await GetFirebaseSha256List(androidAppId);

                if (sha256List == null || sha256List.Certificates == null)
                {
                    Console.WriteLine("Android uygulaması için SHA-256 listesi bulunamadı.");
                    foreach (var sha in sha256)
                    {
                        var sha256ListRequest = new ShaCertificate()
                        {
                            CertType = "SHA_256",
                            ShaHash = sha
                        };

                        var sha256Request = _firebaseManagementService.Projects.AndroidApps.Sha.Create(
                            sha256ListRequest, $"{ProjectName.Format(_projectId)}/androidApps/{androidAppId}");
                        var sha256Response = await sha256Request.ExecuteAsync();
                        if (sha256Response == null)
                        {
                            Console.WriteLine("SHA-256 yüklenemedi: " + sha);
                        }
                    }

                    return true;
                }

                if (sha256List.Certificates != null && sha256List.Certificates.Count > 0)
                {
                    foreach (var sha in sha256)
                    {
                        if (sha256List.Certificates.Any(a => a.CertType == "SHA_256" && Sha256HasStringToSha256(a.ShaHash) == sha))
                        {
                            Console.WriteLine($"SHA-256 zaten mevcut: {sha}");
                            continue;
                        }
                        else
                        {
                            var sha256ListRequest = new ShaCertificate()
                            {
                                CertType = "SHA_256",
                                ShaHash = sha
                            };

                            var sha256Request = _firebaseManagementService.Projects.AndroidApps.Sha.Create(
                                sha256ListRequest, $"{ProjectName.Format(_projectId)}/androidApps/{androidAppId}");
                            var sha256Response = await sha256Request.ExecuteAsync();
                        }
                    }
                }

                return true;
            }
            catch (Exception e)
            {
                return false;
            }
        }

        #region Yardımcı Metotlar
        
        private string Sha256HasStringToSha256(string sha256)
        {

            if (string.IsNullOrEmpty(sha256))
                return string.Empty;

            var normalizeShaGroupPart = sha256.Select((xc, i) => (xc, i)).Aggregate(new List<List<char>>(),
                (list, c) =>
                {
                    var index = c.i;
                    var groupIndex = Convert.ToInt32(Math.Ceiling(decimal.Divide(index + 1, 2))) - 1;
                    if (list.Count <= groupIndex)
                    {
                        list.Add(new List<char>()
                        {
                            c.xc
                        });
                    }
                    else
                    {
                        list[groupIndex].Add(c.xc);
                    }

                    return list;
                }).Select(xc=>string.Join("", xc.Select(cx => cx.ToString().ToUpperInvariant())));

            return string.Join(":", normalizeShaGroupPart);
        }

        private async Task<bool> EnableCloudMessagingAPIAsync()
        {
            try
            {
                // Cloud Messaging API'sini etkinleştirmek için Google Cloud API istemcisi kullan
                var accessToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
                var url =
                    $"https://serviceusage.googleapis.com/v1/projects/{_projectId}/services/fcm.googleapis.com:enable";

                var request = new HttpRequestMessage(HttpMethod.Post, url);
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                var response = await _httpClient.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    Console.WriteLine("Cloud Messaging API etkinleştirildi.");
                    return true;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Cloud Messaging API etkinleştirilemedi. Hata: {errorContent}");
                    return false;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Cloud Messaging API etkinleştirilirken hata oluştu: {ex.Message}");
                return false;
            }
        }

        private async Task<bool> WaitForOperationCompletionAsync(string operationName)
        {
            try
            {
                var accessToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
                var url = $"https://firebase.googleapis.com/v1beta1/{operationName}";

                bool isComplete = false;
                int maxAttempts = 10;
                int attempt = 0;

                while (!isComplete && attempt < maxAttempts)
                {
                    attempt++;

                    var request = new HttpRequestMessage(HttpMethod.Get, url);
                    request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                    var response = await _httpClient.SendAsync(request);

                    if (response.IsSuccessStatusCode)
                    {
                        var content = await response.Content.ReadAsStringAsync();
                        var operationData = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(content);

                        if (operationData.ContainsKey("done") && operationData["done"].GetBoolean())
                        {
                            isComplete = true;
                            Console.WriteLine("İşlem tamamlandı.");
                            return true;
                        }

                        Console.WriteLine($"İşlem devam ediyor... ({attempt}/{maxAttempts})");
                        await Task.Delay(2000); // 2 saniye bekle
                    }
                    else
                    {
                        var errorContent = await response.Content.ReadAsStringAsync();
                        Console.WriteLine($"İşlem durumu alınamadı. Hata: {errorContent}");
                        return false;
                    }
                }

                if (!isComplete)
                {
                    Console.WriteLine("İşlem zaman aşımına uğradı.");
                    return false;
                }

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"İşlem beklenirken hata oluştu: {ex.Message}");
                return false;
            }
        }

        private async Task<string> GetAndroidAppIdAsync(string packageName)
        {
            try
            {
                var listAndroidAppRequest =
                    _firebaseManagementService.Projects.AndroidApps.List(ProjectName.Format(_projectId));
                var listAndroidAppResponse = await listAndroidAppRequest.ExecuteAsync();
                if (listAndroidAppResponse.Apps is { Count: > 0 })
                {
                    foreach (var app in listAndroidAppResponse.Apps)
                    {
                        if (app.PackageName == packageName)
                        {
                            return app.AppId;
                        }
                    }
                }

                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Android uygulama ID'si alınırken hata oluştu: {ex.Message}");
                return null;
            }
        }

        private async Task<string> GetIosAppIdAsync(string bundleId)
        {
            try
            {
                var listAndroidAppRequest =
                    _firebaseManagementService.Projects.IosApps.List(ProjectName.Format(_projectId));
                var listAndroidAppResponse = await listAndroidAppRequest.ExecuteAsync();
                if (listAndroidAppResponse.Apps is { Count: > 0 })
                {
                    foreach (var app in listAndroidAppResponse.Apps)
                    {
                        if (app.BundleId == bundleId)
                        {
                            return app.AppId;
                        }
                    }
                }

                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"iOS uygulama ID'si alınırken hata oluştu: {ex.Message}");
                return null;
            }
        }

        private async Task<AndroidAppConfig> GetAndroidAppConfigAsync(string appId)
        {
            try
            {
                var accessToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
                var url = $"https://firebase.googleapis.com/v1beta1/projects/{_projectId}/androidApps/{appId}/config";

                var request = new HttpRequestMessage(HttpMethod.Get, url);
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                var response = await _httpClient.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();

                    // Base64 kodlanmış yapılandırma dosyasını çöz
                    var configData = JsonDocument.Parse(content).RootElement;
                    string configFileContentsBase64 = configData.GetProperty("configFileContents").GetString();
                    byte[] configBytes = Convert.FromBase64String(configFileContentsBase64);
                    string configJson = Encoding.UTF8.GetString(configBytes);

                    // JSON içeriğinden Android yapılandırma nesnesi oluştur
                    var config = new AndroidAppConfig
                    {
                        AppId = appId,
                        ConfigJson = configJson,
                        ConfigFileContent = configFileContentsBase64
                    };

                    // JSON içeriğinden FCM sender ID ve diğer bilgileri çıkart
                    var configValues = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(configJson);
                    if (configValues.ContainsKey("project_number"))
                    {
                        config.ProjectNumber = configValues["project_number"].GetString();
                    }

                    if (configValues.ContainsKey("firebase_url"))
                    {
                        config.FirebaseUrl = configValues["firebase_url"].GetString();
                    }

                    if (configValues.ContainsKey("gcm_defaultSenderId"))
                    {
                        config.DefaultSenderId = configValues["gcm_defaultSenderId"].GetString();
                    }

                    return config;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Android uygulama yapılandırması alınamadı. Hata: {errorContent}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Android uygulama yapılandırması alınırken hata oluştu: {ex.Message}");
                return null;
            }
        }

        private async Task<IosAppConfig> GetIosAppConfigAsync(string appId)
        {
            try
            {
                var accessToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
                var url = $"https://firebase.googleapis.com/v1beta1/projects/{_projectId}/iosApps/{appId}/config";

                var request = new HttpRequestMessage(HttpMethod.Get, url);
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                var response = await _httpClient.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();

                    // Base64 kodlanmış yapılandırma dosyasını çöz
                    var configData = JsonDocument.Parse(content).RootElement;
                    string configFileContentsBase64 = configData.GetProperty("configFileContents").GetString();
                    byte[] configBytes = Convert.FromBase64String(configFileContentsBase64);
                    string plistContent = Encoding.UTF8.GetString(configBytes);

                    // iOS yapılandırma nesnesi oluştur
                    var config = new IosAppConfig
                    {
                        AppId = appId,
                        PlistContent = plistContent,
                        ConfigFileContent = configFileContentsBase64
                    };

                    return config;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"iOS uygulama yapılandırması alınamadı. Hata: {errorContent}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"iOS uygulama yapılandırması alınırken hata oluştu: {ex.Message}");
                return null;
            }
        }

        #endregion
    }

    #region Model Sınıfları

    /// <summary>
    /// APNs yapılandırma durumunu tutar
    /// </summary>
    public class ApnsConfigStatus
    {
        /// <summary>
        /// APNs Authentication Key yapılandırması var mı?
        /// </summary>
        public bool HasApnsKey { get; set; }

        /// <summary>
        /// APNs Authentication Key ID
        /// </summary>
        public string ApnsKeyId { get; set; }

        /// <summary>
        /// Apple Developer Team ID
        /// </summary>
        public string TeamId { get; set; }

        /// <summary>
        /// APNs Sertifika yapılandırması var mı?
        /// </summary>
        public bool HasApnsCertificate { get; set; }
    }

    /// <summary>
    /// Android uygulama yapılandırma bilgilerini tutar
    /// </summary>
    public class AndroidAppConfig
    {
        /// <summary>
        /// Firebase uygulama ID'si
        /// </summary>
        public string AppId { get; set; }

        /// <summary>
        /// Yapılandırma JSON içeriği
        /// </summary>
        public string ConfigJson { get; set; }

        /// <summary>
        /// Base64 kodlanmış yapılandırma dosya içeriği
        /// </summary>
        public string ConfigFileContent { get; set; }

        /// <summary>
        /// Firebase proje numarası
        /// </summary>
        public string ProjectNumber { get; set; }

        /// <summary>
        /// Firebase URL'si
        /// </summary>
        public string FirebaseUrl { get; set; }

        /// <summary>
        /// FCM Sender ID'si
        /// </summary>
        public string DefaultSenderId { get; set; }

        /// <summary>
        /// google-services.json dosyasını oluşturur
        /// </summary>
        /// <param name="filePath">Dosya yolu</param>
        public void SaveConfigFile(string filePath)
        {
            File.WriteAllText(filePath, ConfigJson);
            Console.WriteLine($"Android yapılandırma dosyası kaydedildi: {filePath}");
        }
    }

    /// <summary>
    /// iOS uygulama yapılandırma bilgilerini tutar
    /// </summary>
    public class IosAppConfig
    {
        /// <summary>
        /// Firebase uygulama ID'si
        /// </summary>
        public string AppId { get; set; }

        /// <summary>
        /// Plist içeriği
        /// </summary>
        public string PlistContent { get; set; }

        /// <summary>
        /// Base64 kodlanmış yapılandırma dosya içeriği
        /// </summary>
        public string ConfigFileContent { get; set; }

        /// <summary>
        /// GoogleService-Info.plist dosyasını oluşturur
        /// </summary>
        /// <param name="filePath">Dosya yolu</param>
        public void SaveConfigFile(string filePath)
        {
            File.WriteAllText(filePath, PlistContent);
            Console.WriteLine($"iOS yapılandırma dosyası kaydedildi: {filePath}");
        }
    }

    #endregion
}