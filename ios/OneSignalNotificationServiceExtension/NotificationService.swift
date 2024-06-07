// //
// //  NotificationService.swift
// //  OneSignalNotificationServiceExtension
// //
// //  Created by bdCalling on 1/27/24.
// //
//
// import UserNotifications
//
// class NotificationService: UNNotificationServiceExtension {
//
//     var contentHandler: ((UNNotificationContent) -> Void)?
//     var bestAttemptContent: UNMutableNotificationContent?
//
//     override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
//         self.contentHandler = contentHandler
//         bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
//
//         if let bestAttemptContent = bestAttemptContent {
//             // Modify the notification content here...
//             bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
//
//             contentHandler(bestAttemptContent)
//         }
//     }
//
//     override func serviceExtensionTimeWillExpire() {
//         // Called just before the extension will be terminated by the system.
//         // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
//         if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
//             contentHandler(bestAttemptContent)
//         }
//     }
//
// }

import UserNotifications

import OneSignalExtension

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.receivedRequest = request
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let bestAttemptContent = bestAttemptContent {
            /* DEBUGGING: Uncomment the 2 lines below to check this extension is executing
                          Note, this extension only runs when mutable-content is set
                          Setting an attachment or action buttons automatically adds this */
            // print("Running NotificationServiceExtension")
            // bestAttemptContent.body = "[Modified] " + bestAttemptContent.body

            OneSignalExtension.didReceiveNotificationExtensionRequest(self.receivedRequest, with: bestAttemptContent, withContentHandler: self.contentHandler)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            OneSignalExtension.serviceExtensionTimeWillExpireRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
}