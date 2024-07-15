import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let channelData = "FlutterToWatchOSData"            /// The channel names must match the one used in the Flutter code
    private let channelComms = "FlutterToWatchOSComms"

    private var updateSeconds = 60.0                            /// Timer for scheduling auto updates
    private var updateTimer: Timer?
    
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Initialize Watch Connectivity session //
        
        MethodCallHandler.shared.initializeSession()
        
        // Flutter<->Native methods communication channel setup
        
        DispatchQueue.main.async {                              /// Using _DispatchQueue.main.async_ ensures that interactions with the Flutter engine happen on the main thread
            if let controller = 
                self.window?.rootViewController as? FlutterViewController {
                // Main Data channel
                let flutterDataChannel = FlutterMethodChannel(name: self.channelData, binaryMessenger: controller.binaryMessenger)
                flutterDataChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                    MethodCallHandler.shared.handleMethodCall(  /// Invoked data methods call handler
                        call: call,
                        result: result
                    )
                }
                // Aux CommState channel
                let flutterCommsChannel = FlutterMethodChannel(name: self.channelComms, binaryMessenger: controller.binaryMessenger)
                flutterCommsChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                    MethodCallHandler.shared.handleComms(       /// Invoked comms methods call handler
                        call: call,
                        result: result
                    )
                }
            }
        }
        
            
        scheduleUpdates()                                       /// Initialize auto requesting updates
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    // Updating watch data //
    
    private func scheduleUpdates() {
        updateTimer?.invalidate()
                        
        updateTimer = Timer.scheduledTimer(
            timeInterval: updateSeconds,
            target: self,
            selector: #selector(requestUpdates),                /// Method called when the timer fires
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func requestUpdates() {
        if WCSession.default.isReachable {
            SendDataToFlutter.shared.requestUpdates()
        }
    }
    
    
    // Handling notifications //
    
    /// This handles notifications when they are delivered while the app is in the foreground
    /// without this method, notifications might not be displayed if the app is currently running
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            ///  specifying that banner should be shown and a sound should be played when a notification is received while the app is in the foreground
            completionHandler([.banner, .sound])
        }
}
