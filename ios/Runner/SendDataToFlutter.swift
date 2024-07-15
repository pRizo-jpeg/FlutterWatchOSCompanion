import Foundation
import Flutter

class SendDataToFlutter {
    static let shared = SendDataToFlutter()
    private init() {}
    
    private var lastUpdate: Date?

    // Methods to send data to Flutter via methodChannel
    
    func sendMessageToFlutter(msg: String) {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let controller = windowScene.windows.first?.rootViewController as? FlutterViewController {
                let flutterChannel = FlutterMethodChannel(name: "FlutterToWatchOSData", binaryMessenger: controller.binaryMessenger)
                flutterChannel.invokeMethod("receiveMessageFromWatchOS", arguments: msg)
            }
        }
    }
    
    func requestUpdate() {
        print("iOS: Requesting updates to Flutter")
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let controller = windowScene.windows.first?.rootViewController as? FlutterViewController {
                let flutterChannel = FlutterMethodChannel(name: "FlutterToWatchOSData", binaryMessenger: controller.binaryMessenger)
                flutterChannel.invokeMethod("updateWatchOS", arguments: nil)
            }
        }
    }
    
    @objc func requestUpdates() {
        if let lastUpdate = lastUpdate {
            let timeIntervalSinceLastUpdate = Date().timeIntervalSince(lastUpdate)
            if timeIntervalSinceLastUpdate < 10 {
                print("iOS: Skip updating, last update was \(Int(timeIntervalSinceLastUpdate)) seconds ago")
                return
            }
        }
        
        // Update the last update time
        self.lastUpdate = Date() 
        SendDataToFlutter.shared.requestUpdate()
    }
}
