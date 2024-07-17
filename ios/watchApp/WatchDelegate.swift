import WatchKit
import WatchConnectivity
import SwiftUI
import UserNotifications
import CoreLocation

class WatchDelegate: NSObject, WKApplicationDelegate, WKExtensionDelegate, WCSessionDelegate, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var value: Int = 0
    @Published var msg: String = ""
    @Published var user: User = User(name: nil, id: nil)
    @Published var image: UIImage? = nil
    @Published var chargingZones: [ChargingZone] = []
    @Published var selectedZone: ChargingZone? = nil
    @Published var vehicleList: [Vehicle] = MockData.vehicles
    @Published var paymentList: [PaymentMethod] = MockData.paymentMethods
    
    static let shared = WatchDelegate()
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        requestNotificationPermissions()
        loadInitialChargers()
    }
    
    private func loadInitialChargers() {
        chargingZones = MockData.chargingZones
    }
    
    private func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            print("WatchOS: Notification permission: \(granted)")
        }
    }
    
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
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WatchOS: WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WatchOS: WCSession activated with state: \(activationState.rawValue)")
        updateStateFromiOS(reason: "a session started")
    }
    
    private func updateStateFromiOS(reason: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if WCSession.default.isReachable {
                WCSession.default.sendMessage(["reason": reason], replyHandler: { response in
                    print("iOS: \(response["reason"] ?? "unknown reason")")
                }, errorHandler: { error in
                    print("WatchOS: Failed to send message to phone: \(error.localizedDescription)")
                })
            } else {
                print("WatchOS: Can't reach iOS")
            }
        }
    }
    
    func applicationDidBecomeActive() {
        print("WatchOS: on Foreground")
        updateStateFromiOS(reason: "app foregrounded")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func isSelectedZoneIcon(_ icon: String) -> Bool {
        guard let selectedZone = selectedZone else { return false }
        return selectedZone.availablePlugTypes.contains(icon)
    }
}
