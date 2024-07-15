import WatchKit
import WatchConnectivity
import SwiftUI
import UserNotifications
import CoreLocation

class WatchDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var value: Int = 0
    @Published var msg: String = ""
    @Published var user: User = User(name: nil, id: nil)
    @Published var image: UIImage? = nil
    @Published var chargers: [EVCharger] = [] // Added chargers array

    static let shared = WatchDelegate() // Singleton instance
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }

        requestNotificationPermissions()
        loadInitialChargers() // Load initial chargers data
    }

    // Load initial chargers data
    private func loadInitialChargers() {
        chargers = [
            EVCharger(coordinate: CLLocationCoordinate2D(latitude: 39.6333, longitude: -0.5964), chargerName: "Mercadona EV Station"),
            EVCharger(coordinate: CLLocationCoordinate2D(latitude: 39.6350, longitude: -0.5950), chargerName: "Calle Pascual Free Charger"),
            EVCharger(coordinate: CLLocationCoordinate2D(latitude: 39.6310, longitude: -0.5980), chargerName: "Circular Demo Llíria"),
            EVCharger(coordinate: CLLocationCoordinate2D(latitude: 39.6340, longitude: -0.5990), chargerName: "Avenida de la Estación Charger"),
            EVCharger(coordinate: CLLocationCoordinate2D(latitude: 39.6320, longitude: -0.5940), chargerName: "Plaza Mayor Charging Point"),
            EVCharger(coordinate: CLLocationCoordinate2D(latitude: 39.6433, longitude: -0.5964), chargerName: "Calle San Vicente Charger")
        ]
    }

    // Request notification permissions
    private func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            print("WatchOS: Notification permission: \(granted)")
        }
    }

    // Handle received messages from iPhone
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
            response["status"] = "Notification received"
        }
        if let userDict = message["user"] as? [String: Any],
           let name = userDict["name"] as? String,
           let id = userDict["id"] as? Int {
            DispatchQueue.main.async {
                self.user = User(name: name, id: id)
            }
            response["status"] = "User received"
        }

        replyHandler(response)
    }
    
    // Function to display a notification on watchOS
    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("WatchOS: Failed to add notification request: \(error.localizedDescription)")
            } else {
                print("WatchOS: Sending notification")
            }
        }
    }

    // Function to send a message to iPhone
    func sendMessageToiOS(message: String) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["status": message], replyHandler: { response in
                print("iOS: \(response["status"] ?? "unknown status")")
            }, errorHandler: { error in
                print("iOS: \(error.localizedDescription)")
            })
        } else {
            print("WatchOS: Can't reach iOS")
        }
    }

    // Method called when the session is activated
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WatchOS: WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WatchOS: WCSession activated with state: \(activationState.rawValue)")
        updateStateFromiOS(reason: "a session started")
    }
    
    // Method to update state from iOS
    private func updateStateFromiOS(reason: String) {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {   /// Using _DispatchQueue.main.async_ for running on the main thread
             if WCSession.default.isReachable {
                 WCSession.default.sendMessage(["reason": reason], replyHandler: { response in
                     print("iOS: \(response["reason"] ?? "unknown reason")")
                 }, errorHandler: { error in
                     print("Watchos: Failed to send message to phone: \(error.localizedDescription)")
                 })
             } else {
                 print("WatchOS: Can't reach iOS")
             }
         }
     }

    // Method called when the app becomes active
     func applicationDidBecomeActive() {
         print("WatchOS: on Foreground")
         updateStateFromiOS(reason: "app foregrounded")
     }
    
    // UNUserNotificationCenterDelegate required methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

struct EVCharger: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let chargerName: String
}

