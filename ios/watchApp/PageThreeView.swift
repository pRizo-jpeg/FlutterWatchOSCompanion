import SwiftUI
import WatchKit

struct PageThreeView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate
    @State private var stack = [String]()
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]
    
    let plugIcons: [String: ChargingZone.PlugType] = [
        "ev.plug.ac.type.1": .type1,
        "ev.plug.ac.type.2": .type2,
        "ev.plug.dc.ccs1": .ccs1,
        "ev.plug.dc.ccs2": .ccs2,
        "ev.plug.dc.chademo": .chademo,
        "ev.plug.dc.gb.t": .gbtDC,
        "ev.plug.ac.gb.t": .gbtAC,
        "ev.plug.dc.nacs": .nacs
    ]
    
    var isZoneSelected: Bool {
        watchDelegate.selectedZone != nil
    }
    
    var body: some View {
        NavigationStack(path: $stack) {
            VStack(spacing: 0) {
                MapView()
                    .frame(width: WKInterfaceDevice.current().screenBounds.width, height: WKInterfaceDevice.current().screenBounds.height * 0.67)
                    .cornerRadius(30)
                
                HStack(spacing: 0) {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(plugIcons.keys.sorted(), id: \.self) { icon in
                            Image(systemName: icon)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(isZoneSelected && watchDelegate.isSelectedZoneIcon(plugIcons[icon]!.rawValue) ? .green.opacity(0.85) : .darkGreen.opacity(0.5))
                               
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    Button(action: {
                        if let zone = watchDelegate.selectedZone {
                            stack.append(zone.id.uuidString)
                        }
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
            .navigationDestination(for: String.self) { value in
                if watchDelegate.chargingZones.first(where: { $0.id.uuidString == value }) != nil {
                    BookingView().environmentObject(watchDelegate)
                }
            }
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
