import SwiftUI
import CoreLocation

struct BookingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var watchDelegate: WatchDelegate
    @State private var selectedVehicle: String = ""
    @State private var selectedPaymentMethod: String = ""
    @State private var showAlert = false
    @State private var selectedCharger: EVCharger?

    var body: some View {
        ScrollView {
            VStack {
                if let selectedZone = watchDelegate.selectedZone {
                    ForEach(selectedZone.chargers) { charger in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 3).padding(.leading, 5).padding(.vertical, 8.5)
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
                            .onTapGesture {
                                selectedCharger = charger
                                showAlert = true
                            }
                            .swipeActions(edge: .leading) {
                                Button(action: {
                                    print("Botón de acción presionado")
                                }) {
                                    Text("Action")
                                }
                                .tint(.blue)
                            }
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
        .onDisappear {
            presentationMode.wrappedValue.dismiss()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(selectedCharger?.plugType ?? "Tipo ??"),
                message: Text("\n Do you want to book the charger?"),
                primaryButton: .cancel(),
                secondaryButton: .default(Text("Continue")) {
                    bookCharger(selectedCharger)
                }
            )
        }
    }

    private func bookCharger(_ charger: EVCharger?) {
        guard let charger = charger else { return }
        // Implement your booking action here
        print("Booking charger: \(charger)")
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
