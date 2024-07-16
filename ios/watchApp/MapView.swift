import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate
    @State private var mapPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.6333, longitude: -0.5964),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))
    
    @State private var selectedZone: ChargingZone?
    
    var body: some View {
        Map(position: $mapPosition) {
            ForEach(watchDelegate.chargingZones) { zone in
                Annotation("", coordinate: zone.coordinate) {
                    ZStack(alignment: .center) {
                        if selectedZone?.id == zone.id {
                            Text(zone.name)
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
                            .fill(selectedZone?.id == zone.id ? Color.green.opacity(0.3) : Color.clear)
                            .frame(width: 20, height: 20)
                            .background(selectedZone?.id == zone.id ? Color(red: 0.0, green: 0.4, blue: 0.0) : Color(red: 0.0, green: 0.3, blue: 0.0))
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(selectedZone?.id == zone.id ? Color.green.opacity(0.5) : Color(red: 0.0, green: 0.5, blue: 0.0), lineWidth: 2)
                                    .frame(width: 20, height: 20)
                            )
                            .overlay(
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 12))
                            )
                            .onTapGesture {
                                if selectedZone?.id == zone.id {
                                    selectedZone = nil
                                    watchDelegate.selectedZone = nil
                                } else {
                                    selectedZone = zone
                                    watchDelegate.selectedZone = zone
                                    centerMap(on: zone.coordinate)
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
            selectedZone = nil
            watchDelegate.selectedZone = nil
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
