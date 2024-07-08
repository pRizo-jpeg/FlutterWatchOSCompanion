import WatchKit
import WatchConnectivity
import SwiftUI
import UserNotifications

class WatchDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, ObservableObject, UNUserNotificationCenterDelegate {
    /// properties to update at the UI
    @Published var value: Int = 0
    @Published var msg: String = ""
    @Published var user: User = User(name: nil, id: nil)
    @Published var image: UIImage? = nil

    /// Singleton instance
    static let shared = WatchDelegate()
    
    override init() {
        super.init()
        /// Check if Watch device has a paired iPhone and activate the session
        if WCSession.isSupported() {
            /// Get the default Watch <->iPhone session
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }

        // Request notification permissions //
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            print("Notification permission: \(granted)")
        }
    }

    
    // Handle received messages from iPhone //
    /// UI updates and interactions with the Flutter engine must happen on the main thread
    /// Using _DispatchQueue.main.async_ ensures that the code runs on the main thread
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var response: [String: Any] = [:]
        if let imgData = message["img"] as? Data {
            DispatchQueue.main.async {
                self.image = UIImage(data: imgData)
            }
            response["status"] = "Image received"
        }
        if let count = message["count"] as? Int {
            DispatchQueue.main.async {
                self.value = count
            }
            response["status"] = "Count received"
        }
        if let msg = message["msg"] as? String {
            DispatchQueue.main.async {
                self.msg = msg
            }
            response["status"] = "Message received"
        }
        if let title = message["title"] as? String, let body = message["body"] as? String {
            sendNotification(title: title, body: body)
            response["status"] = "Notification sent"
        }
        if let userDict = message["user"] as? [String: Any],
           let name = userDict["name"] as? String,
           let id = userDict["id"] as? Int {
            DispatchQueue.main.async {
                self.user = User(name: name, id: id)
            }
            response["status"] = "User received"
        }

        /// Call the reply handler
        replyHandler(response)
    }
    
    /// Function to display a notification on watchOS
    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to add notification request: \(error.localizedDescription)")
            }
        }
    }

    /// Function to send a message to iPhone
    func sendMessageToiOS(message: String) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["msg": message], replyHandler: { response in
                print("Received response from iOS: \(response)")
            }, errorHandler: { error in
                print("Failed to send message to iOS: \(error.localizedDescription)")
            })
        } else {
            print("iOS device is not reachable.")
        }
    }

    // Method called when the session is activated
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Watch session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("Watch session activated with state: \(activationState.rawValue)")
    }

    // UNUserNotificationCenterDelegate required method
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // UNUserNotificationCenterDelegate required method
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}


