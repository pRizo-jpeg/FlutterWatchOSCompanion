import Foundation
import WatchConnectivity
import Flutter

class MethodCallHandler: NSObject, WCSessionDelegate {

    static let shared = MethodCallHandler()  /// Singleton instance
    
    private override init() {}
    
    /// The channel name must match the one used in the Flutter code
    private let channelData = "FlutterToWatchOSData"
    /// The channel name must match the one used in the Flutter code
    private let channelComms = "FlutterToWatchOSComms"
    
    func initializeSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // Handles Flutter Comms Status responses //
    func handleComms(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "response":
            if let response = call.arguments as? String {
                print("Flutter: request served \(response)")
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "response not provided", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // Forwards method calls from Flutter to the Watch via SendDataToWatch class //
    func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "sendNotificationToWatchOS":
            if let args = call.arguments as? [String: Any],
               let title = args["title"] as? String,
               let body = args["body"] as? String {
                SendDataToWatch.shared.sendNotificationToWatchOS(title: title, body: body)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Title or body not provided", details: nil))
            }
        case "sendImageToWatchOS":
            if let pngData = call.arguments as? FlutterStandardTypedData {
                SendDataToWatch.shared.sendImageToWatchOS(pngData: pngData.data)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "PNG data not provided", details: nil))
            }
        case "sendCountToWatchOS":
            if let count = call.arguments as? Int {
                SendDataToWatch.shared.sendCountToWatchOS(count: count)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Count not provided", details: nil))
            }
        case "sendMessageToWatchOS":
            if let message = call.arguments as? String {
                SendDataToWatch.shared.sendMessageToWatchOS(message: message)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Message not provided", details: nil))
            }
        case "sendUserToWatchOS":
            if let userDict = call.arguments as? [String: Any],
               let name = userDict["name"] as? String,
               let id = userDict["id"] as? Int {
                let user = User(name: name, id: id)
                SendDataToWatch.shared.sendUserToWatchOS(user: user)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "User data not provided", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    

    // This method listens for messages sent from the watchOS app to the iOS app, and forwards data to Flutter level via SendDataToFlutter class //

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        
        if let msg = message["status"] as? String {
            print("WatchOS: Need updates - reason: \((message["status"] ?? "unknown status"))")
            SendDataToFlutter.shared.sendMessageToFlutter(msg: msg)
            replyHandler(["status": "Message received"])
        }
        
        if let update = message["reason"] as? String {
            print("WatchOS: Need updates - reason: \((message["reason"] ?? "unknown reason"))")
            SendDataToFlutter.shared.requestUpdates()
            replyHandler(["reason": "Updating"])
        }
    }
    
    
    // WCSessionDelegate methods //
    
    /// This method is called when the session has finished the activation process.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("iOS session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("iOS session activated with state: \(activationState.rawValue)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("iOS session did become inactive")
    }
    
    /// Immediately reactivates the session if it gets deactivated
    func sessionDidDeactivate(_ session: WCSession) {
        print("iOS session did deactivate")
        WCSession.default.activate()
    }
}
