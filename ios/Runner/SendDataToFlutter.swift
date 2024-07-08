import Foundation
import Flutter

class SendDataToFlutter {
    static let shared = SendDataToFlutter()
    private init() {}
    
    // Methods to send data to Flutter via methodChannels //
    
    func sendMessageToFlutter(msg: String) {
        DispatchQueue.main.async {
            if let controller = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                let flutterChannel = FlutterMethodChannel(name: "FlutterToWatchOS", binaryMessenger: controller.binaryMessenger)
                flutterChannel.invokeMethod("receiveMessageFromWatchOS", arguments: msg)
            }
        }
    }
}