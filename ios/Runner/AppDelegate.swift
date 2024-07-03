import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, WCSessionDelegate {
  private let channelName = "FlutterToWatchOS"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if WCSession.isSupported() {
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
      
    // Set up MethodChannel
    if let controller = window?.rootViewController as? FlutterViewController {
      let flutterChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

      flutterChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
        guard let self = self else { return }
        self.handleMethodCall(call: call, result: result)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "sendCountToWatchOS":
      if let count = call.arguments as? Int {
        sendCountToWatchOS(count: count)
        result(nil)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Count not provided", details: nil))
      }
    case "sendMessageToWatchOS":
      if let message = call.arguments as? String {
        sendMessageToWatchOS(message: message)
        result(nil)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Message not provided", details: nil))
      }
    case "sendUserToWatchOS":
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
      result(FlutterMethodNotImplemented)
    }
  }

    private func sendCountToWatchOS(count: Int) {
       if WCSession.default.isReachable {
           WCSession.default.sendMessage(["count": count], replyHandler: nil, errorHandler: { error in
               print("Error sending count to WatchOS: \(error)")
           })
       }
       print("Sending count to WatchOS: \(count)")
     }

  private func sendMessageToWatchOS(message: String) {
    // Implement your code to send message to WatchOS here
    print("Sending message to WatchOS: \(message)")
  }

  private func sendUserToWatchOS(user: User) {
    // Implement your code to send user to WatchOS here
    print("Sending user to WatchOS: \(user.name ?? ""), \(user.id ?? 0)")
  }

  private func sendInitialValuesToWatchOS(count: Int, message: String, user: User) {
    // Implement your code to send initial values to WatchOS here
    print("Sending initial values to WatchOS: count: \(count), message: \(message), user: \(user.name ?? ""), \(user.id ?? 0)")
  }
    
    // WCSessionDelegate methods
      func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation
      }

      func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session becoming inactive
      }

      func sessionDidDeactivate(_ session: WCSession) {
        // Handle session deactivation
        WCSession.default.activate()
      }
}

class User {
  var name: String?
  var id: Int?

  init(name: String?, id: Int?) {
    self.name = name
    self.id = id
  }
}
