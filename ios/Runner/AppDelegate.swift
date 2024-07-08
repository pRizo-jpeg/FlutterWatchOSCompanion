import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    /// The channel name must match the one used in the Flutter code
    private let channelName = "FlutterToWatchOS"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Initialize Watch Connectivity session
        MethodCallHandler.shared.initializeSession()
        
        // Flutter<->Native methods communication channel setup
        
        /// UI updates and interactions with the Flutter engine must happen on the main thread
        /// Using _DispatchQueue.main.async_ ensures that the setup code runs on the main thread
        DispatchQueue.main.async {
            if let controller = self.window?.rootViewController as? FlutterViewController {
                let flutterChannel = FlutterMethodChannel(name: self.channelName, binaryMessenger: controller.binaryMessenger)
                flutterChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                    /// Invoked methods call handler
                    MethodCallHandler.shared.handleMethodCall(call: call, result: result)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Handle notifications //
    
    /// The _userNotificationCenter(:willPresent:withCompletionHandler:) method is part of the UNUserNotificationCenterDelegate protocol
    /// it allows our app to handle notifications when they are delivered while the app is in the foreground.
    /// Without this method, notifications might not be displayed if your app is currently running.
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            /// By calling the completionHandler with [.alert, .sound],
            /// we are specifying that an alert should be shown and a sound should be played when a notification is received while the app is in the foreground.
        completionHandler([.alert, .sound])
    }
}
