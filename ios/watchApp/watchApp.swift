import SwiftUI
import WatchConnectivity

/// The main entry point of the WatchOS app
@main
struct watchApp: App {
    /// Create an instance of ExtensionDelegate and make it available to the SwiftUI environment
    /// WKExtensionDelegateAdaptor is used to adapt the watchDelegate class to the SwiftUI environment
    @WKExtensionDelegateAdaptor private var watchDelegate: WatchDelegate
    
    var body: some Scene {
        WindowGroup {
            /// Set the ContentView as the main view and pass the watchDelegate as an environment object
            DemoView()
                .environmentObject(watchDelegate)
        }
    }
}
