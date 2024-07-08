import Foundation

class User {
    var name: String?
    var id: Int?

    init(name: String?, id: Int?) {
        self.name = name
        self.id = id
    }

    func toDictionary() -> [String: Any] {
        return ["name": name ?? "", "id": id ?? 0]
    }
}
