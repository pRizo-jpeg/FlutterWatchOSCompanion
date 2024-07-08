import Foundation
import WatchConnectivity

class SendDataToWatch {
    static let shared = SendDataToWatch()
    private init() {}
    
    func sendNotificationToWatchOS(title: String, body: String) {
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
    
    func sendImageToWatchOS(pngData: Data) {
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

    func sendCountToWatchOS(count: Int) {
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

    func sendMessageToWatchOS(message: String) {
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

    func sendUserToWatchOS(user: User) {
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

    func sendInitialValuesToWatchOS(count: Int, message: String, user: User) {
        sendCountToWatchOS(count: count)
        sendMessageToWatchOS(message: message)
        sendUserToWatchOS(user: user)
        print("Sending initial values to WatchOS: count: \(count), message: \(message), user: \(user.name ?? ""), \(user.id ?? 0)")
    }
}
