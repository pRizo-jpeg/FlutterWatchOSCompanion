import Foundation
import Flutter

class SendDataToFlutter {
    static let shared = SendDataToFlutter()
    private init() {}
    
    // Methods to send data to Flutter via methodChannel //
    
    func sendMessageToFlutter(msg: String) {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let controller = windowScene.windows.first?.rootViewController as? FlutterViewController {
                let flutterChannel = FlutterMethodChannel(name: "FlutterToWatchOSData", binaryMessenger: controller.binaryMessenger)
                flutterChannel.invokeMethod("receiveMessageFromWatchOS", arguments: msg)
            }
        }
    }
    
    func requestUpdate(completion: @escaping (String?) -> Void) {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let controller = windowScene.windows.first?.rootViewController as? FlutterViewController {
                let flutterChannel = FlutterMethodChannel(name: "FlutterToWatchOSComms", binaryMessenger: controller.binaryMessenger)
                flutterChannel.invokeMethod("updateWatchOS", arguments: nil) { (result: Any?) in
                    completion(result as? String)
                    print(result as? String ?? "no result")
                }
            } else {
                completion(nil)
                print("failed to request update")
            }
        }
    }
    
    @objc func requestUpdates() {
        print("requesting update...")
            SendDataToFlutter.shared.requestUpdate { response in
                if let response = response {
                    print("Received update: \(response)")
                } else {
                    print("Request update failed")
                }
        }
    }
}
