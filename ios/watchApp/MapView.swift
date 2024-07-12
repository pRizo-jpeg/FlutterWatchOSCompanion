import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.6333, longitude: -0.5964), /// Llíria
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var selectedLocation: Location?
    
    struct Location: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
        let name: String
    }

    let annotations = [
        Location(coordinate: CLLocationCoordinate2D(latitude: 39.6333, longitude: -0.5964), name: "Mercadona EV Station"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 39.6350, longitude: -0.5950), name: "Calle Pascual Free Charger"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 39.6310, longitude: -0.5980), name: "Circular Demo Llíria"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 39.6340, longitude: -0.5990), name: "Avenida de la Estación Charger"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 39.6320, longitude: -0.5940), name: "Plaza Mayor Charging Point"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 39.6433, longitude: -0.5964), name: "Calle San Vicente Charger"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 39.6378, longitude: -0.6030), name: "Instituto Charger Llíria"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 39.6423, longitude: -0.6064), name: "Polígono Industrial Charger"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 39.6238, longitude: -0.6061), name: "Hospital Comarcal EV Station"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 39.6233, longitude: -0.5964), name: "Parque de la Bombilla Charger"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 39.6288, longitude: -0.5917), name: "Calle San Miguel Charger")
    ]
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: annotations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    ZStack {
                        Circle()
                            .strokeBorder(selectedLocation?.id == location.id ? Color.green.opacity(0.7) : Color.black.opacity(0.7), lineWidth: 4)
                            .frame(width: 20, height: 20)
                            .background(Circle().foregroundColor(.green).opacity(0.3))
                            .onTapGesture {
                                selectedLocation = location
                                centerMap(on: location.coordinate)
                            }
                        
                        if selectedLocation?.id == location.id {
                            Text(location.name)
                                .font(.custom("marklabel", size: 14))
                                .padding(.vertical, 5)
                                .padding(.horizontal, 8)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(25)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: 200) // Adjust width as needed
                                .multilineTextAlignment(.center)
                                .offset(y: -30)
                                .transition(.opacity)
                        }
                    }
                }
            }
            .clipShape(RoundedCornerShape(corners: [.allCorners], radius: 40))
            .edgesIgnoringSafeArea(.all)
            .padding(.bottom, 35)
            .background(Color.clear)
            .onTapGesture {
                withAnimation {
                    selectedLocation = nil
                }
            }
        }
    }
    
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        withAnimation {
            region.center = coordinate
            if region.span.latitudeDelta > 0.01 && region.span.longitudeDelta > 0.01 {
                region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) 
            }
        }
    }
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
