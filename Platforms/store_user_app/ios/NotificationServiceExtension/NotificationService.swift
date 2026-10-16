import Foundation
import UserNotifications
import FirebaseMessaging

class NotificationService: UNNotificationServiceExtension {
    private let completionLock = NSLock()
    private var completion: ((UNNotificationContent) -> Void)?
    private var fallbackContent: UNNotificationContent?
    private var directImage: ApnsNotificationImage?

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
        if request.content.userInfo["platform_apns"] as? String == "v1" {
            guard let value = request.content.userInfo["image"] as? String,
                  let url = URL(string: value), url.scheme?.lowercased() == "https",
                  url.host != nil, url.user == nil, url.password == nil else {
                finish(mutableContent)
                return
            }
            let image = ApnsNotificationImage { [weak self] attachment in
                if let attachment = attachment { mutableContent.attachments = [attachment] }
                self?.finish(mutableContent)
            }
            directImage = image
            image.start(url)
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
        directImage = nil
        completionLock.unlock()
        handler?(content)
    }

    override func serviceExtensionTimeWillExpire() {
        completionLock.lock()
        let content = fallbackContent
        let image = directImage
        completionLock.unlock()
        if let content = content { finish(content) }
        image?.cancel()
    }
}

private final class ApnsNotificationImage: NSObject, URLSessionDownloadDelegate {
    private let lock = NSLock()
    private var completed: ((UNNotificationAttachment?) -> Void)?
    private var session: URLSession?
    private let maximumBytes: Int64 = 10 * 1024 * 1024

    init(_ completed: @escaping (UNNotificationAttachment?) -> Void) { self.completed = completed }

    func start(_ url: URL) {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 15
        config.urlCache = nil
        config.httpShouldSetCookies = false
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        self.session = session
        session.downloadTask(with: url).resume()
    }
    func cancel() { finish(nil) }
    private func finish(_ attachment: UNNotificationAttachment?) {
        lock.lock()
        let callback = completed
        completed = nil
        let current = session
        session = nil
        lock.unlock()
        current?.invalidateAndCancel()
        callback?(attachment)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesWritten > maximumBytes || totalBytesExpectedToWrite > maximumBytes { finish(nil) }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil { finish(nil) }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let formats = ["image/jpeg": "jpg", "image/png": "png", "image/gif": "gif"]
        guard let response = downloadTask.response as? HTTPURLResponse, response.statusCode == 200,
              let type = response.mimeType?.lowercased(), let suffix = formats[type],
              let size = try? location.resourceValues(forKeys: [.fileSizeKey]).fileSize,
              size > 0, size <= maximumBytes else { finish(nil); return }
        let files = FileManager.default
        let root = files.temporaryDirectory.appendingPathComponent("platform-apns-attachments", isDirectory: true)
        let folder = root.appendingPathComponent(UUID().uuidString, isDirectory: true)
        do {
            try files.createDirectory(at: folder, withIntermediateDirectories: true)
            // Successful files must survive the extension callback: iOS validates and moves them afterwards.
            // Remove only this helper's old UUID folders on a later invocation.
            let old = try files.contentsOfDirectory(at: root, includingPropertiesForKeys: [.creationDateKey, .isSymbolicLinkKey])
            for item in old where UUID(uuidString: item.lastPathComponent) != nil {
                let values = try item.resourceValues(forKeys: [.creationDateKey, .isSymbolicLinkKey])
                if values.isSymbolicLink != true, let date = values.creationDate, date < Date().addingTimeInterval(-86400) {
                    try? files.removeItem(at: item)
                }
            }
            let image = folder.appendingPathComponent("image." + suffix)
            try files.moveItem(at: location, to: image)
            let attachment = try UNNotificationAttachment(identifier: "image", url: image)
            finish(attachment)
        } catch {
            try? files.removeItem(at: folder)
            finish(nil)
        }
    }
}
