import Foundation
import CoreLocation

struct MockData {
    static let vehicles: [Vehicle] = [
        Vehicle(id: UUID(), name: "Tesla Model S"),
        Vehicle(id: UUID(), name: "Nissan Leaf"),
        Vehicle(id: UUID(), name: "BMW i3")
    ]

    static let paymentMethods: [PaymentMethod] = [
        PaymentMethod(id: UUID(), name: "Credit Card"),
        PaymentMethod(id: UUID(), name: "PayPal"),
        PaymentMethod(id: UUID(), name: "Apple Pay")
    ]
    
    static let chargingZones: [ChargingZone] = [
        ChargingZone(id: UUID(), name: "Mercadona EV Station", coordinate: CLLocationCoordinate2D(latitude: 39.6333, longitude: -0.5964), chargers: [
            EVCharger(id: UUID(), plugType: "CCS Type 1", price: 15.5, preauthorizationFee: 5),
            EVCharger(id: UUID(), plugType: "CCS Type 2", price: 25.5, preauthorizationFee: nil),
            EVCharger(id: UUID(), plugType: "GB/T DC", price: 12, preauthorizationFee: 10),
            EVCharger(id: UUID(), plugType: "Type 2", price: nil, preauthorizationFee: nil)
        ]),
        ChargingZone(id: UUID(), name: "Calle Pascual Free Charger", coordinate: CLLocationCoordinate2D(latitude: 39.6350, longitude: -0.5950), chargers: [
            EVCharger(id: UUID(), plugType: "CHAdeMO", price: nil, preauthorizationFee: nil),
            EVCharger(id: UUID(), plugType: "Type 2", price: 15.5, preauthorizationFee: 10)
        ]),
        ChargingZone(id: UUID(), name: "Circular Demo Llíria", coordinate: CLLocationCoordinate2D(latitude: 39.6310, longitude: -0.5980), chargers: [
            EVCharger(id: UUID(), plugType: "Type 1", price: 1.5, preauthorizationFee: 15),
            EVCharger(id: UUID(), plugType: "Type 2", price: 7.5, preauthorizationFee: nil),
            EVCharger(id: UUID(), plugType: "CHAdeMO", price: 5.5, preauthorizationFee: nil),
            EVCharger(id: UUID(), plugType: "GB/T DC", price: 11.1, preauthorizationFee: 1)
        ]),
        ChargingZone(id: UUID(), name: "Ayto. Free Charger", coordinate: CLLocationCoordinate2D(latitude: 39.6310, longitude: -0.5911), chargers: [
            EVCharger(id: UUID(), plugType: "CHAdeMO", price: nil, preauthorizationFee: nil),
            EVCharger(id: UUID(), plugType: "NACS", price: 15.5, preauthorizationFee: 10)
        ]),
        ChargingZone(id: UUID(), name: "Estación EV Llíria", coordinate: CLLocationCoordinate2D(latitude: 39.6333, longitude: -0.5919), chargers: [
            EVCharger(id: UUID(), plugType: "Type 1", price: 1.5, preauthorizationFee: 15),
            EVCharger(id: UUID(), plugType: "CHAdeMO", price: 7.5, preauthorizationFee: nil),
            EVCharger(id: UUID(), plugType: "CHAdeMO", price: 5.5, preauthorizationFee: nil),
            EVCharger(id: UUID(), plugType: "NACS", price: 11.1, preauthorizationFee: 1)
        ]),
    ]
}
