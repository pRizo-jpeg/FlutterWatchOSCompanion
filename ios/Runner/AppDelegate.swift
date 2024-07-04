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
    case "sendImageToWatchOS":
      if let pngData = call.arguments as? FlutterStandardTypedData {
        sendImageToWatchOS(pngData: pngData.data)
        result(nil)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "PNG data not provided", details: nil))
    }
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

    private func sendImageToWatchOS(pngData: Data) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["img": pngData], replyHandler: nil, errorHandler: { error in
                print("Failed to send image to WatchOS: \(error)")
            })
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
      if WCSession.default.isReachable {
          WCSession.default.sendMessage(["msg": message], replyHandler: nil, errorHandler: { error in
              print("Error sending msg to WatchOS: \(error)")
          })
      }
    print("Sending message to WatchOS: \(message)")
  }

  private func sendUserToWatchOS(user: User) {
      if WCSession.default.isReachable {
          WCSession.default.sendMessage(["user": user], replyHandler: nil, errorHandler: { error in
              print("Error sending user to WatchOS: \(error)")
          })
      }
    print("Sending user to WatchOS: \(user.name ?? ""), \(user.id ?? 0)")
  }

  private func sendInitialValuesToWatchOS(count: Int, message: String, user: User) {
    sendCountToWatchOS(count: count)
    sendMessageToWatchOS(message: message)
    sendUserToWatchOS(user: user)
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
