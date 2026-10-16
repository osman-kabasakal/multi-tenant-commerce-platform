import Flutter
import UIKit
import UserNotifications
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var apnsChannel: FlutterMethodChannel?
  private var currentApnsToken: String?
  private var pendingApnsOpen: [String: Any]?
  private var routesReady = false
  private var directApns: Bool {
    Bundle.main.object(forInfoDictionaryKey: "PlatformIosPushTransport") as? String == "Apns"
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    GeneratedPluginRegistrant.register(with: self)
    let launched = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    if directApns {
      configureApnsChannel()
      UNUserNotificationCenter.current().delegate = self
    }
    return launched
  }

  private func configureApnsChannel() {
    guard let registrar = registrar(forPlugin: "PlatformApnsBridge") else { return }
    let channel = FlutterMethodChannel(name: "multi_tenant_commerce/apns_v1", binaryMessenger: registrar.messenger())
    apnsChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { result(nil); return }
      switch call.method {
      case "initialize":
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
          center.getNotificationSettings { settings in
            let allowed = self.authorized(settings)
            DispatchQueue.main.async {
              if allowed { UIApplication.shared.registerForRemoteNotifications() }
              result([
                "authorized": allowed, "transport": "Apns", "environment": "Production",
                "bundleId": Bundle.main.bundleIdentifier ?? "",
                "developmentTeam": Bundle.main.object(forInfoDictionaryKey: "PlatformIosDevelopmentTeam") as? String ?? "",
                "token": allowed ? (self.currentApnsToken as Any? ?? NSNull()) : NSNull()
              ])
            }
          }
        }
      case "permission":
        UNUserNotificationCenter.current().getNotificationSettings { settings in
          DispatchQueue.main.async { result(self.authorized(settings)) }
        }
      case "getToken": result(currentApnsToken)
      case "initialMessage":
        routesReady = true
        let initial = pendingApnsOpen
        pendingApnsOpen = nil
        result(initial)
      default: result(FlutterMethodNotImplemented)
      }
    }
  }

  private func authorized(_ settings: UNNotificationSettings) -> Bool {
    if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional { return true }
    if #available(iOS 14.0, *) { return settings.authorizationStatus == .ephemeral }
    return false
  }

  override func application(_ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    if directApns {
      let token = deviceToken.map { String(format: "%02x", $0) }.joined()
      currentApnsToken = token
      apnsChannel?.invokeMethod("token", arguments: token)
    }
  }

  override func application(_ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error) {
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    if directApns { apnsChannel?.invokeMethod("registrationError", arguments: nil) }
  }

  override func application(_ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if directApns && userInfo["platform_apns"] as? String == "v1" {
      apnsChannel?.invokeMethod("message", arguments: ["data": userInfo["data"] as? [String: Any] ?? [:]])
      completionHandler(.noData)
    } else {
      super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
  }

  private func payload(_ notification: UNNotification) -> [String: Any] {
    let info = notification.request.content.userInfo
    return ["data": info["data"] as? [String: Any] ?? [:], "messageId": notification.request.identifier,
            "notification": ["title": notification.request.content.title, "body": notification.request.content.body]]
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    if directApns && notification.request.content.userInfo["platform_apns"] as? String == "v1" {
      apnsChannel?.invokeMethod("message", arguments: payload(notification))
      if #available(iOS 14.0, *) { completionHandler([.banner, .list, .badge, .sound]) }
      else { completionHandler([.alert, .badge, .sound]) }
    } else {
      super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
    }
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void) {
    if directApns && response.notification.request.content.userInfo["platform_apns"] as? String == "v1" {
      let message = payload(response.notification)
      if routesReady { apnsChannel?.invokeMethod("opened", arguments: message) }
      else { pendingApnsOpen = message }
      completionHandler()
    } else {
      super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }
  }
}
