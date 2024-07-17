import Foundation
import CoreLocation

struct Vehicle: Identifiable {
    let id: UUID
    let name: String
}

struct PaymentMethod: Identifiable {
    let id: UUID
    let name: String
}

struct EVCharger: Identifiable {
    let id: UUID
    let plugType: String
    let price: Double?
    let preauthorizationFee: Double?
}

struct ChargingZone: Identifiable {
    let id: UUID
    let name: String
    let coordinate: CLLocationCoordinate2D
    var chargers: [EVCharger]
    
    var availablePlugTypes: [String] {
        chargers.map { $0.plugType }
    }
    
    enum PlugType: String, CaseIterable {
        case type1 = "Type 1"
        case type2 = "Type 2"
        case chademo = "CHAdeMO"
        case ccs1 = "CCS Type 1"
        case ccs2 = "CCS Type 2"
        case gbtDC = "GB/T DC"
        case gbtAC = "GB/T AC"
        case nacs = "NACS"
    }
}
