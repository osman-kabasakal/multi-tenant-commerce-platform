using TenantManagerClaude;

namespace TenantManager;

public class BuildManager
{
    private readonly AppBuildsConfig _appBuildsConfig;
    private readonly string _blobStorageUrl;

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
    
    
    public BuildManager(
        AppBuildsConfig appBuildsConfig,
        string blobStorageUrl
        )
    {
        _appBuildsConfig = appBuildsConfig;
        _blobStorageUrl = blobStorageUrl;
    }

    private const string SCREENSHOT_CHANNEL_NAME = "SCREENSHOTS";
    private const string NEW_BUILD_CHANNEL_NAME = "NEW_BUILD";

    public async Task HandleBuild()
    {
        var projectPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"builds",_appBuildsConfig.AuthClientId);
        //clone app from github to 

        var flutterAppPath = Path.Combine(projectPath, "Platforms", "store_user_app");
        var iconsPath = Path.Combine(flutterAppPath,"flavors",_appBuildsConfig.Flavor);
        // If icon is azure blob
        if (_appBuildsConfig.StoreIcon.StartsWith(_blobStorageUrl))
        {
            //download from azure blob storage and save icon app to iconsPath with ic_launcher.png
        }
        else
        {
            //download from http url and save icon app to iconsPath with ic_launcher.png
        }

        var flavorizrFilePath = Path.Combine(flutterAppPath, "flavorizr.yaml");
        var iosEntitlementsFilePath = Path.Combine(flutterAppPath, "ios","Flutter", $"{_appBuildsConfig.Flavor}.entitlements");
        
        // Handle entitlements file and save to iosEntitlementsFilePath
        
        //Handle flavorizr file and replace to flavorizrFilePath
        
        // Run flutter pub get inside flutterAppPath
        
        // Run flutter dart run build_runner build -d inside flutterAppPath
        
        // Run flutter dart run flutter_flavorizr inside flutterAppPath
        
        var flovirzIconPath = Path.Combine(flutterAppPath,"ios","Runner","Assets.xcassets",$"{_appBuildsConfig.Flavor}AppIcon.appiconset");
        File.Delete(flavorizrFilePath);

        var flavorizrLaunchScreen = Path.Combine(flutterAppPath,"ios","Runner",$"{_appBuildsConfig.Flavor}LaunchScreen.storyboard");
        File.Delete(flavorizrLaunchScreen);
        
        var launcherIconsFilePath = Path.Combine(flutterAppPath,$"lutter_launcher_icons-{_appBuildsConfig.Flavor}.yaml");
        // Handle launcher icons file and save to launcherIconsFilePath
        
        
        var nativeSplashFilePath = Path.Combine(flutterAppPath,$"flutter_native_splash-{_appBuildsConfig.Flavor}.yaml");
        // handle native splash file and save to nativeSplashFilePath
        
        // Run flutter pub run flutter_launcher_icons -f $"lutter_launcher_icons-{_appBuildsConfig.Flavor}.yaml" inside flutterAppPath
        
        //Replace Path.Combine(flutterAppPath,"ios","Runner","Assets.xcassets",$"AppIcon-{_appBuildsConfig.Flavor}.appiconset") to  Path.Combine(flutterAppPath,"ios","Runner","Assets.xcassets",$"{_appBuildsConfig.Flavor}AppIcon.appiconset")
        
        
        //RUn dart run flutter_native_splash:create --flavor {_appBuildsConfig.Flavor} inside flutterAppPath
        //replace Path.Combine(flutterAppPath,"ios","Runner",$"LaunchScreen{_appBuildsConfig.Flavor}.storyboard") to Path.Combine(flutterAppPath,"ios","Runner",$"{_appBuildsConfig.Flavor}LaunchScreen.storyboard")
        
        //create jks signing key for android
        //Get key sha256 fingerprint
        //insert release sign options to build.gradle.kts 
        //upload to azure keyvault if not exists
        
        //Generate BuildEnvironmentConfig for screenshot script
        
        var screenshotScriptFilePath = Path.Combine(flutterAppPath,"scripts","screenshot.dart");
        //Run screenshot script with BuildEnvironmentConfig as environment variables
        
        var screenshotsPath = Path.Combine(projectPath, "screenshots");
        // Seacrh all .png files in screenshotsPath with subfolders
        //split file path by /{platformName]/{emulatorName]/{langName]/{screenName].png
        // order by screenName and upload to azure blob storage
        // create ScreenshotModel for each screenshot and add to ScreenShotsRedisMessageModel 
        // publish ScreenShotsRedisMessageModel to redis SCREENSHOT_CHANNEL_NAME
        
        //Set version and build number to pubspec.yaml
        //Run flutter build apk for flavor with obfuscate and split-debug-info and upload to azure blob storage
        //publish NewBuildRedisMessage to redis NEW_BUILD_CHANNEL_NAME
        
        //Run flutter build ios for flavor with obfuscate and split-debug-info and upload to azure blob storage
        //publish NewBuildRedisMessage to redis NEW_BUILD_CHANNEL_NAME
        
        // remove saved proejct file
        
    }
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
    public List<ScreenshotModel> ScreenshotModels
    {
        get;
        set;
    } = new List<ScreenshotModel>();
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
}
