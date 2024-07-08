import SwiftUI


// WatchOS app entry point //

@main
struct watchApp: App {
    var body: some Scene {
        WindowGroup {
            DemoView()
                /// Injecting the watch delegate
                .environmentObject(WatchDelegate.shared)
        }
    }
}
