import UserNotifications
import Firebase

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else {
            contentHandler(request.content)
            return
        }
        
        // FCM formatını kullanarak bildirim verisini kontrol et
        FIRMessagingExtensionHelper().populateNotificationContent(
            bestAttemptContent,
            withContentHandler: contentHandler)
        
        // Eğer FIRMessagingExtensionHelper tarafından işlenemezse, manuel olarak dene
        guard let userInfo = bestAttemptContent.userInfo as? [String: Any] else {
            contentHandler(bestAttemptContent)
            return
        }
        
        // imageUrl veya fcm_options.image özelliğini kontrol et
        if let imageUrlString = userInfo["image_url"] as? String ?? 
                               (userInfo["fcm_options"] as? [String: Any])?["image"] as? String {
            
            guard let imageUrl = URL(string: imageUrlString) else {
                contentHandler(bestAttemptContent)
                return
            }
            
            // Resmi indir ve bildirime ekle
            downloadAndAttachImage(imageUrl: imageUrl, bestAttemptContent: bestAttemptContent, contentHandler: contentHandler)
        } else {
            // Resim yoksa, bildirimi normal göster
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Süre dolduğunda, en son bildirim içeriğini göster
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func downloadAndAttachImage(imageUrl: URL, bestAttemptContent: UNMutableNotificationContent, contentHandler: @escaping (UNNotificationContent) -> Void) {
        // Resmi indir
        let session = URLSession(configuration: .default)
        let task = session.downloadTask(with: imageUrl) { temporaryFileLocation, response, error in
            if let error = error {
                print("Resim indirme hatası: \(error.localizedDescription)")
                contentHandler(bestAttemptContent)
                return
            }
            
            guard let temporaryFileLocation = temporaryFileLocation else {
                contentHandler(bestAttemptContent)
                return
            }
            
            // Geçici dosya oluştur
            let temporaryDirectory = NSTemporaryDirectory()
            let temporaryFileName = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            let temporaryFilePath = temporaryDirectory + temporaryFileName
            let temporaryFileUrl = URL(fileURLWithPath: temporaryFilePath)
            
            do {
                // Geçici konumdan hedef konuma kopyala
                try FileManager.default.moveItem(at: temporaryFileLocation, to: temporaryFileUrl)
                
                // Resmi bildirime ekle
                let attachment = try UNNotificationAttachment(
                    identifier: "image",
                    url: temporaryFileUrl,
                    options: [UNNotificationAttachmentOptionsTypeHintKey: "public.jpeg"]
                )
                
                bestAttemptContent.attachments = [attachment]
                contentHandler(bestAttemptContent)
            } catch {
                print("Bildirim eki oluşturma hatası: \(error.localizedDescription)")
                contentHandler(bestAttemptContent)
            }
        }
        
        task.resume()
    }
}