using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using Azure.Identity;
using Azure.Storage.Blobs;
using FirebaseAdmin;
using Google.Api.Gax;
using Google.Api.Gax.Grpc;
using Google.Api.Gax.ResourceNames;
using Google.Apis.Auth.OAuth2;
using Google.Apis.CloudResourceManager.v1;
using Google.Apis.CloudResourceManager.v1.Data;
using Google.Apis.FirebaseManagement.v1beta1.Data;
using Google.Apis.Iam.v1;
using Google.Apis.Services;
using Google.Cloud.ResourceManager.V3;
using Grpc.Auth;
using TenantManager.Models;
using TenantManagerClaude;
using Data = Google.Apis.Iam.v1.Data;
using Project = Google.Cloud.ResourceManager.V3.Project;
using ProjectsResource = Google.Apis.Iam.v1.ProjectsResource;

namespace TenantManager;

public class ServiceAccountModel
{
    [JsonPropertyName("name")] public string Name { get; set; }

    [JsonPropertyName("projectId")] public string ProjectId { get; set; }

    [JsonPropertyName("uniqueId")] public string UniqueId { get; set; }

    [JsonPropertyName("email")] public string Email { get; set; }

    [JsonPropertyName("description")] public string Description { get; set; }

    [JsonPropertyName("displayName")] public string DisplayName { get; set; }

    [JsonPropertyName("etag")] public string Etag { get; set; }

    [JsonPropertyName("oauth2ClientId")] public string Oauth2ClientId { get; set; }
}

public class FirebaseService : IFirebaseService
{
    private static GoogleCredential _credential;
    private static FirebaseApp _firebaseApp;
    private static SemaphoreSlim _semaphore = new SemaphoreSlim(1, 1);
    private static string _configuredProjectId = null;

    private bool _initialized = false;

    // private readonly JobOutputStore _outputStore;
    private readonly string _jobId;
    private HttpClient _client;

    private PollSettings _pollSettings = new PollSettings(
        Expiration.FromTimeout(TimeSpan.FromMinutes(30)), // Toplam zaman aşımı süresini artırın
        TimeSpan.FromSeconds(10) // İki istek arasındaki bekleme süresini ayarlayın
    );


    public FirebaseService(
        // JobOutputStore outputStore,
        // string jobId
    )
    {
        // _outputStore = outputStore;
        // _jobId = jobId;
        _client = new HttpClient();
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
                if (_firebaseApp != null)
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
                        // _outputStore.AppendOutput(jobId: _jobId, "Error during Firebase app deletion: \n "+ex.Message);
                    }

                    _firebaseApp = null;
                }

                // No service account JSON provided
                var serviceAccountJsonPath =
                    Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets", "service-account.json");
                if (!File.Exists(serviceAccountJsonPath))
                {
                    // _outputStore.AppendOutput(jobId: _jobId, "No Firebase service account JSON provided");
                    return false;
                }

                // Create credential from JSON
                using var stream =
                    new MemoryStream(File.ReadAllBytes(serviceAccountJsonPath));
                _credential = GoogleCredential.FromStream(stream)
                    .CreateScoped("https://www.googleapis.com/auth/firebase.messaging",
                        "https://www.googleapis.com/auth/cloud-platform",
                        "https://www.googleapis.com/auth/iam",
                        "https://www.googleapis.com/auth/cloudplatformprojects",
                        "https://www.googleapis.com/auth/firebase");


                _initialized = true;

                // _logger.LogInformation("Firebase Admin SDK initialized successfully");
                return true;
            }
            finally
            {
                _semaphore.Release();
            }
        }
        catch (Exception ex)
        {
            // _logger.LogError(ex, "Error initializing Firebase Admin SDK");
            return false;
        }
    }

    public async Task<T?> SendRestRequestAsync<T>(HttpMethod method, string url, object? body = null)
    {
        var token = await ((ITokenAccess)_credential).GetAccessTokenForRequestAsync();
        using var httpRequest = new HttpRequestMessage(method, url);
        // Use the access token obtained from the Firebase Admin SDK
        httpRequest.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
        if (body != null)
        {
            var json = JsonSerializer.Serialize(body);
            httpRequest.Content = new StringContent(json, Encoding.UTF8, "application/json");
        }

        using var response = await _client.SendAsync(httpRequest);
        var responseString = await response.Content.ReadAsStringAsync();

        if (response.IsSuccessStatusCode)
        {
            // Deserialize the response to the specified type
            return JsonSerializer.Deserialize<T>(responseString);
        }
        else
        {
            // Handle error response
            throw new Exception($"Error: {response.StatusCode}, Response: {responseString}");
        }
    }


    public async Task<Project?> GetProjectAsync(string projectId)
    {
        try
        {
            var client = new ProjectsClientBuilder
            {
                ChannelCredentials = _credential.ToChannelCredentials()
            }.Build();

            var request = new GetProjectRequest
            {
                ProjectName = ProjectName.FromProject(projectId)
            };

            var project = await client.GetProjectAsync(request);
            return project;
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            return null;
        }
    }

    public async Task<Project?> CreateProjectAsync(Project project)
    {
        try
        {
            var client = new ProjectsClientBuilder
            {
                ChannelCredentials = _credential.ToChannelCredentials()
            }.Build();

            var getProjectRequest = new GetProjectRequest
            {
                ProjectName = ProjectName.FromProject(project.ProjectId)
            };

            try
            {
                var existingProject = await client.GetProjectAsync(getProjectRequest);
                if (existingProject != null)
                {
                    if (string.IsNullOrEmpty(existingProject.Name) || string.IsNullOrEmpty(existingProject.DisplayName))
                    {
                        var updateProjectRequest = new UpdateProjectRequest
                        {
                            Project = new Project
                            {
                                ProjectId = project.ProjectId,
                                Name = project.Name
                            },
                        };

                        var updatedProject = await client.UpdateProjectAsync(updateProjectRequest);
                        var updatewait= await updatedProject.PollUntilCompletedAsync(
                            pollSettings: _pollSettings,
                            callSettings: CallSettings.FromExpiration(_pollSettings.Expiration));
                        
                        if(updatewait.IsCompleted)
                        return updatewait.Result;
                        else
                        {
                            await WaitForOperationCompletionAsync(updatewait.Name);
                            return await GetProjectAsync(project.ProjectId);
                        }
                    }

                    return existingProject;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

            var request = new CreateProjectRequest
            {
                Project = project
            };

            var createdProject = await client.CreateProjectAsync(request);
            var waitOperation=await createdProject.PollUntilCompletedAsync(
                pollSettings: _pollSettings,
                callSettings: CallSettings.FromExpiration(_pollSettings.Expiration));
            if (waitOperation.IsCompleted)
            {
                return waitOperation.Result;
            }
            else
            {
                await WaitForOperationCompletionAsync(waitOperation.Name);
                return await GetProjectAsync(project.ProjectId);
            }
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            return null;
        }
    }

    public async Task AddFirebaseToProjectAsync(string projectId, AppBuildsConfig appConfig)
    {
        try
        {
            var firebaseSetupManager = new FirebaseSetupManager(
                _credential,
                projectId
            );
            var gcloudProject = await GetProjectAsync(projectId);

            if (gcloudProject != null &&
                (
                    (gcloudProject.Labels.ContainsKey("firebase") &&
                     gcloudProject.Labels["firebase"].Trim().ToLowerInvariant() == "enabled") ||
                    await firebaseSetupManager.AddFirebaseToProjectAsync()))
            {
                var androidConfig =
                    await firebaseSetupManager.AddAndroidAppAsync(appConfig.PackageNameAndroid, appConfig.AppTitle);
                if (androidConfig != null)
                {
                    // google-services.json dosyasını kaydet
                    androidConfig.SaveConfigFile($"{appConfig.Flavor}-google-services.json");

                    Console.WriteLine("\nAndroid uygulaması bilgileri:");
                    Console.WriteLine($"App ID: {androidConfig.AppId}");
                    Console.WriteLine($"Project Number: {androidConfig.ProjectNumber}");
                    Console.WriteLine($"Sender ID: {androidConfig.DefaultSenderId}");
                }
                else
                {
                    Console.WriteLine("Android uygulaması eklenemedi.");
                }

                // iOS uygulaması ekle
                var iosConfig =
                    await firebaseSetupManager.AddIosAppAsync(appConfig.PackageNameIos, appConfig.AppTitle,
                        Environment.GetEnvironmentVariable("APPLE_DEVELOPER_TEAM_ID") ?? throw new InvalidOperationException("Configure APPLE_DEVELOPER_TEAM_ID for legacy Apple automation."));
                if (iosConfig != null)
                {
                    // GoogleService-Info.plist dosyasını kaydet
                    iosConfig.SaveConfigFile($"{appConfig.Flavor}-GoogleService-Info.plist");

                    Console.WriteLine("\niOS uygulaması başarıyla eklendi:");
                    Console.WriteLine($"App ID: {iosConfig.AppId}");


                }
                else
                {
                    Console.WriteLine("iOS uygulaması eklenemedi.");
                }

                // FCM'yi yapılandır
                string fcmServerKey = await firebaseSetupManager.ConfigureFCMAsync();
                if (!string.IsNullOrEmpty(fcmServerKey))
                {
                    Console.WriteLine("\nFCM başarıyla yapılandırıldı:");
                    Console.WriteLine($"FCM Sunucu Anahtarı: {fcmServerKey}");

                    // Test cihaz token'ı ile test mesajı gönder (isteğe bağlı)
                    // Console.Write("\nFCM test mesajı göndermek için bir cihaz token'ı girin (boş bırakılabilir): ");
                    // string deviceToken = Console.ReadLine();
                    //
                    // if (!string.IsNullOrWhiteSpace(deviceToken))
                    // {
                    //     string messageId = await firebaseSetupManager.SendTestFCMMessageAsync(deviceToken);
                    //     if (!string.IsNullOrEmpty(messageId))
                    //     {
                    //         Console.WriteLine($"Test mesajı başarıyla gönderildi. Mesaj ID: {messageId}");
                    //     }
                    // }
                }
                else
                {
                    Console.WriteLine("FCM yapılandırılamadı.");
                }

                Console.WriteLine("\nFirebase kurulum işlemi tamamlandı!");
            }
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
        }
    }

    /// <summary>
    /// Yeni oluşturulan proje için Firebase Cloud Messaging API Admin rolü ile service account ekler ve credentials'ı kaydeder
    /// </summary>
    /// <param name="projectId">Google Cloud / Firebase Proje ID'si</param>
    /// <param name="serviceAccountName">Service account için benzersiz ID (sadece harf, rakam ve kısa çizgi içerebilir)</param>
    /// <param name="serviceAccountDisplayName">Service account için görünen isim</param>
    /// <returns>İşlem başarılı olursa true döner</returns>
    public async Task<bool> AddServiceAccountWithFCMAdminRole(string projectId, string serviceAccountName,
        string serviceAccountDisplayName)
    {
        try
        {
            IamService iamService = new IamService(new BaseClientService.Initializer
            {
                HttpClientInitializer = _credential,
                ApplicationName = "FirebaseSetupManager",
            });
            Google.Apis.Iam.v1.Data.ServiceAccount? serviceAccount;
            var serviceAccountList = iamService.Projects.ServiceAccounts.List(ProjectName.Format(projectId)).Execute();
            if (serviceAccountList?.Accounts != null && serviceAccountList.Accounts.Any(x =>
                    x.Email == $"{serviceAccountName}@{projectId}.iam.gserviceaccount.com"))
            {
                Console.WriteLine($"Service account {serviceAccountName} already exists");
                serviceAccount = serviceAccountList.Accounts.First(x =>
                    x.Email == $"{serviceAccountName}@{projectId}.iam.gserviceaccount.com");
            }
            else
            {
                serviceAccount = iamService.Projects.ServiceAccounts.Create(new Data.CreateServiceAccountRequest()
                    {
                        AccountId = serviceAccountName,
                        ServiceAccount = new Data.ServiceAccount()
                        {
                            DisplayName = serviceAccountDisplayName,
                            Description = "Auto generated service account for Firebase Admin SDK"
                        }
                    }, $"projects/{projectId}").Execute();
            }

            // 1. Create a service account
            // var createServiceAccountUrl = $"https://iam.googleapis.com/v1/projects/{projectId}/serviceAccounts";
            // var existingServiceAccounts = await SendRestRequestAsync<Dictionary<string,JsonDocument>>(HttpMethod.Get, createServiceAccountUrl);
            // var currentPolicyUrl = $"https://cloudresourcemanager.googleapis.com/v1/projects/{projectId}:getIamPolicy";
            // var currentPolicy = await SendRestRequestAsync<Data.Policy>(HttpMethod.Post, currentPolicyUrl, new {});
            // if (currentPolicy == null)
            //     return false;
            //
            // if (existingServiceAccounts.ContainsKey("accounts") && existingServiceAccounts["accounts"]
            //         .Deserialize<List<ServiceAccountModel>>().Any(x =>
            //             x.Email == $"{serviceAccountName}@{projectId}.iam.gserviceaccount.com"))
            // {
            //     serviceAccount = existingServiceAccounts["accounts"]
            //         .Deserialize<List<ServiceAccountModel>>().First(x =>
            //             x.Email == $"{serviceAccountName}@{projectId}.iam.gserviceaccount.com");
            //     
            // }
            // else
            // {
            //     var serviceAccountBody = new
            //     {
            //         accountId = serviceAccountName,
            //         serviceAccount = new
            //         {
            //             displayName = serviceAccountDisplayName,
            //             description ="Auto generated service account for Firebase Admin SDK"
            //         }
            //     };
            //
            //     serviceAccount = await SendRestRequestAsync<ServiceAccountModel>(HttpMethod.Post, createServiceAccountUrl, serviceAccountBody);
            //     if (serviceAccount == null) return false;
            // }
            
            if (serviceAccount == null) return false;

            string serviceAccountEmail = serviceAccount.Email;

            try
            {
                var crmService = InitializeCrmService();
                AddBinding(crmService, projectId, $"serviceAccount:{serviceAccount.Email}",
                    "roles/firebasecloudmessaging.admin");
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return false;
            }

            // IamService iamService = new IamService(new BaseClientService.Initializer
            // {
            //     HttpClientInitializer = _credential,
            //     ApplicationName = "FirebaseSetupManager",
            // });

            // if (currentPolicy != null && currentPolicy.Bindings != null &&currentPolicy.Bindings.Any(x =>
            //         x.Role == "roles/firebasecloudmessaging.admin" &&
            //         (x.Members?.Contains($"serviceAccount:{serviceAccount.Email}")??false)))
            // {
            //     return true;
            // }
            //
            // var existingBinding = currentPolicy.Bindings?.FirstOrDefault(x =>
            //     x.Role == "roles/firebasecloudmessaging.admin");
            //     
            // if (existingBinding != null)
            // {
            //     currentPolicy.Bindings.Remove(existingBinding);
            //     if(existingBinding.Members!=null)
            //     existingBinding.Members.Add($"serviceAccount:{serviceAccount.Email}");
            //     else
            //     {
            //         existingBinding.Members = new List<string>()
            //         {
            //             $"serviceAccount:{serviceAccount.Email}"
            //         };
            //     }
            // }
            //     
            // var roleBinding = existingBinding != null ? existingBinding : new Data.Binding
            // {
            //     Role = "roles/firebasecloudmessaging.admin",
            //     Members = new List<string>
            //     {
            //         $"serviceAccount:{serviceAccount.Email}"
            //     }
            // };
            // if(currentPolicy?.Bindings !=null)
            // currentPolicy.Bindings.Add(roleBinding);
            // else
            // {
            //     currentPolicy.Bindings = new List<Data.Binding>()
            //     {
            //         roleBinding
            //     };
            // }
            //     
            // Data.SetIamPolicyRequest requestBody = new Data.SetIamPolicyRequest
            // {
            //     
            //     Policy = currentPolicy
            // };
            // ProjectsResource.ServiceAccountsResource.SetIamPolicyRequest requestSetIam = iamService.Projects.ServiceAccounts.SetIamPolicy(requestBody, serviceAccount.Name);
            //
            // var updatedPolicy = await requestSetIam.ExecuteAsync();
            //
            // if((updatedPolicy.Bindings?.Any(x=>x.Role=="roles/firebasecloudmessaging.admin" && (x.Members?.Contains($"serviceAccount:{serviceAccount.Email}")??false))??false))
            // {
            //     Console.WriteLine($"Service account {serviceAccountEmail} added to roles/firebasecloudmessaging.admin");
            // }
            // else
            // {
            //     Console.WriteLine($"Failed to add service account {serviceAccountEmail} to roles/firebasecloudmessaging.admin");
            //     return false;
            // }

            // 3. Generate service account key and save to json file
            var jsonFilePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets",
                $"{projectId}-service-account.json");
            if (File.Exists(jsonFilePath))
            {
                return true;
            }

            ProjectsResource.ServiceAccountsResource.KeysResource.ListRequest request =
                iamService.Projects.ServiceAccounts.Keys.List(serviceAccount.Name);

            // To execute asynchronously in an async method, replace `request.Execute()` as shown:
            Data.ListServiceAccountKeysResponse response = request.Execute();
            //TDO: check if key already exists


            Data.CreateServiceAccountKeyRequest createKetRequestBody = new Data.CreateServiceAccountKeyRequest()
            {
                KeyAlgorithm = "KEY_ALG_RSA_2048",
                PrivateKeyType = "TYPE_GOOGLE_CREDENTIALS_FILE"
            };

            ProjectsResource.ServiceAccountsResource.KeysResource.CreateRequest createKeyRequest =
                iamService.Projects.ServiceAccounts.Keys.Create(createKetRequestBody, serviceAccount.Name);

            // To execute asynchronously in an async method, replace `request.Execute()` as shown:
            Data.ServiceAccountKey createKeyResponse = createKeyRequest.Execute();
            if (createKeyResponse.PrivateKeyData != null)
            {
                byte[] keyBytes = Convert.FromBase64String(createKeyResponse.PrivateKeyData);

                // Create Assets directory if it doesn't exist
                string assetsDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets");
                if (!Directory.Exists(assetsDir))
                {
                    Directory.CreateDirectory(assetsDir);
                }

                // Save to file
                string savePath = Path.Combine(assetsDir, $"{projectId}-service-account.json");
                File.WriteAllBytes(savePath, keyBytes);

                Console.WriteLine($"Service account created and credentials saved to {savePath}");
                return true;
            }

            return false;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error adding service account: {ex.Message}");
            return false;
        }
    }

    public async Task<string?> GetFcmServiceAccountJsonCredential(string projectId)
    {
        var jsonFilePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets",
            $"{projectId}-service-account.json");
        
        IamService iamService = new IamService(new BaseClientService.Initializer
        {
            HttpClientInitializer = _credential,
            ApplicationName = "FirebaseSetupManager",
        });
        Google.Apis.Iam.v1.Data.ServiceAccount? serviceAccount;
        var serviceAccountList = iamService.Projects.ServiceAccounts.List(ProjectName.Format(projectId)).Execute();
        if (serviceAccountList?.Accounts != null && serviceAccountList.Accounts.Any(x =>
                x.DisplayName?.ToLowerInvariant() == "firebase-adminsdk"))
        {
            serviceAccount = serviceAccountList.Accounts.First(x =>
                x.DisplayName?.ToLowerInvariant() == "firebase-adminsdk");
        }
        else
        {
            return null;
        }

        if (serviceAccount == null)
            return null;
        
        var blobServiceClient = new BlobServiceClient(new Uri("https://storage.example.invalid"), new DefaultAzureCredential());
        var containerClient = blobServiceClient.GetBlobContainerClient("service-accounts");
        containerClient.CreateIfNotExists();
        var blobClient = containerClient.GetBlobClient($"{projectId}-fcm-admin-sdk-service-account.json");
        if (blobClient.Exists().Value)
        {
            return $"{projectId}-fcm-admin-sdk-service-account.json";
        }
        else
        {
            Data.CreateServiceAccountKeyRequest createKetRequestBody = new Data.CreateServiceAccountKeyRequest()
            {
                KeyAlgorithm = "KEY_ALG_RSA_2048",
                PrivateKeyType = "TYPE_GOOGLE_CREDENTIALS_FILE"
            };

            ProjectsResource.ServiceAccountsResource.KeysResource.CreateRequest createKeyRequest =
                iamService.Projects.ServiceAccounts.Keys.Create(createKetRequestBody, serviceAccount.Name);

            // To execute asynchronously in an async method, replace `request.Execute()` as shown:
            Data.ServiceAccountKey createKeyResponse = createKeyRequest.Execute();
            if (createKeyResponse.PrivateKeyData != null)
            {
                byte[] keyBytes = Convert.FromBase64String(createKeyResponse.PrivateKeyData);
                var blobContentInfo = blobClient.Upload(BinaryData.FromBytes(keyBytes));
                if(blobContentInfo.HasValue)
                {
                    Console.WriteLine($"Service account created and credentials saved to {jsonFilePath}");
                    return $"{projectId}-fcm-admin-sdk-service-account.json";
                }
                else
                {
                    Console.WriteLine($"Failed to upload service account credentials to blob storage");
                    return null;
                }
            }

            return null;
        }
    }

    public static CloudResourceManagerService InitializeCrmService()
    {
        // Create the Cloud Resource Manager service object
        CloudResourceManagerService crmService = new CloudResourceManagerService(
            new CloudResourceManagerService.Initializer
            {
                HttpClientInitializer = _credential
            });

        return crmService;
    }

    public static Policy GetPolicy(CloudResourceManagerService crmService, String projectId)
    {
        // Get the project's policy by calling the
        // Cloud Resource Manager Projects API
        var policy = crmService.Projects.GetIamPolicy(
            new GetIamPolicyRequest(),
            projectId).Execute();
        return policy;
    }

    public static void SetPolicy(CloudResourceManagerService crmService, String projectId, Policy policy)
    {
        // Set the project's policy by calling the
        // Cloud Resource Manager Projects API
        crmService.Projects.SetIamPolicy(
            new SetIamPolicyRequest
            {
                Policy = policy
            }, projectId).Execute();
    }

    public static void AddBinding(
        CloudResourceManagerService crmService,
        string projectId,
        string member,
        string role)
    {
        // Get the project's policy
        var policy = GetPolicy(crmService, projectId);

        // Find binding in policy
        var binding = policy.Bindings.FirstOrDefault(x => x.Role == role);

        // If binding already exists, add principal to binding
        if (binding != null)
        {
            if (binding.Members != null)
            {
                if (binding.Members.Contains(member))
                {
                    return;
                }

                binding.Members.Add(member);
            }
        }
        // If binding does not exist, add binding to policy
        else
        {
            binding = new Binding
            {
                Role = role,
                Members = new List<string> { member }
            };
            policy.Bindings.Add(binding);
        }

        // Set the updated policy
        SetPolicy(crmService, projectId, policy);
    }

    /// <summary>
    /// Kullanıcı email'ini projenin roles/owner rolü üyelerine ekler
    /// </summary>
    /// <param name="projectId">Google Cloud / Firebase Proje ID'si</param>
    /// <param name="userEmail">Projeye eklenecek kullanıcı email adresi</param>
    /// <returns>İşlem başarılı olursa true döner</returns>
    public async Task<bool> AddUserToOwnerRole(string projectId, string userEmail)
    {
        string memberEmail = userEmail.StartsWith("user:") ? userEmail : $"user:{userEmail}";
        try
        {
            try
            {
                var crmService = InitializeCrmService();
                // Email formatını doğru formata getir

                AddBinding(crmService, projectId, memberEmail, "roles/owner");
                return true;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return false;
            }


            IamService iamService = new IamService(new BaseClientService.Initializer
            {
                HttpClientInitializer = _credential,
                ApplicationName = "FirebaseSetupManager",
            });

            // IAM Policy API URL
            var getIamPolicyUrl = $"https://cloudresourcemanager.googleapis.com/v1/projects/{projectId}:getIamPolicy";

            // Mevcut IAM policy'i al
            var currentPolicy = await SendRestRequestAsync<Data.Policy>(HttpMethod.Post, getIamPolicyUrl, new { });
            if (currentPolicy == null) return false;


            // string memberEmail = userEmail.StartsWith("user:") ? userEmail : $"user:{userEmail}";

            // Owner rolünü kontrol et
            if (currentPolicy.Bindings != null && currentPolicy.Bindings.Any(x =>
                    x.Role == "roles/owner" && (x.Members?.Contains(memberEmail) ?? false)))
            {
                // Kullanıcı zaten owner rolünde
                Console.WriteLine($"User {userEmail} is already an owner of the project");
                return true;
            }

            // Owner rolü mevcut mu kontrol et
            var existingBinding = currentPolicy.Bindings?.FirstOrDefault(x => x.Role == "roles/owner");

            if (existingBinding != null)
            {
                // Mevcut owner binding'i güncelle
                currentPolicy.Bindings.Remove(existingBinding);
                existingBinding.Members.Add(memberEmail);
                currentPolicy.Bindings.Add(existingBinding);
            }
            else
            {
                // Owner rolü yoksa yeni oluştur
                var roleBinding = new Data.Binding
                {
                    Role = "roles/owner",
                    Members = new List<string>
                    {
                        memberEmail
                    }
                };
                if (currentPolicy.Bindings == null)
                {
                    currentPolicy.Bindings = new List<Data.Binding>()
                    {
                        roleBinding
                    };
                }
                else
                {
                    currentPolicy.Bindings.Add(roleBinding);
                }
            }

            // Policy'i güncelle
            var setIamPolicyUrl = $"https://cloudresourcemanager.googleapis.com/v1/projects/{projectId}:setIamPolicy";
            var updatePolicyBody = new
            {
                policy = currentPolicy
            };

            var updatedPolicy =
                await SendRestRequestAsync<Data.Policy>(HttpMethod.Post, setIamPolicyUrl, updatePolicyBody);

            if (updatedPolicy != null && updatedPolicy.Bindings != null && updatedPolicy.Bindings.Any(x =>
                    x.Role == "roles/owner" &&
                    (x.Members?.Contains(memberEmail) ?? false)))
            {
                Console.WriteLine($"User {userEmail} successfully added as owner of the project");
                return true;
            }

            Console.WriteLine($"Failed to add user {userEmail} as owner of the project");
            return false;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error adding user to owner role: {ex.Message}");
            return false;
        }
    }

    public Task<AndroidAppConfig?> GetAndroidConfig(string packageName,string projectId)
    {
        var firebaseSetupManager = new FirebaseSetupManager(
            _credential,
            projectId
        );

        return firebaseSetupManager.GetAndroidConfig(packageName);
    }

    public async Task<bool> AddAndroidSha256Fingerprint(string projectId, string packageNameAndroid,
        string devKeySha256, string notReducedSha256)
    {
        var firebaseSetupManager = new FirebaseSetupManager(
            _credential,
            projectId
        );
        return await firebaseSetupManager.UploadSha256ToAndroidAppAsync(packageNameAndroid, devKeySha256,
            notReducedSha256);
    }
    
    public async Task<CertificatesResponse?> GetFirebaseAndroidSha256(string projectId, string packageNameAndroid)
    {
        var firebaseSetupManager = new FirebaseSetupManager(
            _credential,
            projectId
        );
        var androidApp= await firebaseSetupManager.GetAndroidConfig(packageNameAndroid);
        return await firebaseSetupManager.GetFirebaseSha256List(androidApp.AppId);
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
                    
                    var response = await _client.SendAsync(request);
                    
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
}