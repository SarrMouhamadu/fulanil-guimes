import Foundation

struct Product: Identifiable, Equatable {
    let id: UUID
    let name: String
    let pricePerKg: Int
    let category: String
    let imageName: String
    var isSystemImage: Bool
    
    init(id: UUID = UUID(), name: String, pricePerKg: Int, category: String, imageName: String, isSystemImage: Bool = true) {
        self.id = id
        self.name = name
        self.pricePerKg = pricePerKg
        self.category = category
        self.imageName = imageName
        self.isSystemImage = isSystemImage
    }
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

// MARK: - Paniers Intelligents (Recettes locales E-Food)
struct SmartBasket: Identifiable, Equatable {
    let id: UUID
    let name: String
    let recipeName: String
    let price: Int
    let servings: Int
    let imageName: String
    var isSystemImage: Bool
    let ingredients: [String]
    let description: String
    
    init(id: UUID = UUID(), name: String, recipeName: String, price: Int, servings: Int = 6, imageName: String, isSystemImage: Bool = true, ingredients: [String], description: String) {
        self.id = id
        self.name = name
        self.recipeName = recipeName
        self.price = price
        self.servings = servings
        self.imageName = imageName
        self.isSystemImage = isSystemImage
        self.ingredients = ingredients
        self.description = description
    }
}

extension SmartBasket {
    static let mockBaskets = [
        SmartBasket(
            name: "Panier Thiéboudienne",
            recipeName: "Ceebu Jën (Riz au Poisson)",
            price: 7500,
            servings: 6,
            imageName: "leaf.fill",
            ingredients: [
                "1 kg Riz brisé du Sénégal",
                "500g Tomates fraîches Thiaroye",
                "3 Carottes locales",
                "1/2 Chou vert",
                "2 Piments frais",
                "500g Oignons",
                "1 Manioc"
            ],
            description: "Tous les légumes et ingrédients frais du marché de Thiaroye nécessaires pour préparer un délicieux Thiéboudienne traditionnel pour 6 personnes."
        ),
        SmartBasket(
            name: "Panier Yassa",
            recipeName: "Yassa (Poulet / Poisson)",
            price: 5500,
            servings: 6,
            imageName: "flame.fill",
            ingredients: [
                "1.5 kg Oignons locaux",
                "5 Citrons frais",
                "2 Piments verts",
                "Moutarde & condiments",
                "Carottes d'accompagnement"
            ],
            description: "Le panier parfait pour réussir un Yassa savoureux riche en oignons caramélisés et citrons frais."
        ),
        SmartBasket(
            name: "Panier Mafé",
            recipeName: "Mafé (Sauce Arachide)",
            price: 6000,
            servings: 6,
            imageName: "takeoutbag.and.cup.and.straw.fill",
            ingredients: [
                "400g Pâte d'arachide artisanale",
                "500g Tomates fraîches",
                "3 Oignons",
                "500g Patates douces",
                "Carottes & piment"
            ],
            description: "La sélection complète de tubercules et pâte d'arachide pour un Mafé authentique et onctueux."
        ),
        SmartBasket(
            name: "Panier Soupou Kandia",
            recipeName: "Soupou Kandia (Sauce Gombo)",
            price: 8000,
            servings: 6,
            imageName: "leaf.circle.fill",
            ingredients: [
                "1 kg Gombos frais du marché",
                "250ml Huile de palme rouge",
                "Poisson séché (Keccax)",
                "Oignons & Piment"
            ],
            description: "Gombos frais et huile de palme naturelle pour concocter un plat de Soupou Kandia d'exception."
        )
    ]
}

// MARK: - Service Événementiel E-Food
struct EventCalculation: Identifiable {
    let id = UUID()
    let eventType: String
    let guestCount: Int
    let mealType: String
    let totalPrice: Int
    let ingredientsBreakdown: [String]
}
