import SwiftUI
import WatchConnectivity

/// The main entry point of the WatchOS app
@main
struct watchApp: App {
    /// Create an instance of ExtensionDelegate and make it available to the SwiftUI environment
    /// WKExtensionDelegateAdaptor is used to adapt the ExtensionDelegate class to the SwiftUI environment
    @WKExtensionDelegateAdaptor private var extensionDelegate: ExtensionDelegate
    
    var body: some Scene {
        WindowGroup {
            /// Set the ContentView as the main view and pass the extensionDelegate as an environment object
            ContentView()
                .environmentObject(extensionDelegate)
        }
    }
}
