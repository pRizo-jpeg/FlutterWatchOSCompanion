import WatchKit
import WatchConnectivity
import SwiftUI

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, ObservableObject {
    /// properties to update at the UI
    @Published var value: Int = 0
    @Published var msg: String = ""
    @Published var user: User = User(name: nil, id: nil)
    @Published var image: UIImage? = nil

    override init() {
        super.init()
        /// Check if Watch device has a paired iPhone
        if WCSession.isSupported() {
            /// Get the default Watch <->iPhone session
            let session = WCSession.default
            /// Set the session delegate to self
            session.delegate = self
            /// Activate the session
            session.activate()
        }
    }

    // WCSessionDelegate method to handle received messages from iPhone //
    
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

    // Function to send a message to iPhone
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
    
    // WCSessionDelegate method called when the session is activated
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Watch session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("Watch session activated with state: \(activationState.rawValue)")
    }

    
}

// User class to model user data //
class User{
    var name: String?
    var id: Int?

    init(name: String?, id: Int?) {
        self.name = name
        self.id = id
    }

    // Initialize User from a dictionary
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String
        self.id = dictionary["id"] as? Int
    }
}
