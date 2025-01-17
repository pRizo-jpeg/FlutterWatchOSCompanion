import SwiftUI
import MapKit

// View for displaying the map //
struct MapView: View {
    
    @EnvironmentObject var watchDelegate: WatchDelegate                         /// Environment object to manage the state and data shared across views
    
    @State private var mapPosition = MapCameraPosition.region(                  /// Initial camera position of the map
        MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.6333, longitude: -0.5964),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))
    
    @State private var selectedZone: ChargingZone?
    
    
    var body: some View {
        Map(position: $mapPosition) {
            ForEach(watchDelegate.chargingZones) { zone in
                Annotation("", coordinate: zone.coordinate) {
                    ZStack(alignment: .center) {
                        
                        if selectedZone?.id == zone.id {                        /// Label bubble when selected zone
                            Text(zone.name)
                                .bold()
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.black.opacity(0.75))
                                .cornerRadius(10)
                                .font(.system(size: 12))
                                .offset(y: -35)
                                .zIndex(100)
                        }
                        
                        TailMarker(isSelected: selectedZone?.id == zone.id)     /// Locations marker and gesture detector
                            .onTapGesture {                                     /// Marker selected toggle
                                if selectedZone?.id == zone.id {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { /// as a fix for tap overlapping
                                        print("reset press")
                                        selectedZone = nil
                                        watchDelegate.selectedZone = nil
                                    }
                                  
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { /// as a fix for tap overlapping
                                        print("marker press")
                                        selectedZone = zone
                                        watchDelegate.selectedZone = zone
                                        centerMap(on: zone.coordinate)
                                    }
                                }
                            }
                            .zIndex(0)
                            .allowsHitTesting(true)
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapCompass()
        }
        .contentShape(Rectangle()).zIndex(-1)
        .gesture(TapGesture().onEnded {                                         /// Map area tapped
            print("map press")
            if selectedZone != nil {
                selectedZone = nil
                watchDelegate.selectedZone = nil
            }
        })
    }
    
    private func centerMap(on coordinate: CLLocationCoordinate2D) {             /// Map centering on spot function
        let newLatitudeDelta = max(0.005, 0.005)
        withAnimation {
            mapPosition = .region(MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: newLatitudeDelta, longitudeDelta: newLatitudeDelta)
            ))
        }
    }
}


// Circle + small inverted triangle to make map marker shape //
struct TailMarker: View {
    var isSelected: Bool
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.green.opacity(0.3) : Color.clear)
                    .frame(width: 20, height: 20)
                    .background(isSelected ? Color(red: 0.0, green: 0.4, blue: 0.0) : Color(red: 0.0, green: 0.3, blue: 0.0))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.green.opacity(0.5) : Color(red: 0.0, green: 0.5, blue: 0.0), lineWidth: 2)
                            .frame(width: 20, height: 20)
                    )
                    .overlay(
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 12))
                    )
            }
            
            InvertedTriangle()
                .fill(isSelected ? Color.green.opacity(0.5) : Color(red: 0.0, green: 0.5, blue: 0.0))
                .frame(width: 10, height: 5)
        }
    }
}

struct InvertedTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
