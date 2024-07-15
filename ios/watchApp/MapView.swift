import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate
    @State private var mapPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.6333, longitude: -0.5964),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))
    
    @State private var selectedCharger: EVCharger?
    
    var body: some View {
        Map(position: $mapPosition) {
            ForEach(watchDelegate.chargers) { charger in
                Annotation("", coordinate: charger.coordinate) {
                    ZStack(alignment: .center) {
                        if selectedCharger?.id == charger.id {
                            Text(charger.chargerName)
                                .bold()
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.black.opacity(0.75))
                                .cornerRadius(10)
                                .font(.system(size: 12))
                                .offset(y: -30)
                                .zIndex(1)
                        }
                        
                        Circle()
                            .fill(selectedCharger?.id == charger.id ? Color.green.opacity(0.3) : Color.clear)
                            .frame(width: 20, height: 20)
                            .background(Color(.sRGB, red: 0.0, green: 0.3, blue: 0.0, opacity: 1.0))
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.green, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                            )
                            .overlay(
                                Image(systemName: "bolt.car.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 12))
                            )
                            .onTapGesture {
                                if selectedCharger?.id == charger.id {
                                    selectedCharger = nil
                                } else {
                                    selectedCharger = charger
                                    centerMap(on: charger.coordinate)
                                }
                            }
                            .zIndex(0)
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapCompass()
        }
        .gesture(TapGesture().onEnded {
            selectedCharger = nil
        })
    }
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
            withAnimation {
                mapPosition = .region(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
            }
        }
}
