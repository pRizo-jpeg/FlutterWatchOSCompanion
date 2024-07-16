import WatchKit
import WatchConnectivity
import SwiftUI
import UserNotifications
import CoreLocation

struct Vehicle: Identifiable {
    let id: UUID
    let name: String
}

struct PaymentMethod: Identifiable {
    let id: UUID
    let name: String
}

struct EVCharger: Identifiable {
    let id: UUID
    let plugType: String
    let price: Double?
    let preauthorizationFee: Double?
}

struct ChargingZone: Identifiable {
    let id: UUID
    let name: String
    let coordinate: CLLocationCoordinate2D
    var chargers: [EVCharger]
    
    var availablePlugTypes: [String] {
        chargers.map { $0.plugType }
    }
    
    enum PlugType: String, CaseIterable {
        case type1 = "Type 1"
        case type2 = "Type 2"
        case chademo = "CHAdeMO"
        case ccs1 = "CCS Type 1"
        case ccs2 = "CCS Type 2"
        case gbtDC = "GB/T DC"
        case gbtAC = "GB/T AC"
        case nacs = "NACS"
    }
}

class WatchDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var value: Int = 0
    @Published var msg: String = ""
    @Published var user: User = User(name: nil, id: nil)
    @Published var image: UIImage? = nil
    @Published var chargingZones: [ChargingZone] = []
    @Published var selectedZone: ChargingZone? = nil
    @Published var vehicleList: [Vehicle] = [
        Vehicle(id: UUID(), name: "Tesla Model S"),
        Vehicle(id: UUID(), name: "Nissan Leaf"),
        Vehicle(id: UUID(), name: "BMW i3")
    ]

    @Published var paymentList: [PaymentMethod] = [
        PaymentMethod(id: UUID(), name: "Credit Card"),
        PaymentMethod(id: UUID(), name: "PayPal"),
        PaymentMethod(id: UUID(), name: "Apple Pay")
    ]
    
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
        chargingZones = [
            ChargingZone(id: UUID(), name: "Mercadona EV Station", coordinate: CLLocationCoordinate2D(latitude: 39.6333, longitude: -0.5964), chargers: [
                EVCharger(id: UUID(), plugType: "CCS Type 1", price: 15.5, preauthorizationFee: 5),
                EVCharger(id: UUID(), plugType: "CCS Type 2", price: 25.5, preauthorizationFee: nil),
                EVCharger(id: UUID(), plugType: "GB/T DC", price: 12, preauthorizationFee: 10),
                EVCharger(id: UUID(), plugType: "Type 2", price: nil, preauthorizationFee: nil)
            ]),
            ChargingZone(id: UUID(), name: "Calle Pascual Free Charger", coordinate: CLLocationCoordinate2D(latitude: 39.6350, longitude: -0.5950), chargers: [
                EVCharger(id: UUID(), plugType: "CHAdeMO", price: nil, preauthorizationFee: nil),
                EVCharger(id: UUID(), plugType: "Type 2", price: 15.5, preauthorizationFee: 10)
            ]),
            ChargingZone(id: UUID(), name: "Circular Demo Llíria", coordinate: CLLocationCoordinate2D(latitude: 39.6310, longitude: -0.5980), chargers: [
                EVCharger(id: UUID(), plugType: "Type 1", price: 1.5, preauthorizationFee: 15),
                EVCharger(id: UUID(), plugType: "Type 2", price: 7.5, preauthorizationFee: nil),
                EVCharger(id: UUID(), plugType: "CHAdeMO", price: 5.5, preauthorizationFee: nil),
                EVCharger(id: UUID(), plugType: "GB/T DC", price: 11.1, preauthorizationFee: 1)
            ])
        ]
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
