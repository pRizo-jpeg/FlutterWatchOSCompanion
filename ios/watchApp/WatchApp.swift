import SwiftUI

// WatchOS app entry point //

@main
struct WatchApp: App {
    @StateObject private var watchDelegate = WatchDelegate()
    var body: some Scene {
        WindowGroup {
            DemoView()
                .environmentObject(watchDelegate)
        }
    }
}
