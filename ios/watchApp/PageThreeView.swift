import SwiftUI
import WatchKit

struct PageThreeView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate

    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]

    let icons = [
        "ev.plug.ac.type.1.fill",
        "ev.plug.ac.type.2.fill",
        "ev.plug.dc.ccs1.fill",
        "ev.plug.dc.ccs2.fill",
        "ev.plug.dc.chademo.fill",
        "ev.plug.dc.nacs.fill"
    ]

    var body: some View {
        VStack(spacing: 0) {
            MapView()
                .frame(height: WKInterfaceDevice.current().screenBounds.height * 0.67)
                .cornerRadius(30)

            HStack(spacing: 0) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(icons, id: \.self) { icon in
                        Image(systemName: icon)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.darkGreen.opacity(0.5))
                    }
                }
                .frame(maxWidth: .infinity) // Make grid take available space
                .padding(10)

                Button(action: {
                    // Button 2 Action
                }) {
                    Text("Book")
                        .foregroundColor(Color.green.opacity(0.85))
                        .bold()
                }
            }
            .frame(height: WKInterfaceDevice.current().screenBounds.height * 0.30).padding(.bottom, 30)
        }
    }
}

struct PageThreeView_Previews: PreviewProvider {
    static var previews: some View {
        PageThreeView().environmentObject(WatchDelegate())
    }
}

extension Color {
    static let darkGreen = Color(red: 0.0, green: 0.5, blue: 0.0)
}
