import Foundation
import WatchConnectivity

class SendDataToWatch {
    static let shared = SendDataToWatch()
    private init() {}
    
    // Methods to send data to WatchOS via default WCSession //
    
    func sendNotificationToWatchOS(title: String, body: String) {
        print("iOS: Sending notification: '\(title) - \(body)'")
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["title": title, "body": body], replyHandler: { response in
                print("WatchOS: \(response["status"] ?? "unknown status")")
            }, errorHandler: { error in
                print("iOS: Failed to send message to WatchOS: \(error.localizedDescription)")
            })
        } else {
            print("iOS: WatchOS device is not reachable.")
        }
    }
    
    func sendImageToWatchOS(pngData: Data) {
        print("iOS: Sending image")
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["img": pngData], replyHandler: { response in
                print("WatchOS: \(response["status"] ?? "unknown status")")
            }, errorHandler: { error in
                print("iOS: Failed to send image to WatchOS: \(error.localizedDescription)")
            })
        } else {
            print("iOS: WatchOS device is not reachable.")
        }
    }

    func sendCountToWatchOS(count: Int) {
        print("iOS: Sending count")
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["count": count], replyHandler: { response in
                print("WatchOS: \(response["status"] ?? "unknown status")")
            }, errorHandler: { error in
                print("Error sending count to WatchOS: \(error.localizedDescription)")
            })
        } else {
            print("iOS: WatchOS device is not reachable.")
        }
    }

    func sendMessageToWatchOS(message: String) {
        print("iOS: Sending message")
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["msg": message], replyHandler: { response in
                print("WatchOS: \(response["status"] ?? "unknown status")")
            }, errorHandler: { error in
                print("Error sending msg to WatchOS: \(error.localizedDescription)")
            })
        } else {
            print("iOS: WatchOS device is not reachable.")
        }
    }

    func sendUserToWatchOS(user: User) {
        print("iOS: Sending User")
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["user": user.toDictionary()], replyHandler: { response in
                print("WatchOS: \(response["status"] ?? "unknown status")")
            }, errorHandler: { error in
                print("Error sending user to WatchOS: \(error.localizedDescription)")
            })
        } else {
            print("iOS: WatchOS device is not reachable.")
        }
    }
}
