import SwiftUI
import CoreLocation

struct BookingView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate
    @State private var selectedVehicle: String = ""
    @State private var selectedPaymentMethod: String = ""

    var body: some View {
        ScrollView {
            VStack {
                if let selectedZone = watchDelegate.selectedZone {
                    ForEach(selectedZone.chargers) { charger in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 3).padding(.leading, 5).padding(.vertical, 7.5)
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Type: \(charger.plugType)")
                                            .font(.caption)
                                            .padding(.bottom, 1)
                                        if let price = charger.price {
                                            Text("Price: \(String(format: "%.2f", price)) €/kWh")
                                                .font(.caption2)
                                        }
                                        if let fee = charger.preauthorizationFee {
                                            Text("Preauthorization: \(String(format: "%.2f", fee)) €")
                                                .font(.caption2)
                                        }
                                    }
                                    Spacer()
                                    Image(systemName: iconName(for: charger.plugType))
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.green)
                                }.padding(.leading, 7.5)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                        }
                    }
                } else {
                    Text("No zone selected")
                        .font(.headline)
                        .padding(.top)
                }
            }
        }
        .navigationTitle(watchDelegate.selectedZone?.name ?? "Booking")
    }

    private func iconName(for plugType: String) -> String {
        switch plugType {
        case "CCS Type 1":
            return "ev.plug.dc.ccs1"
        case "CCS Type 2":
            return "ev.plug.dc.ccs2"
        case "CHAdeMO":
            return "ev.plug.dc.chademo"
        case "Type 1":
            return "ev.plug.ac.type.1"
        case "Type 2":
            return "ev.plug.ac.type.2"
        case "GB/T DC":
            return "ev.plug.dc.gb.t"
        case "GB/T AC":
            return "ev.plug.ac.gb.t"
        case "NACS":
            return "ev.plug.dc.nacs"
        default:
            return "ev.plug.ac.type.2"
        }
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView().environmentObject(WatchDelegate.shared)
    }
}
