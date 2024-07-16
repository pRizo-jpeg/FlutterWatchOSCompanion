import SwiftUI

// The main view of the WatchOS app //
struct MainView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate
    var body: some View {
        TabView {
            PageThreeView()
            PageTwoView()
            PageOneView()
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}


