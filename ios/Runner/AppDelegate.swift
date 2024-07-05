import UIKit
import Flutter
import WatchConnectivity
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, WCSessionDelegate {
    private let channelName = "FlutterToWatchOS" /// Declare communication channel same as Flutter layer
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Check if iPhone device has a paired Watch //
        
        if WCSession.isSupported() {
            /// Get the default Watch <->iPhone session
            let session = WCSession.default
            /// Set the session delegate to self
            session.delegate = self
            /// Activate the session
            session.activate()
        }

        // Flutter<->Native methods communication channel setup //
        
        DispatchQueue.main.async {
            if let controller = self.window?.rootViewController as? FlutterViewController {
                /// Create a FlutterMethodChannel to receive the outcoming calls from the Flutter App
                let flutterChannel = FlutterMethodChannel(name: self.channelName, binaryMessenger: controller.binaryMessenger)
                /// Set a handler to process those calls
                flutterChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
                    guard let self = self else { return }
                    /// Handle the calls
                    self.handleMethodCall(call: call, result: result)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    

    // Handle receiving calls from Flutter to Native methods //

    private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "sendNotificationToWatchOS":
                   if let args = call.arguments as? [String: Any],
                      let title = args["title"] as? String,
                      let body = args["body"] as? String {
                       sendNotificationToWatchOS(title: title, body: body)
                       result(nil)
                   } else {
                       result(FlutterError(code: "INVALID_ARGUMENT", message: "Title or body not provided", details: nil))
                   }
        case "sendImageToWatchOS":
            /// Handle sending an image to WatchOS
            if let pngData = call.arguments as? FlutterStandardTypedData {
                sendImageToWatchOS(pngData: pngData.data)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "PNG data not provided", details: nil))
            }
        case "sendCountToWatchOS":
            /// Handle sending a count to WatchOS
            if let count = call.arguments as? Int {
                sendCountToWatchOS(count: count)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Count not provided", details: nil))
            }
        case "sendMessageToWatchOS":
            /// Handle sending a message to WatchOS
            if let message = call.arguments as? String {
                sendMessageToWatchOS(message: message)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Message not provided", details: nil))
            }
        case "sendUserToWatchOS":
            /// Handle sending user data to WatchOS
            if let userDict = call.arguments as? [String: Any],
               let name = userDict["name"] as? String,
               let id = userDict["id"] as? Int {
                let user = User(name: name, id: id)
                sendUserToWatchOS(user: user)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "User data not provided", details: nil))
            }
        case "sendInitialValuesToWatchOS":
            /// Handle sending a set of initial values to WatchOS
            if let initialValues = call.arguments as? [String: Any],
               let count = initialValues["count"] as? Int,
               let message = initialValues["message"] as? String,
               let userDict = initialValues["user"] as? [String: Any],
               let name = userDict["name"] as? String,
               let id = userDict["id"] as? Int {
                let user = User(name: name, id: id)
                sendInitialValuesToWatchOS(count: count, message: message, user: user)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Initial values not provided correctly", details: nil))
            }
        default:
            /// When the method called is not implemented
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    
    
    // Communication from iPhone to watchOS methods //
    
    /// Function to send notification to WatchOS
    private func sendNotificationToWatchOS(title: String, body: String) {
        print("Received a notification: ' \(title) - \(body) '")
            if WCSession.default.isReachable {
                WCSession.default.sendMessage(["title": title, "body": body], replyHandler: { response in
                    print("Received response from WatchOS: \(response)")
                }, errorHandler: { error in
                    print("Failed to send message to WatchOS: \(error.localizedDescription)")
                })
            } else {
                print("WatchOS device is not reachable.")
            }
        }
    
    /// Function to send an image to WatchOS
    private func sendImageToWatchOS(pngData: Data) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["img": pngData], replyHandler: { response in
                print("Received response from WatchOS: \(response)")
            }, errorHandler: { error in
                print("Failed to send image to WatchOS: \(error.localizedDescription)")
            })
        } else {
            print("WatchOS device is not reachable.")
        }
    }

    /// Function to send a count to WatchOS
    private func sendCountToWatchOS(count: Int) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["count": count], replyHandler: { response in
                print("Received response from WatchOS: \(response)")
            }, errorHandler: { error in
                print("Error sending count to WatchOS: \(error.localizedDescription)")
            })
        } else {
            print("WatchOS device is not reachable.")
        }
    }

    /// Function to send a message to WatchOS
    private func sendMessageToWatchOS(message: String) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["msg": message], replyHandler: { response in
                print("Received response from WatchOS: \(response)")
            }, errorHandler: { error in
                print("Error sending msg to WatchOS: \(error.localizedDescription)")
            })
        } else {
            print("WatchOS device is not reachable.")
        }
    }

    /// Function to send user data to WatchOS
    private func sendUserToWatchOS(user: User) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["user": user.toDictionary()], replyHandler: { response in
                print("Received response from WatchOS: \(response)")
            }, errorHandler: { error in
                print("Error sending user to WatchOS: \(error.localizedDescription)")
            })
        } else {
            print("WatchOS device is not reachable.")
        }
    }
    
    /// Function to send initial values to WatchOS
    private func sendInitialValuesToWatchOS(count: Int, message: String, user: User) {
        sendCountToWatchOS(count: count)
        sendMessageToWatchOS(message: message)
        sendUserToWatchOS(user: user)
        print("Sending initial values to WatchOS: count: \(count), message: \(message), user: \(user.name ?? ""), \(user.id ?? 0)")
    }
    
    
    
    
    
    // Sending calls to From Native to Flutter methods//
    
    /// Send a String message to Flutter
    private func sendMessageToFlutter(msg: String) {
        DispatchQueue.main.async {
            if let controller = self.window?.rootViewController as? FlutterViewController {
                let flutterChannel = FlutterMethodChannel(name: self.channelName, binaryMessenger: controller.binaryMessenger)
                flutterChannel.invokeMethod("receiveMessageFromWatchOS", arguments: msg)
            }
        }
    }



    // Session delegate methods //
    
    /// WCSessionDelegate method called when the session is activated
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("iOS session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("iOS session activated with state: \(activationState.rawValue)")
    }

    /// WCSessionDelegate method called when the session becomes inactive
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("iOS session did become inactive")
    }

    /// WCSessionDelegate method called when the session is deactivated
    func sessionDidDeactivate(_ session: WCSession) {
        print("iOS session did deactivate")
        WCSession.default.activate()
    }

    /// WCSessionDelegate method to handle received messages
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Received message from WatchOS: \(message)")
        if let msg = message["msg"] as? String {
            sendMessageToFlutter(msg: msg)
            replyHandler(["status": "Message received"])
        } else {
            replyHandler(["status": "Invalid data"])
        }
    }
    
    // Handle notifications
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          completionHandler([.alert, .sound])
      }
}



// User  model //
class User {
    var name: String?
    var id: Int?

    init(name: String?, id: Int?) {
        self.name = name
        self.id = id
    }

    /// Function to convert User object to a dictionary
    func toDictionary() -> [String: Any] {
        return ["name": name ?? "", "id": id ?? 0]
    }
}
