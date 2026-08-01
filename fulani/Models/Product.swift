import Foundation

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let pricePerKg: Int
    let category: String
    let imageName: String
    var isSystemImage: Bool = true // Par défaut, on utilise des icônes système, sinon on utilise les assets
}

extension Product {
    static let mockProducts = [
        Product(name: "Tomates", pricePerKg: 800, category: "Légumes-fruits", imageName: "leaf"),
        Product(name: "Carottes", pricePerKg: 500, category: "Racines", imageName: "carotte", isSystemImage: false),
        Product(name: "Oignons", pricePerKg: 600, category: "Tubercules", imageName: "oignon", isSystemImage: false),
        Product(name: "Choux", pricePerKg: 700, category: "Feuilles", imageName: "leaf.fill"),
        Product(name: "Poivrons", pricePerKg: 1200, category: "Légumes-fruits", imageName: "bell"),
        Product(name: "Pommes de terre", pricePerKg: 450, category: "Tubercules", imageName: "pomme_de_terre", isSystemImage: false)
    ]
}
