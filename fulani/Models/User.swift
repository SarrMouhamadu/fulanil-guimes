import Foundation

enum UserRole: String, Codable, CaseIterable, Identifiable {
    case client = "Client"
    case admin = "Administrateur E-Food"
    case supplier = "Fournisseur (Thiaroye)"
    case driver = "Livreur"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .client: return "person.crop.circle"
        case .admin: return "shield.fill"
        case .supplier: return "storefront.fill"
        case .driver: return "bicycle"
        }
    }
}

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var phoneNumber: String
    var address: String
    var role: UserRole
    
    init(id: UUID = UUID(), name: String, phoneNumber: String, address: String = "", role: UserRole = .client) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.role = role
    }
}
