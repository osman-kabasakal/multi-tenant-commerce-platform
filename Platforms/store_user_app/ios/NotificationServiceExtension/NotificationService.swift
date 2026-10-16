import Foundation
import UserNotifications
import FirebaseMessaging

class NotificationService: UNNotificationServiceExtension {
    private let completionLock = NSLock()
    private var completion: ((UNNotificationContent) -> Void)?
    private var fallbackContent: UNNotificationContent?

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        completionLock.lock()
        completion = contentHandler
        fallbackContent = request.content
        completionLock.unlock()
        guard let mutableContent = request.content.mutableCopy() as? UNMutableNotificationContent else {
            finish(request.content)
            return
        }
        Messaging.serviceExtension().populateNotificationContent(mutableContent) { [weak self] content in
            self?.finish(content)
        }
    }

    private func finish(_ content: UNNotificationContent) {
        completionLock.lock()
        let handler = completion
        completion = nil
        fallbackContent = nil
        completionLock.unlock()
        handler?(content)
    }

    override func serviceExtensionTimeWillExpire() {
        completionLock.lock()
        let content = fallbackContent
        completionLock.unlock()
        if let content = content {
            finish(content)
        }
    }
}
