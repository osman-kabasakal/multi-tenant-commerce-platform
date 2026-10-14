import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // FCM için gerekli ayarlar
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound, .providesAppNotificationSettings]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    // Bildirim için kayıt ol
    application.registerForRemoteNotifications()
    
    // Flutter Local Notifications plugin'i için gerekli ayar
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }
    
    // Plugin kayıtları
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // FCM token alındığında çağrılır
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
  
  // Bildirim alındığında çağrılır
  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // Arka planda bildirim işlemesi için gerekli
    Messaging.messaging().appDidReceiveMessage(userInfo)
    
    // Flutter Local Notifications için arka plan bildirimlerini işle
    // if let flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin.instance {
    //   // FlutterLocalNotificationsPlugin üzerinden bildirimi işle
    //   let notificationDetails = userInfo["notification"] as? [String: Any]
    //   let title = notificationDetails?["title"] as? String ?? ""
    //   let body = notificationDetails?["body"] as? String ?? ""
    //   let imageUrl = userInfo["image_url"] as? String ?? (userInfo["fcm_options"] as? [String: Any])?["image"] as? String
    //   let actionLink = userInfo["action_link"] as? String
      
    //   // Bildirim içeriğini hazırla
    //   var content = UNMutableNotificationContent()
    //   content.title = title
    //   content.body = body
    //   content.userInfo = userInfo
    //   content.sound = UNNotificationSound.default
      
    //   // Bildirim eklerini ekle (bu, NotificationServiceExtension tarafından da yapılabilir)
      
    //   // Bildirim isteği oluştur ve göster
    //   let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
    //   UNUserNotificationCenter.current().add(request) { error in
    //     if let error = error {
    //       print("Error adding notification: \(error)")
    //     }
    //   }
    // }
    
    completionHandler(.newData)
  }
  
  // Bildirim tıklandığında çağrılır
  override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    // Bildirim tıklandığında işlenecek kodu buraya ekleyebilirsiniz
    let userInfo = response.notification.request.content.userInfo
    // if let flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin.instance {
    //   flutterLocalNotificationsPlugin.handleSelectNotification(userInfo)
    // }
    completionHandler()
  }
}
