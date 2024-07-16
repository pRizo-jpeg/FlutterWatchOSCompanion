import SwiftUI
import WatchKit

struct PageThreeView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate

    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]

    let plugIcons = [
        "ev.plug.ac.type.1",
        "ev.plug.ac.type.2",
        "ev.plug.dc.ccs1",
        "ev.plug.dc.ccs2",
        "ev.plug.dc.chademo",
        "ev.plug.dc.gb.t",
        "ev.plug.ac.gb.t",
        "ev.plug.dc.nacs"
    ]

    var isZoneSelected: Bool {
        plugIcons.contains { watchDelegate.isSelectedZoneIcon($0) }
    }

    var body: some View {
        VStack(spacing: 0) {
            MapView()
                .frame(height: WKInterfaceDevice.current().screenBounds.height * 0.67)
                .cornerRadius(30)

            HStack(spacing: 0) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(plugIcons, id: \.self) { icon in
                        Image(systemName: icon)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(watchDelegate.isSelectedZoneIcon(icon) ? .green.opacity(0.85) : .darkGreen.opacity(0.5))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                Button(action: {
                    // action
                }) {
                    Image(systemName: "ev.charger.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(isZoneSelected ? .green.opacity(0.85) : .darkGreen.opacity(0.5))
                }
                .frame(width: 55)
                .disabled(!isZoneSelected) 
            }
            .frame(height: WKInterfaceDevice.current().screenBounds.height * 0.30)
            .padding(.bottom, 30)
        }
    }
}

struct PageThreeView_Previews: PreviewProvider {
    static var previews: some View {
        PageThreeView().environmentObject(WatchDelegate.shared)
    }
}

extension Color {
    static let darkGreen = Color(red: 0.0, green: 0.5, blue: 0.0)
}
