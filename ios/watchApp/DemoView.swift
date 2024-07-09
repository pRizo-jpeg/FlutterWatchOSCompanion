import SwiftUI

// The main view of the WatchOS app //
struct DemoView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate
    var body: some View {
        TabView {
            PageOneView()
            PageTwoView()
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}


