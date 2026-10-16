using Platform.Security;
using System.Diagnostics;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Azure.Storage.Blobs;
using FirebaseAdmin.Auth;
using Google.Api.Gax.ResourceNames;
using Google.Apis.Auth.OAuth2;
using Google.Apis.FirebaseAppDistribution.v1;
using Google.Apis.FirebaseManagement.v1beta1;
using Google.Apis.FirebaseManagement.v1beta1.Data;
using Google.Apis.Services;
using StackExchange.Redis;
using TenantManager;

namespace TenantManagerClaude
{
    public class BuildManager
    {
        private readonly AppBuildsConfig _appBuildsConfig;
        private readonly string _blobStorageUrl;
        private readonly Uri _blobStorageConnectionString;
        private readonly string _redisConnectionString;
        private readonly string _gitRepositoryUrl;
        private readonly JobOutputStore _outputStore;
        private readonly string _jobId;
        private readonly HttpClient _httpClient;
        private readonly IConnectionMultiplexer _redis;
        private readonly BlobServiceClient _blobServiceClient;
        private readonly ITenantSecrets _tenantSecrets;

        private readonly string flavorizrYamlTemplate = @"
flavors:
  {flavorName}:
    app:
      name: ""{label}""
      icon: ""{iconPath}""
    android:
      applicationId: ""{androidPackageName}""
      generateDummyAssets: false
      customConfig:
        manifestPlaceholders[""deepLinkHost""]: ""\""{storeUrl}\""""

    ios:
      bundleId: ""{iosPackageName}""
      generateDummyAssets: false
      icon: ""{iconPath}""
      buildSettings:
        CODE_SIGN_ENTITLEMENTS: {flavorName}.entitlements
      variables:
        DEEP_LINK_HOST:
          value: ""{storeUrl}""
        NOTIFICATION_EXTENSION_BUNDLE_ID:
          value: ""{iosPackageName}.NotificationServiceExtension""

ide: idea

instructions:
  - assets:download
  - assets:extract
  - android:flavorizrGradle
  - android:buildGradle
  - android:androidManifest
  - ios:podfile
  - ios:xcconfig
  - ios:buildTargets
  - ios:schema
  - ios:icons
  - ios:plist
  - ios:launchScreen
";

        private string iosEntitlementsTemplate = @"
<?xml version=""1.0"" encoding=""UTF-8""?>
<!DOCTYPE plist PUBLIC ""-//Apple//DTD PLIST 1.0//EN"" ""http://www.apple.com/DTDs/PropertyList-1.0.dtd"">
<plist version=""1.0"">
<dict>
	<key>com.apple.developer.associated-domains</key>
	<array>
		<string>applinks:{storeUrl}</string>
	</array>
    <key>aps-environment</key>
	<string>development</string>
</dict>
</plist>
";

        private string flutterLauncherIconsYamlTemplate = @"
# flutter pub run flutter_launcher_icons
flutter_launcher_icons:
  image_path: ""{iconPath}""

  android: ""launcher_icon""
  # image_path_android: ""assets/icon/icon.png""
  min_sdk_android: 21 # android min sdk min:16, default 21
  # adaptive_icon_background: ""assets/icon/background.png""
  # adaptive_icon_foreground: ""assets/icon/foreground.png""
  # adaptive_icon_monochrome: ""assets/icon/monochrome.png""

  ios: true
  remove_alpha_ios: true
  # image_path_ios: ""assets/icon/icon.png""
  # remove_alpha_channel_ios: true
  # image_path_ios_dark_transparent: ""assets/icon/icon_dark.png""
  # image_path_ios_tinted_grayscale: ""assets/icon/icon_tinted.png""
  # desaturate_tinted_to_grayscale_ios: true
";

        private string flutterNativeSplashYamlTemplate = @"
flutter_native_splash:
  # This package generates native code to customize Flutter's default white native splash screen
  # with background color and splash image.
  # Customize the parameters below, and run the following command in the terminal:
  # dart run flutter_native_splash:create
  # To restore Flutter's default white splash screen, run the following command in the terminal:
  # dart run flutter_native_splash:remove

  # IMPORTANT NOTE: These parameter do not affect the configuration of Android 12 and later, which
  # handle splash screens differently that prior versions of Android.  Android 12 and later must be
  # configured specifically in the android_12 section below.

  # color or background_image is the only required parameter.  Use color to set the background
  # of your splash screen to a solid color.  Use background_image to set the background of your
  # splash screen to a png image.  This is useful for gradients. The image will be stretch to the
  # size of the app. Only one parameter can be used, color and background_image cannot both be set.
  color: ""#42a5f5""
  #background_image: ""assets/background.png""

  # Optional parameters are listed below.  To enable a parameter, uncomment the line by removing
  # the leading # character.

  # The image parameter allows you to specify an image used in the splash screen.  It must be a
  # png file and should be sized for 4x pixel density.
  #image: assets/splash.png

  # The branding property allows you to specify an image used as branding in the splash screen.
  # It must be a png file. It is supported for Android, iOS and the Web.  For Android 12,
  # see the Android 12 section below.
  branding: {iconPath}

  # To position the branding image at the bottom of the screen you can use bottom, bottomRight,
  # and bottomLeft. The default values is bottom if not specified or specified something else.
  #branding_mode: bottom
  
  # Set the branding padding from the bottom of the screen.  The default value is 0
  # branding_bottom_padding: 24

  # The color_dark, background_image_dark, image_dark, branding_dark are parameters that set the background
  # and image when the device is in dark mode. If they are not specified, the app will use the
  # parameters from above.  If there is no parameter above, the app will use the light mode values.
  # If the image_dark parameter is specified, color_dark or background_image_dark must be specified.  
  # color_dark and background_image_dark cannot both be set.
  #color_dark: ""#042a49""
  #background_image_dark: ""assets/dark-background.png""
  #image_dark: assets/splash-invert.png
  #branding_dark: assets/dart_dark.png

  # From Android 12 onwards, the splash screen is handled differently than in previous versions.
  # Please visit https://developer.android.com/guide/topics/ui/splash-screen
  # Following are specific parameters for Android 12+.
  android_12:
    # The image parameter sets the splash screen icon image.  If this parameter is not specified,
    # the app's launcher icon will be used instead.
    # Please note that the splash screen will be clipped to a circle on the center of the screen.
    # App icon with an icon background: This should be 960×960 pixels, and fit within a circle
    # 640 pixels in diameter.
    # App icon without an icon background: This should be 1152×1152 pixels, and fit within a circle
    # 768 pixels in diameter.  To fit a 1152x1152 image within a circle with a 768 diameter, simply 
    # ensure that the most important design elements of your image are placed within a circular area
    # with a 768 diameter at the center of the 1152x1152 canvas.
    #image: assets/android12splash.png

    # Splash screen background color.
    #color: ""#42a5f5""

    # App icon background color.
    #icon_background_color: ""#111111""

    # The branding property allows you to specify an image used as branding in the splash screen.
    #branding: assets/dart.png

    # The image_dark, color_dark, icon_background_color_dark, and branding_dark set values that
    # apply when the device is in dark mode. If they are not specified, the app will use the
    # parameters from above.  If there is no parameter above, the app will use the light mode values.
    #image_dark: assets/android12splash-invert.png
    #color_dark: ""#042a49""
    #icon_background_color_dark: ""#eeeeee""

  # The android, ios and web parameters can be used to disable generating a splash screen on a given
  # platform.
  #android: false
  #ios: false
  #web: false

  # Platform specific images can be specified with the following parameters, which will override
  # the respective parameter.  You may specify all, selected, or none of these parameters:
  #color_android: ""#42a5f5""
  #color_dark_android: ""#042a49""
  #color_ios: ""#42a5f5""
  #color_dark_ios: ""#042a49""
  #color_web: ""#42a5f5""
  #color_dark_web: ""#042a49""
  #image_android: assets/splash-android.png
  #image_dark_android: assets/splash-invert-android.png
  #image_ios: assets/splash-ios.png
  #image_dark_ios: assets/splash-invert-ios.png
  #image_web: assets/splash-web.gif
  #image_dark_web: assets/splash-invert-web.gif
  #background_image_android: ""assets/background-android.png""
  #background_image_dark_android: ""assets/dark-background-android.png""
  #background_image_ios: ""assets/background-ios.png""
  #background_image_dark_ios: ""assets/dark-background-ios.png""
  #background_image_web: ""assets/background-web.png""
  #background_image_dark_web: ""assets/dark-background-web.png""
  #branding_android: assets/brand-android.png
  #branding_bottom_padding_android: 24
  #branding_dark_android: assets/dart_dark-android.png
  #branding_ios: assets/brand-ios.png
  #branding_bottom_padding_ios: 24
  #branding_dark_ios: assets/dart_dark-ios.png
  #branding_web: assets/brand-web.gif
  #branding_dark_web: assets/dart_dark-web.gif

  # The position of the splash image can be set with android_gravity, ios_content_mode, and
  # web_image_mode parameters.  All default to center.
  #
  # android_gravity can be one of the following Android Gravity (see
  # https://developer.android.com/reference/android/view/Gravity): bottom, center,
  # center_horizontal, center_vertical, clip_horizontal, clip_vertical, end, fill, fill_horizontal,
  # fill_vertical, left, right, start, or top.
  #android_gravity: center
  #
  # ios_content_mode can be one of the following iOS UIView.ContentMode (see
  # https://developer.apple.com/documentation/uikit/uiview/contentmode): scaleToFill,
  # scaleAspectFit, scaleAspectFill, center, top, bottom, left, right, topLeft, topRight,
  # bottomLeft, or bottomRight.
  #ios_content_mode: center
  #
  # web_image_mode can be one of the following modes: center, contain, stretch, and cover.
  #web_image_mode: center

  # The screen orientation can be set in Android with the android_screen_orientation parameter.
  # Valid parameters can be found here:
  # https://developer.android.com/guide/topics/manifest/activity-element#screen
  #android_screen_orientation: sensorLandscape

  # To hide the notification bar, use the fullscreen parameter.  Has no effect in web since web
  # has no notification bar.  Defaults to false.
  # NOTE: Unlike Android, iOS will not automatically show the notification bar when the app loads.
  #       To show the notification bar, add the following code to your Flutter app:
  #       WidgetsFlutterBinding.ensureInitialized();
  #       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top], );
  #fullscreen: true

  # If you have changed the name(s) of your info.plist file(s), you can specify the filename(s)
  # with the info_plist_files parameter.  Remove only the # characters in the three lines below,
  # do not remove any spaces:
  #info_plist_files:
  #  - 'ios/Runner/Info-Debug.plist'
  #  - 'ios/Runner/Info-Release.plist'
";

        private const string SCREENSHOT_CHANNEL_NAME = "SCREENSHOTS";
        private const string NEW_BUILD_CHANNEL_NAME = "NEW_BUILD_COMPLETED";

        public BuildManager(
            AppBuildsConfig appBuildsConfig,
            string blobStorageUrl,
            Uri blobStorageConnectionString,
            ITenantSecrets tenantSecrets,
            string redisConnectionString,
            string gitRepositoryUrl,
            JobOutputStore outputStore,
            string jobId
        )
        {
            _appBuildsConfig = appBuildsConfig;
            _blobStorageUrl = blobStorageUrl;
            _blobStorageConnectionString = blobStorageConnectionString;
            _tenantSecrets = tenantSecrets;
            _redisConnectionString = redisConnectionString;
            _gitRepositoryUrl = gitRepositoryUrl;
            _outputStore = outputStore;
            _jobId = jobId;

            _httpClient = new HttpClient();
            _redis = ConnectionMultiplexer.Connect(_redisConnectionString);
            _blobServiceClient = new BlobServiceClient(_blobStorageConnectionString, new DefaultAzureCredential());
        }

        public async Task HandleBuild()
        {
            try
            {
                var projectPath = Path.Combine("/workspace", "CustmerStoreApp", "builds",
                    _appBuildsConfig.AuthClientId);

                CleanupProjectFiles(projectPath);

                // Create the project directory if it doesn't exist
                Directory.CreateDirectory(projectPath);

                // Clone the repository
                await CloneRepository(projectPath);

                var flutterAppPath = Path.Combine(projectPath, "Platforms", "store_user_app");
                var iconsPath = Path.Combine(flutterAppPath, "flavors", _appBuildsConfig.Flavor);

                // Create the icons directory if it doesn't exist
                Directory.CreateDirectory(iconsPath);

                // Download and save the icon
                var iconFilePath = Path.Combine(iconsPath, "ic_launcher.png");
                await DownloadIcon(_appBuildsConfig.StoreIcon, iconFilePath);

                var logoExt = Path.GetExtension(_appBuildsConfig.StoreLogo);
                var logoPath = Path.Combine(flutterAppPath, "assets", $"store_logo{logoExt}");
                await DownloadLogo(_appBuildsConfig.StoreLogo, logoPath);

                _appBuildsConfig.StoreLogo = Path.Combine("assets", $"store_logo{logoExt}");

                // Handle entitlements file
                var iosEntitlementsFilePath =
                    Path.Combine(flutterAppPath, "ios", $"{_appBuildsConfig.Flavor}.entitlements");
                Directory.CreateDirectory(Path.GetDirectoryName(iosEntitlementsFilePath));

                await CreateEntitlementsFile(iosEntitlementsFilePath);

                // Handle flavorizr file
                var flavorizrFilePath = Path.Combine(flutterAppPath, "flavorizr.yaml");
                await CreateFlavorizrFile(flavorizrFilePath, iconFilePath);

                // Run flutter commands
                await RunFlutterCommand(flutterAppPath, "clean");
                await RunFlutterCommand(flutterAppPath, "pub get");
                await RunFlutterCommand(flutterAppPath, "pub run build_runner build -d");
                await RunFlutterCommand(flutterAppPath, "pub run flutter_flavorizr");

                // Delete unnecessary files
                var flavorizrIconPath = Path.Combine(flutterAppPath, "ios", "Runner", "Assets.xcassets",
                    $"{_appBuildsConfig.Flavor}AppIcon.appiconset");
                // File.Delete(flavorizrFilePath);

                var flavorizrLaunchScreen = Path.Combine(flutterAppPath, "ios", "Runner",
                    $"{_appBuildsConfig.Flavor}LaunchScreen.storyboard");
                if (File.Exists(flavorizrLaunchScreen))
                {
                    File.Delete(flavorizrLaunchScreen);
                }

                // Create launcher icons file
                var launcherIconsFilePath =
                    Path.Combine(flutterAppPath, $"flutter_launcher_icons-{_appBuildsConfig.Flavor}.yaml");
                await CreateLauncherIconsFile(launcherIconsFilePath, iconFilePath);

                // Create native splash file
                var nativeSplashFilePath =
                    Path.Combine(flutterAppPath, $"flutter_native_splash-{_appBuildsConfig.Flavor}.yaml");
                await CreateNativeSplashFile(nativeSplashFilePath, iconFilePath);

                // Run flutter launcher icons command
                await RunFlutterCommand(flutterAppPath,
                    $"pub run flutter_launcher_icons -f flutter_launcher_icons-{_appBuildsConfig.Flavor}.yaml");

                // Replace icon paths
                ReplaceAppIconPath(flutterAppPath);

                // Run native splash command
                await RunFlutterCommand(flutterAppPath,
                    $"pub run flutter_native_splash:create --flavor {_appBuildsConfig.Flavor}");

                // Replace launch screen paths
                ReplaceLaunchScreenPath(flutterAppPath);

                // Create signing key for Android
                var (jksPath, keyPassword, keyAlias, keyAliasPassword) = await CreateAndroidSigningKey(
                    Path.Combine("/workspace", "CustmerStoreApp", "keys", _appBuildsConfig.AuthClientId));
                var keySha256 = await GetKeySha256Fingerprint(jksPath, keyPassword, keyAlias);

                // Update build.gradle.kts with signing options
                await InsertSigningOptionsInBuildGradle(flutterAppPath, jksPath, keyPassword, keyAlias,
                    keyAliasPassword);

                // Upload to Azure Key Vault if not exists
                await UploadSigningKeyToKeyVault(jksPath, keyPassword, keyAlias, keyAliasPassword);

                // Generate BuildEnvironmentConfig for screenshot script
                var buildEnvConfig = CreateBuildEnvironmentConfig(keySha256);

                var devKeySha256 = await GetDebugKeySha256Fingerprint(false);
                var notReducedSha256 = await GetKeySha256Fingerprint(jksPath, keyPassword, keyAlias, false);

                var firebaseService = new FirebaseService();
                if (await firebaseService.InitializeFirebaseAdminAsync())
                {
                    await firebaseService.AddFirebaseToProjectAsync(_appBuildsConfig.GCloudProjectId, _appBuildsConfig);
                    await firebaseService.AddAndroidSha256Fingerprint(_appBuildsConfig.GCloudProjectId,
                        _appBuildsConfig.PackageNameAndroid, devKeySha256, notReducedSha256);
                    var fcmServiceFile =
                        await firebaseService.GetFcmServiceAccountJsonCredential(_appBuildsConfig.GCloudProjectId);
                    if (fcmServiceFile != null)
                    {
                        var containerClient = _blobServiceClient.GetBlobContainerClient("service-accounts");
                        await containerClient.CreateIfNotExistsAsync();
                        var blobClient = containerClient.GetBlobClient(fcmServiceFile);
                        var binaryData = await blobClient.DownloadContentAsync();
                        var filePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets", fcmServiceFile);
                        File.WriteAllBytes(filePath, binaryData.Value.Content.ToArray());
                        await RunFlutterFireCli(flutterAppPath, _appBuildsConfig, filePath);
                    }
                }


                // Run screenshot script
                // await RunScreenshotScript(flutterAppPath, buildEnvConfig);
                //
                // // Process and upload screenshots
                // var screenshotModels = await ProcessAndUploadScreenshots(projectPath);
                //
                // // Publish screenshot message to Redis
                // await PublishScreenshotsToRedis(screenshotModels);

                // Update version and build number in pubspec.yaml
                await UpdateVersionAndBuildNumber(flutterAppPath);

                // Build Android APK
                var androidApkPath = await BuildAndroidApk(flutterAppPath, buildEnvConfig);

                // Upload APK to Azure Blob Storage
                var androidApkBlobUrl =
                    await UploadBuildToAzureStorage(androidApkPath, BuildPlatform.Android, buildEnvConfig);

                // Publish Android build message to Redis
                await PublishBuildMessageToRedis(BuildPlatform.Android, androidApkBlobUrl, buildEnvConfig,
                    _appBuildsConfig.GCloudProjectId,
                    await GetKeySha256Fingerprint(jksPath, keyPassword, keyAlias, false),
                    await GetDebugKeySha256Fingerprint(false));
                
                // Build iOS 
                var iosArchivePath = await BuildIosArchive(flutterAppPath, buildEnvConfig);
                

                // Upload iOS archive to Azure Blob Storage
                var iosArchiveBlobUrl =
                    await UploadBuildToAzureStorage(iosArchivePath, BuildPlatform.Ios, buildEnvConfig);


                var fastlaneServiceAccount =
                    await firebaseService.GetFcmServiceAccountJsonCredential(_appBuildsConfig.GCloudProjectId);
                if (fastlaneServiceAccount != null)
                {
                    var filePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets",
                        fastlaneServiceAccount);
                    await FastlaneDeployFirebase(flutterAppPath, _appBuildsConfig,
                        Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets", "service-account.json"));
                }

                // Publish iOS build message to Redis
                await PublishBuildMessageToRedis(BuildPlatform.Ios, iosArchiveBlobUrl, buildEnvConfig,
                    _appBuildsConfig.GCloudProjectId);

                // Clean up project files
                // CleanupProjectFiles(projectPath);
            }
            catch (Exception ex)
            {
                // Log the exception
                Console.WriteLine($"Error in HandleBuild: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");

                // Rethrow the exception to be handled by the caller
                throw;
            }
        }

        private async Task FastlaneDeployFirebase(string flutterAppPath, AppBuildsConfig appBuildsConfig,
            string filePath)
        {
            var androidPath = Path.Combine(flutterAppPath, "android");
            var envName = "test";
            var envFlavorName = "FLAVOR_NAME";
            var envFirebaseApp = "FIREBASE_APP";
            var envTester = "TESTERS";
            var envGroups = "GROUPS";
            var envFirebaseToken = "FIREBASE_TOKEN";

            using var stream =
                new MemoryStream(File.ReadAllBytes(filePath));
            var _credential = GoogleCredential.FromStream(stream)
                .CreateScoped((new string[]
                    {
                        "https://www.googleapis.com/auth/firebase.messaging",
                        "https://www.googleapis.com/auth/cloud-platform",
                        "https://www.googleapis.com/auth/iam",
                        "https://www.googleapis.com/auth/cloudplatformprojects",
                        "https://www.googleapis.com/auth/firebase",
                        FirebaseManagementService.ScopeConstants.Firebase,
                        FirebaseManagementService.ScopeConstants.CloudPlatform
                    }).Distinct()
                );

            var outputDir = Path.Combine(flutterAppPath, "build", "app", "outputs", "flutter-apk");
            var apkFileName = $"app-{appBuildsConfig.Flavor}-release.apk";
            var apkFilePath = Path.Combine(outputDir, apkFileName);

            var firebaseSetupManager = new FirebaseSetupManager(
                _credential,
                appBuildsConfig.GCloudProjectId
            );

            var androidAppConfig = await firebaseSetupManager.GetAndroidConfig(appBuildsConfig.PackageNameAndroid);
            var groupAlias = appBuildsConfig.PackageNameAndroid.ToLowerInvariant().Split(".").Last();

            try
            {
                await RunFirebaseCommand<FirebaseGroupsResponse>(flutterAppPath, appBuildsConfig.GCloudProjectId,
                    filePath,
                    $"appdistribution:distribute --app=\"{androidAppConfig.AppId}\" --groups=\"{groupAlias}\" {apkFilePath}");
            }
            catch (Exception e)
            {
                _outputStore.AppendOutput(_jobId, e.ToString());
            }

            try
            {
                var keyPath = Path.Combine(flutterAppPath, "flavors", appBuildsConfig.Flavor, "key.p8");
                var keySource = Environment.GetEnvironmentVariable("APP_STORE_CONNECT_KEY_FILE") ?? throw new InvalidOperationException("Configure APP_STORE_CONNECT_KEY_FILE for legacy Apple automation.");
                var keyFile = new FileInfo(keySource);
                if (!Path.IsPathFullyQualified(keySource) || !keyFile.Exists || keyFile.LinkTarget != null || keyFile.Length > 65536)
                    throw new InvalidOperationException("Use an absolute regular private App Store Connect key file.");
                if (!OperatingSystem.IsWindows() && (File.GetUnixFileMode(keySource) &
                    (UnixFileMode.GroupRead | UnixFileMode.GroupWrite | UnixFileMode.GroupExecute |
                     UnixFileMode.OtherRead | UnixFileMode.OtherWrite | UnixFileMode.OtherExecute)) != 0)
                    throw new InvalidOperationException("App Store Connect key file must be accessible only to its owner.");
                File.Copy(keySource, keyPath, overwrite: false);

                var iosConfig = await firebaseSetupManager.GetIosConfig(appBuildsConfig.PackageNameIos);

                try
                {
                    var appfilePath = Path.Combine(flutterAppPath, "ios", "fastlane", "Appfile");
                    if (File.Exists(appfilePath))
                    {
                        var appFileContent = File.ReadAllText(appfilePath);
                        appFileContent =
                            appFileContent.Replace("com.famizyo.storeUserApp", appBuildsConfig.PackageNameIos);
                        File.WriteAllText(appfilePath, appFileContent);
                    }

                    var fastfilePath = Path.Combine(flutterAppPath, "ios", "fastlane", "Fastfile");
                    if (File.Exists(fastfilePath))
                    {
                        var fastFileContent = File.ReadAllText(fastfilePath);
                        fastFileContent = fastFileContent.Replace("flavor", appBuildsConfig.Flavor);
                        fastFileContent = fastFileContent.Replace("keyfilepath", keyPath);
                        File.WriteAllText(fastfilePath, fastFileContent);
                    }

                    await RunProcessWithOutput("fastlane",
                        arguments: "produce create",
                        workingDirectory: Path.Combine(flutterAppPath, "ios", "fastlane"),
                        environmentVariables: new Dictionary<string, string>
                        {
                            { "KEY_ID", Environment.GetEnvironmentVariable("APP_STORE_CONNECT_KEY_ID") ?? throw new InvalidOperationException("Configure APP_STORE_CONNECT_KEY_ID for legacy Apple automation.") },
                            { "ISSUER_ID", Environment.GetEnvironmentVariable("APP_STORE_CONNECT_ISSUER_ID") ?? throw new InvalidOperationException("Configure APP_STORE_CONNECT_ISSUER_ID for legacy Apple automation.") },
                            { "PRODUCE_USERNAME", Environment.GetEnvironmentVariable("FASTLANE_USER") ?? throw new InvalidOperationException("Configure FASTLANE_USER for legacy Apple automation.") },
                            { "PRODUCE_APP_IDENTIFIER", appBuildsConfig.PackageNameIos },
                            { "PRODUCE_APP_NAME", appBuildsConfig.AppTitle },
                            { "PRODUCE_SKU", appBuildsConfig.PackageNameIos },
                            { "PRODUCE_VERSION", appBuildsConfig.Version },
                            { "PRODUCE_PLATFORM", "ios" },
                            { "PRODUCE_COMPANY_NAME", Environment.GetEnvironmentVariable("FASTLANE_USER") ?? throw new InvalidOperationException("Configure FASTLANE_USER for legacy Apple automation.") },
                            { "PRODUCE_LANGUAGE", "tr" },
                            { "LC_ALL", "en_US.UTF-8" },
                            { "LANG", "en_US.UTF-8" }
                        },
                        null, null
                    );

                    await RunProcessWithOutput("fastlane",
                        arguments: "pem -m ios",
                        workingDirectory: Path.Combine(flutterAppPath, "ios", "fastlane"),
                        environmentVariables: new Dictionary<string, string>
                        {
                            { "KEY_ID", Environment.GetEnvironmentVariable("APP_STORE_CONNECT_KEY_ID") ?? throw new InvalidOperationException("Configure APP_STORE_CONNECT_KEY_ID for legacy Apple automation.") },
                            { "ISSUER_ID", Environment.GetEnvironmentVariable("APP_STORE_CONNECT_ISSUER_ID") ?? throw new InvalidOperationException("Configure APP_STORE_CONNECT_ISSUER_ID for legacy Apple automation.") },
                            { "PRODUCE_USERNAME", Environment.GetEnvironmentVariable("FASTLANE_USER") ?? throw new InvalidOperationException("Configure FASTLANE_USER for legacy Apple automation.") },
                            { "PRODUCE_APP_IDENTIFIER", appBuildsConfig.PackageNameIos },
                            { "PRODUCE_APP_NAME", appBuildsConfig.AppTitle },
                            { "PRODUCE_SKU", appBuildsConfig.PackageNameIos },
                            { "PRODUCE_VERSION", appBuildsConfig.Version },
                            { "PRODUCE_PLATFORM", "ios" },
                            { "PRODUCE_COMPANY_NAME", Environment.GetEnvironmentVariable("FASTLANE_USER") ?? throw new InvalidOperationException("Configure FASTLANE_USER for legacy Apple automation.") },
                            { "PRODUCE_LANGUAGE", "tr" },
                            { "LC_ALL", "en_US.UTF-8" },
                            { "LANG", "en_US.UTF-8" }
                        },
                        null, null
                    );

                    await RunProcessWithOutput("fastlane",
                        arguments: "produce enable_services --push-notification",
                        workingDirectory: Path.Combine(flutterAppPath, "ios", "fastlane"),
                        environmentVariables: new Dictionary<string, string>
                        {
                            { "KEY_ID", Environment.GetEnvironmentVariable("APP_STORE_CONNECT_KEY_ID") ?? throw new InvalidOperationException("Configure APP_STORE_CONNECT_KEY_ID for legacy Apple automation.") },
                            { "ISSUER_ID", Environment.GetEnvironmentVariable("APP_STORE_CONNECT_ISSUER_ID") ?? throw new InvalidOperationException("Configure APP_STORE_CONNECT_ISSUER_ID for legacy Apple automation.") },
                            { "PRODUCE_USERNAME", Environment.GetEnvironmentVariable("FASTLANE_USER") ?? throw new InvalidOperationException("Configure FASTLANE_USER for legacy Apple automation.") },
                            { "PRODUCE_APP_IDENTIFIER", appBuildsConfig.PackageNameIos },
                            { "PRODUCE_APP_NAME", appBuildsConfig.AppTitle },
                            { "PRODUCE_SKU", appBuildsConfig.PackageNameIos },
                            { "PRODUCE_VERSION", appBuildsConfig.Version },
                            { "PRODUCE_PLATFORM", "ios" },
                            { "PRODUCE_COMPANY_NAME", Environment.GetEnvironmentVariable("FASTLANE_USER") ?? throw new InvalidOperationException("Configure FASTLANE_USER for legacy Apple automation.") },
                            { "PRODUCE_LANGUAGE", "tr" },
                            { "LC_ALL", "en_US.UTF-8" },
                            { "LANG", "en_US.UTF-8" }
                        },
                        null, null
                    );
                }
                catch (Exception e)
                {
                    _outputStore.AppendOutput(_jobId, e.ToString());
                }

                try
                {
                    var ipaFolderPath = Path.Combine(flutterAppPath, "build", "ios", "ipa");
                    var findIpaFile = Directory.GetFiles(ipaFolderPath, "*.ipa", SearchOption.AllDirectories);
                    if (findIpaFile.Length == 0)
                    {
                        throw new Exception("Ipa file not found");
                    }

                    await RunFirebaseCommand<FirebaseGroupsResponse>(flutterAppPath, appBuildsConfig.GCloudProjectId,
                        filePath,
                        $"appdistribution:distribute --app=\"{iosConfig.AppId}\" --groups=\"{groupAlias}\" \"{findIpaFile.First()}\"");
                }
                catch (Exception e)
                {
                    _outputStore.AppendOutput(_jobId, e.ToString());
                }


                await RunProcessWithOutput("fastlane",
                    arguments: "beta",
                    workingDirectory: Path.Combine(flutterAppPath, "ios", "fastlane"),
                    environmentVariables: new Dictionary<string, string>
                    {
                        { "KEY_ID", Environment.GetEnvironmentVariable("APP_STORE_CONNECT_KEY_ID") ?? throw new InvalidOperationException("Configure APP_STORE_CONNECT_KEY_ID for legacy Apple automation.") },
                        { "ISSUER_ID", Environment.GetEnvironmentVariable("APP_STORE_CONNECT_ISSUER_ID") ?? throw new InvalidOperationException("Configure APP_STORE_CONNECT_ISSUER_ID for legacy Apple automation.") },
                        { "CONTACT_PHONE", Environment.GetEnvironmentVariable("APP_STORE_CONNECT_CONTACT_PHONE") ?? throw new InvalidOperationException("Configure APP_STORE_CONNECT_CONTACT_PHONE for legacy Apple automation.") },
                        { "TESTER_GROUP", "business_owner" }
                    },
                    null, null
                );
            }
            catch (Exception e)
            {
                _outputStore.AppendOutput(_jobId, e.ToString());
            }
        }

        private async Task<T?> RunFirebaseCommand<T>(string flutterAppPath, string gcloudProject,
            string serviceAccountPath, string commands)
        {
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "firebase",
                    Arguments = commands + $" --project=\"{gcloudProject}\" --non-interactive -j",
                    WorkingDirectory = flutterAppPath,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true,
                    Environment = { }
                }
            };

            process.StartInfo.Environment["GOOGLE_APPLICATION_CREDENTIALS"] = serviceAccountPath;

            var outputBuilder = new StringBuilder();
            var errorBuilder = new StringBuilder();

            process.OutputDataReceived += (sender, e) =>
            {
                if (e.Data != null)
                {
                    outputBuilder.AppendLine(e.Data);
                    _outputStore.AppendOutput(_jobId, e.Data);
                }
            };

            process.ErrorDataReceived += (sender, e) =>
            {
                if (e.Data != null)
                {
                    errorBuilder.AppendLine(e.Data);
                    _outputStore.AppendOutput(_jobId, e.Data);
                }
            };

            process.Start();
            process.BeginOutputReadLine();
            process.BeginErrorReadLine();

            await process.WaitForExitAsync();

            if (process.ExitCode != 0)
            {
                _outputStore.AppendOutput(_jobId,
                    $"Flutter command '{commands}' failed with exit code {process.ExitCode}. Error: {errorBuilder}");
                throw new Exception(
                    $"Flutter command '{commands}' failed with exit code {process.ExitCode}. Error: {errorBuilder}");
            }
            else
            {
                var input = outputBuilder.ToString();

                var result = JsonSerializer.Deserialize<T>(input);

                return result;
            }
        }

        private async Task<(string? sucess, string error)> RunProcessWithOutput(
            string fileName,
            string arguments,
            string workingDirectory,
            Dictionary<string, string>? environmentVariables,
            Func<string, Task>? outputHandler,
            Func<string, Task>? errorHandler)
        {
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = fileName,
                    Arguments = arguments,
                    WorkingDirectory = workingDirectory,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true,
                    Environment = { }
                }
            };

            if (environmentVariables != null)
            {
                foreach (var e in environmentVariables)
                {
                    process.StartInfo.Environment.TryAdd(e.Key, e.Value);
                }
            }


            var outputBuilder = new StringBuilder();
            var errorBuilder = new StringBuilder();

            process.OutputDataReceived += (sender, e) =>
            {
                if (e.Data != null)
                {
                    outputBuilder.AppendLine(e.Data);
                    if (outputHandler != null)
                    {
                        outputHandler(e.Data);
                    }

                    _outputStore.AppendOutput(_jobId, e.Data);
                }
            };

            process.ErrorDataReceived += (sender, e) =>
            {
                if (e.Data != null)
                {
                    errorBuilder.AppendLine(e.Data);

                    if (errorHandler != null)
                    {
                        errorHandler(e.Data);
                    }

                    _outputStore.AppendOutput(_jobId, e.Data);
                }
            };

            process.Start();
            process.BeginOutputReadLine();
            process.BeginErrorReadLine();

            await process.WaitForExitAsync();


            return (outputBuilder.ToString(), errorBuilder.ToString());
        }

        private async Task RunFlutterFireCli(string flutterAppPath, AppBuildsConfig appBuildsConfig, string filePath)
        {
            _outputStore.AppendOutput(_jobId, $"RunFlutterFireCli started  {flutterAppPath}:");
            using var stream =
                new MemoryStream(File.ReadAllBytes(filePath));
            var _credential = GoogleCredential.FromStream(stream)
                    .CreateScoped((new string[]
                        {
                            "https://www.googleapis.com/auth/firebase.messaging",
                            "https://www.googleapis.com/auth/cloud-platform",
                            "https://www.googleapis.com/auth/iam",
                            "https://www.googleapis.com/auth/cloudplatformprojects",
                            "https://www.googleapis.com/auth/firebase",
                            FirebaseManagementService.ScopeConstants.Firebase,
                            FirebaseManagementService.ScopeConstants.CloudPlatform
                        }).Distinct()
                    )
                ;
            var acsToken = await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
            var arguments = $"config --project={appBuildsConfig.GCloudProjectId} " +
                            $"--ios-bundle-id={appBuildsConfig.PackageNameIos} " +
                            $"--ios-build-config=\"Release-{appBuildsConfig.Flavor}\" " +
                            $"--android-package-name={appBuildsConfig.PackageNameAndroid} " +
                            "--yes " +
                            $"--out=lib/firebase_options_{appBuildsConfig.Flavor.ToLowerInvariant()}.dart " +
                            $"--ios-out=ios/flavors/{appBuildsConfig.Flavor}/GoogleService-Info.plist " +
                            $"--android-out=android/app/src/{appBuildsConfig.Flavor}/google-services.json " +
                            $"--token=\"{acsToken}\" " +
                            $"--service-account={filePath} " +
                            "-f ";

            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "flutterfire",
                    Arguments = arguments,
                    WorkingDirectory = flutterAppPath,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                }
            };

            var outputBuilder = new StringBuilder();
            var errorBuilder = new StringBuilder();

            process.OutputDataReceived += (sender, e) =>
            {
                if (e.Data != null)
                {
                    outputBuilder.AppendLine(e.Data);
                    _outputStore.AppendOutput(_jobId, e.Data);
                }
            };

            process.ErrorDataReceived += (sender, e) =>
            {
                if (e.Data != null)
                {
                    errorBuilder.AppendLine(e.Data);
                    _outputStore.AppendOutput(_jobId, e.Data);
                }
            };

            process.Start();
            process.BeginOutputReadLine();
            process.BeginErrorReadLine();

            await process.WaitForExitAsync();

            if (process.ExitCode != 0)
            {
                _outputStore.AppendOutput(_jobId,
                    $"Flutter command '{arguments}' failed with exit code {process.ExitCode}. Error: {errorBuilder}");
                throw new Exception(
                    $"Flutter command '{arguments}' failed with exit code {process.ExitCode}. Error: {errorBuilder}");
            }
            else
            {
                var fcmServiceFile = Path.Combine(flutterAppPath, "lib/core/services/fcm_service.dart");
                if (File.Exists(fcmServiceFile))
                {
                    var fcServiceFileContent = await File.ReadAllTextAsync(fcmServiceFile);
                    //
                    fcServiceFileContent = fcServiceFileContent.Replace(
                        "import 'package:store_user_app/firebase_options.dart'",
                        $"import 'package:store_user_app/firebase_options_{appBuildsConfig.Flavor.ToLowerInvariant()}.dart'");
                    await File.WriteAllTextAsync(fcmServiceFile, fcServiceFileContent);
                }

                var mainDart = Path.Combine(flutterAppPath, "lib/main.dart");
                if (File.Exists(mainDart))
                {
                    var mainFileContet = await File.ReadAllTextAsync(mainDart);
                    //
                    mainFileContet = mainFileContet.Replace(
                        "import 'package:store_user_app/firebase_options.dart'",
                        $"import 'package:store_user_app/firebase_options_{appBuildsConfig.Flavor.ToLowerInvariant()}.dart'");
                    await File.WriteAllTextAsync(mainDart, mainFileContet);
                }
            }
        }

        private async Task CloneRepository(string projectPath)
        {
            // If the directory already exists, delete it
            if (Directory.Exists(projectPath))
            {
                Directory.Delete(projectPath, true);
            }

            // Create the directory
            Directory.CreateDirectory(projectPath);

            var nodeInstallerPath = Environment.GetEnvironmentVariable("NodeInstallerPath");

            var processStartInfo = new ProcessStartInfo
            {
                FileName = "git",
                Arguments = $"clone {_gitRepositoryUrl} {projectPath}",
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                EnvironmentVariables = { }
            };

            using var process = new Process { StartInfo = processStartInfo };

            process.OutputDataReceived += (sender, args) =>
            {
                if (!string.IsNullOrEmpty(args.Data))
                {
                    _outputStore?.AppendOutput(_jobId!, $"Process Output: {args.Data}");
                }
            };

            process.ErrorDataReceived += (sender, args) =>
            {
                if (!string.IsNullOrEmpty(args.Data))
                {
                    _outputStore?.AppendOutput(_jobId!, $"Process Error: {args.Data}");
                }
            };

            process.Start();
            process.BeginOutputReadLine();
            process.BeginErrorReadLine();

            await process.WaitForExitAsync();

            if (process.ExitCode != 0)
            {
                var allOutput = _outputStore.GetOutput(_jobId);
                _outputStore.AppendOutput(_jobId, $"Git clone error {process.ExitCode}. Error: {allOutput}");
                throw new Exception($"Git clone error {process.ExitCode}. Error: {allOutput}");
            }
        }

        private async Task DownloadIcon(string iconUrl, string destinationPath)
        {
            if (iconUrl.StartsWith(_blobStorageUrl))
            {
                // Download from Azure Blob Storage
                var blobUri = new Uri(iconUrl);
                var containerName = blobUri.Segments[1].TrimEnd('/');
                var blobName = string.Join("", blobUri.Segments.Skip(2));

                var containerClient = _blobServiceClient.GetBlobContainerClient(containerName);
                var blobClient = containerClient.GetBlobClient(blobName);

                await blobClient.DownloadToAsync(destinationPath);
                _outputStore.AppendOutput(_jobId, $"Icon downloaded from Azure Blob Storage URL: {iconUrl}");
            }
            else
            {
                // Download from HTTP URL
                using var response = await _httpClient.GetAsync(iconUrl);
                response.EnsureSuccessStatusCode();

                using var stream = await response.Content.ReadAsStreamAsync();
                using var fileStream = File.Create(destinationPath);

                await stream.CopyToAsync(fileStream);
                _outputStore.AppendOutput(_jobId, $"Icon downloaded from Http URL: {iconUrl}");
            }
        }


        private async Task DownloadLogo(string iconUrl, string destinationPath)
        {
            if (iconUrl.StartsWith(_blobStorageUrl))
            {
                // Download from Azure Blob Storage
                var blobUri = new Uri(iconUrl);
                var containerName = blobUri.Segments[1].TrimEnd('/');
                var blobName = string.Join("", blobUri.Segments.Skip(2));

                var containerClient = _blobServiceClient.GetBlobContainerClient(containerName);
                var blobClient = containerClient.GetBlobClient(blobName);

                await blobClient.DownloadToAsync(destinationPath);
                _outputStore.AppendOutput(_jobId, $"Logo downloaded from Azure Blob Storage URL: {iconUrl}");
            }
            else
            {
                // Download from HTTP URL
                using var response = await _httpClient.GetAsync(iconUrl);
                response.EnsureSuccessStatusCode();

                using var stream = await response.Content.ReadAsStreamAsync();
                using var fileStream = File.Create(destinationPath);

                await stream.CopyToAsync(fileStream);
                _outputStore.AppendOutput(_jobId, $"Logo downloaded from Http URL: {iconUrl}");
            }
        }

        private async Task CreateEntitlementsFile(string filePath)
        {
            var content = iosEntitlementsTemplate.Replace("{storeUrl}", new Uri(_appBuildsConfig.StoreUrl).Host);

            Directory.CreateDirectory(Path.GetDirectoryName(filePath));
            await File.WriteAllTextAsync(filePath, content);
            _outputStore.AppendOutput(_jobId, $"Entitlements created Content: {content}");
        }

        private async Task CreateFlavorizrFile(string filePath, string iconPath)
        {
            var storeUrl = new Uri(_appBuildsConfig.StoreUrl).Host;
            var content = flavorizrYamlTemplate
                .Replace("{flavorName}", _appBuildsConfig.Flavor)
                .Replace("{label}", _appBuildsConfig.AppTitle)
                .Replace("{iconPath}", iconPath)
                .Replace("{androidPackageName}", _appBuildsConfig.PackageNameAndroid)
                .Replace("{iosPackageName}", _appBuildsConfig.PackageNameIos)
                .Replace("{storeUrl}", storeUrl);

            await File.WriteAllTextAsync(filePath, content);
            _outputStore.AppendOutput(_jobId, $"Flavorizr created Content: {content}");
        }

        private async Task CreateLauncherIconsFile(string filePath, string iconPath)
        {
            var content = flutterLauncherIconsYamlTemplate
                .Replace("{iconPath}", iconPath);

            await File.WriteAllTextAsync(filePath, content);

            _outputStore.AppendOutput(_jobId, $"LauncherIcons file created Content: {content}");
        }

        private async Task CreateNativeSplashFile(string filePath, string iconPath)
        {
            var content = flutterNativeSplashYamlTemplate
                .Replace("{iconPath}", iconPath);

            await File.WriteAllTextAsync(filePath, content);

            _outputStore.AppendOutput(_jobId, $"NativeSplash file created Content: {content}");
        }

        private async Task RunFlutterCommand(string workingDirectory, string arguments)
        {
            _outputStore.AppendOutput(_jobId, $"RunFlutterCommand started  {workingDirectory}: {arguments}");

            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "flutter",
                    Arguments = arguments,
                    WorkingDirectory = workingDirectory,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                }
            };

            var outputBuilder = new StringBuilder();
            var errorBuilder = new StringBuilder();

            process.OutputDataReceived += (sender, e) =>
            {
                if (e.Data != null)
                {
                    outputBuilder.AppendLine(e.Data);
                    _outputStore.AppendOutput(_jobId, e.Data);
                }
            };

            process.ErrorDataReceived += (sender, e) =>
            {
                if (e.Data != null)
                {
                    errorBuilder.AppendLine(e.Data);
                    _outputStore.AppendOutput(_jobId, e.Data);
                }
            };

            process.Start();
            process.BeginOutputReadLine();
            process.BeginErrorReadLine();

            await process.WaitForExitAsync();

            if (process.ExitCode != 0)
            {
                _outputStore.AppendOutput(_jobId,
                    $"Flutter command '{arguments}' failed with exit code {process.ExitCode}. Error: {errorBuilder}");
                throw new Exception(
                    $"Flutter command '{arguments}' failed with exit code {process.ExitCode}. Error: {errorBuilder}");
            }
        }

        private void ReplaceAppIconPath(string flutterAppPath)
        {
            var sourceDir = Path.Combine(flutterAppPath, "ios", "Runner", "Assets.xcassets",
                $"AppIcon-{_appBuildsConfig.Flavor}.appiconset");
            var destDir = Path.Combine(flutterAppPath, "ios", "Runner", "Assets.xcassets",
                $"{_appBuildsConfig.Flavor}AppIcon.appiconset");

            if (Directory.Exists(sourceDir))
            {
                if (Directory.Exists(destDir))
                    Directory.Delete(destDir, true);
                CopyDirectory(sourceDir, destDir, true);
            }

            _outputStore.AppendOutput(_jobId, $"AppIcon set created: {sourceDir} -> {destDir}");
        }

        void CopyDirectory(string sourceDir, string destinationDir, bool recursive)
        {
            // Get information about the source directory
            var dir = new DirectoryInfo(sourceDir);

            // Check if the source directory exists
            if (!dir.Exists)
                throw new DirectoryNotFoundException($"Source directory not found: {dir.FullName}");

            // Cache directories before we start copying
            DirectoryInfo[] dirs = dir.GetDirectories();

            // Create the destination directory
            Directory.CreateDirectory(destinationDir);

            // Get the files in the source directory and copy to the destination directory
            foreach (FileInfo file in dir.GetFiles())
            {
                string targetFilePath = Path.Combine(destinationDir, file.Name);
                file.CopyTo(targetFilePath);
            }

            // If recursive and copying subdirectories, recursively call this method
            if (recursive)
            {
                foreach (DirectoryInfo subDir in dirs)
                {
                    string newDestinationDir = Path.Combine(destinationDir, subDir.Name);
                    CopyDirectory(subDir.FullName, newDestinationDir, true);
                }
            }
        }

        private void ReplaceLaunchScreenPath(string flutterAppPath)
        {
            //ios/Runner/Base.lproj
            var sourceFile = Path.Combine(flutterAppPath, "ios", "Runner", "Base.lproj",
                $"LaunchScreen{_appBuildsConfig.Flavor}.storyboard");
            var destFile = Path.Combine(flutterAppPath, "ios", "Runner",
                $"{_appBuildsConfig.Flavor}LaunchScreen.storyboard");

            if (File.Exists(sourceFile))
            {
                var sorceContent = File.ReadAllText(sourceFile);
                File.Delete(sourceFile);
                File.WriteAllText(destFile, sorceContent);
            }

            _outputStore.AppendOutput(_jobId, $"LaunchScreen file created: {sourceFile} -> {destFile}");
        }

        private async Task<(string jksPath, string keyPassword, string keyAlias, string keyAliasPassword)>
            CreateAndroidSigningKey(string flutterAppPath)
        {
            var keysDir = Path.Combine(flutterAppPath, "android", "app", "keys");
            Directory.CreateDirectory(keysDir);

            var jksPath = Path.Combine(keysDir, $"{_appBuildsConfig.Flavor}.jks");
            var secretName = $"{_appBuildsConfig.Flavor}-android-signing-key";

            try
            {
                // if (!File.Exists(jksPath))
                // {
                //     throw new Exception("Jks not found");
                // }
                var secretValue = await _tenantSecrets.GetAsync(_appBuildsConfig.AuthClientId, TenantSecretNames.AndroidSigningKey);
                var keyVaultSecret = JsonSerializer.Deserialize<KeyVaultSecretModel>(secretValue);
                if (keyVaultSecret == null)
                {
                    throw new Exception("Secret not converted");
                }

                var jksArrayFromBase64String = Convert.FromBase64String(keyVaultSecret.KeyBase64);
                
                await File.WriteAllBytesAsync(jksPath, jksArrayFromBase64String);

                return (jksPath, keyVaultSecret.KeyPassword, keyVaultSecret.KeyAlias, keyVaultSecret.KeyAliasPassword);
            }
            catch (KeyNotFoundException)
            {
                var keyPassword = GeneratePassword();
                var keyAlias = $"{_appBuildsConfig.Flavor.ToLowerInvariant()}keyalias";
                var keyAliasPassword = keyPassword; //GeneratePassword();

                if (!File.Exists(jksPath))
                {
                    var process = new Process
                    {
                        StartInfo = new ProcessStartInfo
                        {
                            FileName = "keytool",
                            Arguments =
                                $"-genkey -v -keystore \"{jksPath}\" -alias {keyAlias} -keyalg RSA -keysize 2048 -validity 10000 -storepass {keyPassword} -dname \"CN={_appBuildsConfig.PackageNameAndroid}, OU={_appBuildsConfig.Flavor}, O=Company, L=Izmir, S=Karsiyaka, C=TR\"",
                            RedirectStandardOutput = true,
                            RedirectStandardError = true,
                            UseShellExecute = false,
                            CreateNoWindow = true
                        }
                    };

                    process.Start();
                    await process.WaitForExitAsync();

                    if (process.ExitCode != 0)
                    {
                        _outputStore.AppendOutput(_jobId,
                            $"Failed to create Android signing key. Exit code: {process.ExitCode}");
                        throw new Exception($"Failed to create Android signing key. Exit code: {process.ExitCode}");
                    }
                }

                _outputStore.AppendOutput(_jobId, "Android signing key created");
                var candidate = JsonSerializer.Serialize(KeyVaultSecretModel.FromParameters(
                    Convert.ToBase64String(await File.ReadAllBytesAsync(jksPath)), keyPassword, keyAlias, keyAliasPassword));
                var winner = await _tenantSecrets.GetOrCreateAsync(_appBuildsConfig.AuthClientId,
                    TenantSecretNames.AndroidSigningKey, () => candidate);
                var persisted = JsonSerializer.Deserialize<KeyVaultSecretModel>(winner)!;
                await File.WriteAllBytesAsync(jksPath, Convert.FromBase64String(persisted.KeyBase64));
                return (jksPath, persisted.KeyPassword, persisted.KeyAlias, persisted.KeyAliasPassword);
            }
        }

        private async Task<string> GetKeySha256Fingerprint(string jksPath, string keyPassword, string keyAlias,
            bool reduce = true)
        {
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "keytool",
                    Arguments = $"-list -v -keystore \"{jksPath}\" -alias {keyAlias} -storepass \"{keyPassword}\"",
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                }
            };

            process.Start();
            var output = await process.StandardOutput.ReadToEndAsync();
            await process.WaitForExitAsync();

            var sha256Line = output.Split('\n')
                .FirstOrDefault(l => l.Trim().StartsWith("SHA256:"));

            if (sha256Line == null)
            {
                _outputStore.AppendOutput(_jobId, "Could not find SHA256 fingerprint in keytool output");

                throw new Exception("Could not find SHA256 fingerprint in keytool output");
            }

            _outputStore.AppendOutput(_jobId, $"SHA256 fingerprint: {sha256Line}");
            if (reduce)
                return string.Join("",
                    sha256Line.Split(':')[1..].Select((p) => p.Trim()).Where((p) => !string.IsNullOrEmpty(p)));
            else
            {
                return string.Join("",
                    sha256Line.Replace("SHA256:", "").Select((p) => p.ToString().Trim())
                        .Where((p) => !string.IsNullOrEmpty(p)));
            }
        }

        private async Task<string> GetDebugKeySha256Fingerprint(bool reduce = true)
        {
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "keytool",
                    Arguments =
                        $"-list -v -keystore /workspace/.android/debug.keystore -alias androiddebugkey -storepass android",
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                }
            };

            process.Start();
            var output = await process.StandardOutput.ReadToEndAsync();
            await process.WaitForExitAsync();

            var sha256Line = output.Split('\n')
                .FirstOrDefault(l => l.Trim().StartsWith("SHA256:"));

            if (sha256Line == null)
            {
                _outputStore.AppendOutput(_jobId, "Could not find SHA256 fingerprint in keytool output");

                throw new Exception("Could not find SHA256 fingerprint in keytool output");
            }

            _outputStore.AppendOutput(_jobId, $"SHA256 fingerprint: {sha256Line}");
            if (reduce)
            {
                return string.Join("",
                    sha256Line.Split(':')[1..].Select((p) => p.Trim()).Where((p) => !string.IsNullOrEmpty(p)));
            }
            else
            {
                return string.Join("",
                    sha256Line.Replace("SHA256:", "").Select((p) => p.ToString().Trim())
                        .Where((p) => !string.IsNullOrEmpty(p)));
            }
        }

        private String GetKeyPropertiesFileContent(string jksPath, string keyPassword, string keyAlias,
            string keyAliasPassword)
        {
            var template = @$"
storePassword={keyPassword}
keyPassword={keyAliasPassword}
keyAlias={keyAlias}
storeFile={jksPath}
";
            return template;
        }

        private async Task InsertSigningOptionsInBuildGradle(string flutterAppPath, string jksPath, string keyPassword,
            string keyAlias, string keyAliasPassword)
        {
            var keyPropertiesPath = Path.Combine(flutterAppPath, "android", "key.properties");
            var content = GetKeyPropertiesFileContent(jksPath, keyPassword, keyAlias, keyAliasPassword);
            await File.WriteAllTextAsync(keyPropertiesPath, content);

//             var buildGradlePath = Path.Combine(flutterAppPath, "android", "app", "build.gradle.kts");
//             var buildGradleContent = await File.ReadAllTextAsync(buildGradlePath);
//
//             // Check if signing config already exists
//             if (buildGradleContent.Contains("//releaseSignConfig"))
//             {
//                 var escapedChars = new List<char>()
//                 {
//                     '$'
//                 };
//                 // Create signing config section
//                 var signingConfig = $@"
//     create(""release"") {{
//                 keyAlias = keystoreProperties[""keyAlias""] as String
//                 keyPassword = keystoreProperties[""keyPassword""] as String
//                 storeFile = keystoreProperties[""storeFile""]?.let {{ file(it) }}
//                 storePassword = keystoreProperties[""storePassword""] as String
//             }}
// ";
//
//                 // Replace the android section with our modified one including signing config
//                 buildGradleContent = buildGradleContent.Replace(
//                     "//releaseSignConfig",
//                     signingConfig);
//
//                 await File.WriteAllTextAsync(buildGradlePath, buildGradleContent);
//             }
        }

        private async Task UploadSigningKeyToKeyVault(string jksPath, string keyPassword, string keyAlias,
            string keyAliasPassword)
        {
            var keyBytes = await File.ReadAllBytesAsync(jksPath);
            var keyBase64 = Convert.ToBase64String(keyBytes);

            var secretName = $"{_appBuildsConfig.Flavor}-android-signing-key";
            var secretValue =
                JsonSerializer.Serialize(
                    KeyVaultSecretModel.FromParameters(keyBase64, keyPassword, keyAlias, keyAliasPassword));

            await _tenantSecrets.GetOrCreateAsync(_appBuildsConfig.AuthClientId,
                TenantSecretNames.AndroidSigningKey, () => secretValue);
        }

        private BuildEnvironmentConfig CreateBuildEnvironmentConfig(string keySha256)
        {
            return new BuildEnvironmentConfig(
                flavor: _appBuildsConfig.Flavor,
                storeUrl: _appBuildsConfig.StoreUrl,
                authUrl: _appBuildsConfig.AuthUrl,
                authRealm: _appBuildsConfig.AuthRealm,
                authClientId: _appBuildsConfig.AuthClientId,
                keycloakClientSecret: _appBuildsConfig.KeycloakClientSecret,
                storeLogo: _appBuildsConfig.StoreLogo,
                appSignatureSha256: keySha256,
                packageNameAndroid: _appBuildsConfig.PackageNameAndroid,
                packageNameIos: _appBuildsConfig.PackageNameIos,
                appTitle: _appBuildsConfig.AppTitle);
        }

        private async Task RunScreenshotScript(string flutterAppPath, BuildEnvironmentConfig buildEnvConfig)
        {
            var envVars = buildEnvConfig.ToEnvDictionary();
            envVars["APP_SIGNATURE_SHA256"] = await GetDebugKeySha256Fingerprint();
            await File.WriteAllTextAsync(Path.Combine(flutterAppPath, "env.json"), JsonSerializer.Serialize((envVars)));

            var screenshotScriptPath = Path.Combine("scripts", "screenshot.dart");
            var defines = string.Join(" ", buildEnvConfig.ToDefines());
            var runArguments =
                $" run {string.Join(" ", buildEnvConfig.ToDefines())} {screenshotScriptPath} {buildEnvConfig.Flavor}";
            await File.WriteAllTextAsync(Path.Combine(flutterAppPath, "screenshot_args.txt"), runArguments);
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "dart",
                    Arguments = runArguments,
                    WorkingDirectory = flutterAppPath,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true,
                }
            };

            // Add environment variables
            // foreach (var envVar in envVars)
            // {
            //     process.StartInfo.EnvironmentVariables[envVar.Key] = envVar.Value;
            // }

            process.Start();
            await process.WaitForExitAsync();

            if (process.ExitCode != 0)
            {
                throw new Exception($"Screenshot script failed with exit code {process.ExitCode}");
            }
        }

        private async Task<List<ScreenshotModel>> ProcessAndUploadScreenshots(string projectPath)
        {
            var screenshotsPath = Path.Combine(projectPath, "screenshots");
            var screenshotModels = new List<ScreenshotModel>();

            if (!Directory.Exists(screenshotsPath))
            {
                return screenshotModels;
            }

            var screenShotFiles = Directory.GetFiles(screenshotsPath, "*.png", SearchOption.AllDirectories);
            var displayOrder = 0;

            foreach (var screenshotFile in screenShotFiles)
            {
                var relativePath = screenshotFile.Replace(screenshotsPath, "").TrimStart('\\', '/');
                var pathParts = relativePath.Split('\\', '/');

                if (pathParts.Length >= 4)
                {
                    var platformName = pathParts[0];
                    var emulatorName = pathParts[1];
                    var langName = pathParts[2];
                    var screenName = pathParts[3].Replace(".png", "");

                    // Generate a unique blob name
                    var blobName =
                        $"screenshots/{_appBuildsConfig.AuthClientId}/{_appBuildsConfig.Flavor}/{platformName}/{screenName}-{Guid.NewGuid():N}.png";

                    // Upload to blob storage
                    var containerClient = _blobServiceClient.GetBlobContainerClient("app-builds");
                    var blobClient = containerClient.GetBlobClient(blobName);

                    await blobClient.UploadAsync(screenshotFile, overwrite: true);

                    // Create screenshot model
                    var screenshotModel = new ScreenshotModel
                    {
                        BusinessAppId = Guid.Parse(_appBuildsConfig.BusinessAppId),
                        ScreenType = screenName,
                        FileName = Path.GetFileName(screenshotFile),
                        FilePath = blobClient.Uri.ToString(),
                        DisplayOrder = displayOrder++
                    };

                    screenshotModels.Add(screenshotModel);
                }
            }

            return screenshotModels;
        }

        private async Task PublishScreenshotsToRedis(List<ScreenshotModel> screenshotModels)
        {
            if (screenshotModels.Count == 0)
            {
                return;
            }

            var message = new ScreenShotsRedisMessageModel
            {
                ScreenshotModels = screenshotModels
            };

            var json = JsonSerializer.Serialize(message);
            var db = _redis.GetDatabase();

            await db.PublishAsync(SCREENSHOT_CHANNEL_NAME, json);
        }

        private async Task UpdateVersionAndBuildNumber(string flutterAppPath)
        {
            var pubspecPath = Path.Combine(flutterAppPath, "pubspec.yaml");
            var pubspecContent = await File.ReadAllTextAsync(pubspecPath);

            // Update version
            var versionLine = pubspecContent.Split('\n')
                .FirstOrDefault(l => l.TrimStart().StartsWith("version:"));

            if (versionLine != null)
            {
                // Update pubspec.yaml
                var newVersionLine = $"version: {_appBuildsConfig.Version}+{_appBuildsConfig.BuildNumber}";
                pubspecContent = pubspecContent.Replace(versionLine, newVersionLine);

                await File.WriteAllTextAsync(pubspecPath, pubspecContent);
            }
        }

        private async Task<string> BuildAndroidApk(string flutterAppPath, BuildEnvironmentConfig buildEnvConfig)
        {
            var outputDir = Path.Combine(flutterAppPath, "build", "app", "outputs", "flutter-apk");

            await File.WriteAllTextAsync(Path.Combine(flutterAppPath, "env.json"),
                JsonSerializer.Serialize(buildEnvConfig.ToEnvDictionary()));

            // Run build command
            await RunFlutterCommand(flutterAppPath,
                $"build apk --flavor {_appBuildsConfig.Flavor} --release --obfuscate --split-debug-info=./android_v{_appBuildsConfig.Version}_{_appBuildsConfig.BuildNumber} --dart-define-from-file=env.json");

            // Find the APK file
            var apkPath = Path.Combine(outputDir, $"app-{_appBuildsConfig.Flavor}-release.apk");

            if (!File.Exists(apkPath))
            {
                throw new Exception($"Android APK file not found at {apkPath}");
            }

            return apkPath;
        }

        private async Task<string> BuildIosArchive(string flutterAppPath, BuildEnvironmentConfig buildEnvConfig)
        {
            var outputDir = Path.Combine(flutterAppPath, "build", "ios", "ipa");

            await File.WriteAllTextAsync(Path.Combine(flutterAppPath, "env.json"),
                JsonSerializer.Serialize(buildEnvConfig.ToEnvDictionary()));

            // Run build command
            await RunFlutterCommand(flutterAppPath,
                $"build ipa --flavor {_appBuildsConfig.Flavor} --release --obfuscate --split-debug-info=./ios_v{_appBuildsConfig.Version}_{_appBuildsConfig.BuildNumber} --dart-define-from-file=env.json");

            // Create archive
            var ipaFiles = Directory.GetFiles(outputDir, "*.ipa", SearchOption.TopDirectoryOnly);
            if (ipaFiles.Length == 0)
            {
                throw new Exception($"iOS IPA file not found in {outputDir}");
            }

            return ipaFiles[0];
        }

        private async Task<string> UploadBuildToAzureStorage(string filePath, BuildPlatform platform,
            BuildEnvironmentConfig buildEnvConfig)
        {
            // Generate unique blob name
            var blobName =
                $"builds/{_appBuildsConfig.AuthClientId}/{_appBuildsConfig.Flavor}/{platform}/{Path.GetFileName(filePath)}";

            // Upload to blob storage
            var containerClient = _blobServiceClient.GetBlobContainerClient("app-builds");
            await containerClient.CreateIfNotExistsAsync();
            var blobClient = containerClient.GetBlobClient(blobName);

            await blobClient.UploadAsync(filePath, overwrite: true);

            return blobClient.Uri.ToString();
        }

        private async Task PublishBuildMessageToRedis(BuildPlatform platform, string filePath,
            BuildEnvironmentConfig buildEnvConfig, string gCloudProjectId, string? releaseSha256 = null,
            string? debugSha256 = null)
        {
            var message = new NewBuildRedisMessage
            {
                BusinessAppId = Guid.Parse(_appBuildsConfig.BusinessAppId),
                Version = _appBuildsConfig.Version,
                BuildNumber = _appBuildsConfig.BuildNumber,
                Platform = platform,
                FilePath = filePath,
                PackageName = platform == BuildPlatform.Android
                    ? buildEnvConfig.PackageNameAndroid
                    : buildEnvConfig.PackageNameIos,
                SigningKeysSHA256 = new List<string>()
                {
                    platform == BuildPlatform.Android ? (releaseSha256 ?? buildEnvConfig.AppSignatureSha256) : $"",
                    platform == BuildPlatform.Android ? (debugSha256 ?? "") : ""
                },
                IosAppId = $"{(Environment.GetEnvironmentVariable("APPLE_DEVELOPER_TEAM_ID") ?? throw new InvalidOperationException("Configure APPLE_DEVELOPER_TEAM_ID for legacy Apple automation."))}.{buildEnvConfig.PackageNameIos}",
                StoreGroupName = _appBuildsConfig.AuthClientId,
            };

            if (platform == BuildPlatform.Android)
            {
                var firebaseService = new FirebaseService();
                var sha256List =
                    await firebaseService.GetFirebaseAndroidSha256(gCloudProjectId, buildEnvConfig.PackageNameAndroid);
                try
                {
                    if (sha256List is { Certificates: not null })
                    {
                        message.SigningKeysSHA256 = sha256List.Certificates.Where(x => x.CertType == "SHA_256")
                            .Select(x => Sha256HasStringToSha256(x.ShaHash))
                            .ToList();

                        message.SigningKeysSHA256.AddRange(new List<string>()
                        {
                            platform == BuildPlatform.Android
                                ? (releaseSha256 ?? buildEnvConfig.AppSignatureSha256)
                                : $"",
                            platform == BuildPlatform.Android ? (debugSha256 ?? "") : ""
                        });

                        message.SigningKeysSHA256 = message.SigningKeysSHA256.Distinct().ToList();
                    }
                }
                catch (Exception e)
                {
                    _outputStore.AppendOutput(_jobId,
                        $"Error while getting SHA256 from Firebase: {e.Message}");
                }
            }

            var json = JsonSerializer.Serialize(message);
            var db = _redis.GetDatabase();

            await db.PublishAsync(NEW_BUILD_CHANNEL_NAME, json);
        }
        
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

        private void CleanupProjectFiles(string projectPath)
        {
            try
            {
                if (Directory.Exists(projectPath))
                {
                    Directory.Delete(projectPath, true);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error cleaning up project files: {ex.Message}");
                // Continue execution even if cleanup fails
            }
        }

        private string GeneratePassword()
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            var random = new Random();
            var password = new string(Enumerable.Repeat(chars, 16)
                .Select(s => s[random.Next(s.Length)]).ToArray());

            return password;
        }
    }

    public class KeyVaultSecretModel
    {
        public string KeyBase64 { get; set; }
        public string KeyPassword { get; set; }
        public string KeyAlias { get; set; }
        public string KeyAliasPassword { get; set; }

        public static KeyVaultSecretModel FromParameters(string keyBase64, string keyPassword, string keyAlias,
            string keyAliasPassword)
        {
            return new KeyVaultSecretModel()
            {
                KeyBase64 = keyBase64,
                KeyPassword = keyPassword,
                KeyAlias = keyAlias,
                KeyAliasPassword = keyAliasPassword
            };
        }
    }

    public class AppBuildsConfig
    {
        public string BusinessAppId { get; set; }
        public string GCloudProjectId { get; set; }
        public string Flavor { get; set; } = null!;
        public string StoreUrl { get; set; } = null!;
        public string AuthUrl { get; set; } = null!;
        public string AuthRealm { get; set; } = null!;
        public string AuthClientId { get; set; } = null!;
        [JsonIgnore]
        public string KeycloakClientSecret { get; set; } = null!;
        public string StoreLogo { get; set; } = null!;
        public string StoreLogoId { get; set; } = null!;
        public string StoreIcon { get; set; } = null!;
        public string PackageNameAndroid { get; set; } = null!;
        public string PackageNameIos { get; set; } = null!;
        public string AppTitle { get; set; } = null!;

        public string Version { get; set; } = null!;
        public int BuildNumber { get; set; }
    }


    public class BuildEnvironmentConfig
    {
        public string Flavor { get; }
        public string StoreUrl { get; }
        public string AuthUrl { get; }
        public string AuthRealm { get; }
        public string AuthClientId { get; }
        public string KeycloakClientSecret { get; }
        public string StoreLogo { get; }
        public string AppSignatureSha256 { get; }
        public string PackageNameAndroid { get; }
        public string PackageNameIos { get; }
        public string AppTitle { get; }

        public BuildEnvironmentConfig(
            string flavor,
            string storeUrl,
            string authUrl,
            string authRealm,
            string authClientId,
            string keycloakClientSecret,
            string storeLogo,
            string appSignatureSha256,
            string packageNameAndroid,
            string packageNameIos,
            string appTitle)
        {
            Flavor = flavor;
            StoreUrl = storeUrl;
            AuthUrl = authUrl;
            AuthRealm = authRealm;
            AuthClientId = authClientId;
            KeycloakClientSecret = keycloakClientSecret;
            StoreLogo = storeLogo;
            AppSignatureSha256 = appSignatureSha256;
            PackageNameAndroid = packageNameAndroid;
            PackageNameIos = packageNameIos;
            AppTitle = appTitle;
        }

        // Converting configuration to command line arguments equivalent to dart-define parameters
        public List<string> ToDartDefines()
        {
            return new List<string>
            {
                $"--dart-define=STORE_URL={StoreUrl}",
                $"--dart-define=AUTH_URL={AuthUrl}",
                $"--dart-define=AUTH_REALM={AuthRealm}",
                $"--dart-define=AUTH_CLIENT_ID={AuthClientId}",
                $"--dart-define=STORE_LOGO={StoreLogo}",
                $"--dart-define=APP_SIGNATURE_SHA256={AppSignatureSha256}",
                $"--dart-define=PACKAGE_NAME_ANDROID={PackageNameAndroid}",
                $"--dart-define=PACKAGE_NAME_IOS={PackageNameIos}",
                $"--dart-define=APP_TITLE={AppTitle}"
            };
        }

        public List<string> ToDefines()
        {
            return new List<string>
            {
                $"--define=STORE_URL={StoreUrl}",
                $"--define=AUTH_URL={AuthUrl}",
                $"--define=AUTH_REALM={AuthRealm}",
                $"--define=AUTH_CLIENT_ID={AuthClientId}",
                $"--define=STORE_LOGO={StoreLogo}",
                $"--define=APP_SIGNATURE_SHA256={AppSignatureSha256}",
                $"--define=PACKAGE_NAME_ANDROID={PackageNameAndroid}",
                $"--define=PACKAGE_NAME_IOS={PackageNameIos}",
                $"--define=APP_TITLE={AppTitle}"
            };
        }

        public Dictionary<string, string> ToEnvDictionary()
        {
            return new Dictionary<string, string>
            {
                ["STORE_URL"] = StoreUrl,
                ["FLAVOR"] = Flavor,
                ["AUTH_URL"] = AuthUrl,
                ["AUTH_REALM"] = AuthRealm,
                ["AUTH_CLIENT_ID"] = AuthClientId,
                ["STORE_LOGO"] = StoreLogo,
                ["APP_SIGNATURE_SHA256"] = AppSignatureSha256,
                ["PACKAGE_NAME_ANDROID"] = PackageNameAndroid,
                ["PACKAGE_NAME_IOS"] = PackageNameIos,
                ["APP_TITLE"] = AppTitle
            };
        }

        public override string ToString()
        {
            return $@"Test Configuration:
  Flavor: {Flavor}
  Store URL: {StoreUrl}
  Auth URL: {AuthUrl}
  Auth Realm: {AuthRealm}
  Auth Client ID: {AuthClientId}
  Keycloak Client Secret: {(string.IsNullOrEmpty(KeycloakClientSecret) ? "not set" : "******")}
  Store Logo: {StoreLogo}
  App Signature SHA256: {AppSignatureSha256}
  Package Name Android: {PackageNameAndroid}
  Package Name iOS: {PackageNameIos}
  App Title: {AppTitle}";
        }
    }

    class ScreenShotsRedisMessageModel
    {
        public List<ScreenshotModel> ScreenshotModels { get; set; } = new List<ScreenshotModel>();
    }

    class ScreenshotModel
    {
        public Guid BusinessAppId { get; set; }
        public string? ScreenType { get; set; }
        public string? FileName { get; set; }
        public string? FilePath { get; set; }
        public int DisplayOrder { get; set; }
    }

    public enum BuildPlatform
    {
        Ios,
        Android,
        Windows
    }

    public class NewBuildRedisMessage
    {
        public Guid BusinessAppId { get; set; }
        public string Version { get; set; } = null!;
        public int BuildNumber { get; set; }
        public BuildPlatform Platform { get; set; }
        public string FilePath { get; set; } = null!;
        public List<string> SigningKeysSHA256 { get; set; } = new List<string>();
        public string PackageName { get; set; }

        public string IosAppId { get; set; }
        public string StoreGroupName { get; set; }
    }

    public class Group
    {
        [JsonPropertyName("name")] public string Name { get; set; }

        [JsonPropertyName("displayName")] public string DisplayName { get; set; }
    }

    public class Result
    {
        [JsonPropertyName("groups")] public List<Group> Groups { get; set; }
    }

    public class FirebaseGroupsResponse
    {
        [JsonPropertyName("status")] public string Status { get; set; }

        [JsonPropertyName("result")] public Result? Result { get; set; } = new Result();
    }
}
