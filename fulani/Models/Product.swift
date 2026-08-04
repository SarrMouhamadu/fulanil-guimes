import Foundation

struct Product: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    let name: String
    let pricePerKg: Int
    let category: String
    let imageName: String
    var unit: String = "kg" // Unité de vente (ex: kg, botte, sachet)
    var isSystemImage: Bool = true
    
    // Conformation personnalisée Codable pour UUID généré si besoin
    enum CodingKeys: String, CodingKey {
        case id, name, pricePerKg, category, imageName, unit, isSystemImage
    }
}

extension Product {
    static let mockProducts = [
        Product(name: "Tomates", pricePerKg: 800, category: "Légumes-fruits", imageName: "leaf", unit: "kg"),
        Product(name: "Carottes", pricePerKg: 500, category: "Racines", imageName: "carotte", unit: "kg", isSystemImage: false),
        Product(name: "Oignons", pricePerKg: 600, category: "Tubercules", imageName: "oignon", unit: "kg", isSystemImage: false),
        Product(name: "Choux", pricePerKg: 700, category: "Feuilles", imageName: "leaf.fill", unit: "kg"),
        Product(name: "Poivrons", pricePerKg: 1200, category: "Légumes-fruits", imageName: "bell", unit: "kg"),
        Product(name: "Pommes de terre", pricePerKg: 450, category: "Tubercules", imageName: "pomme_de_terre", unit: "kg", isSystemImage: false)
    ]
}
