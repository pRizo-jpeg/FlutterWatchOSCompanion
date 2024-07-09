import SwiftUI

// The main view of the WatchOS app
struct DemoView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate
    var body: some View {
        TabView {
            PageOneView()
                .tabItem {
                    Label("Page 1", systemImage: "1.circle")
                }
            PageTwoView()
                .tabItem {
                    Label("Page 2", systemImage: "3.circle")
                }
        }
        .tabViewStyle(PageTabViewStyle())
    }
  
}


