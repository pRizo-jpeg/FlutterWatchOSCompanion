import SwiftUI

// WatchOS app entry point //

@main
struct WatchApp: App {
    // Use WKExtensionDelegateAdaptor to link WatchDelegate with the app's lifecycle
    @WKExtensionDelegateAdaptor(WatchDelegate.self) var watchDelegate

    var body: some Scene {
        WindowGroup {
            DemoView()
                .environmentObject(watchDelegate)
        }
    }
}
