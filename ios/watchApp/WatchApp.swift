import SwiftUI
import WatchKit

@main
struct WatchApp: App {
    @WKApplicationDelegateAdaptor(WatchDelegate.self) private var watchDelegate: WatchDelegate
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(watchDelegate)
        }
    }
}
