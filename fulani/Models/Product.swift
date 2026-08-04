import Foundation

struct Product: Identifiable {
    let id = UUID()
    let slug: String
    let name: String
    let nameEn: String
    let pricePerKg: Int
    let category: String
    let imageName: String
    var isSystemImage: Bool = true
    let wikipediaUrl: String?
    let imageUrl: String?
    
    init(slug: String, name: String, nameEn: String, pricePerKg: Int, category: String, imageName: String = "leaf.fill", isSystemImage: Bool = true, wikipediaUrl: String? = nil, imageUrl: String? = nil) {
        self.slug = slug
        self.name = name
        self.nameEn = nameEn
        self.pricePerKg = pricePerKg
        self.category = category
        self.imageName = imageName
        self.isSystemImage = isSystemImage
        self.wikipediaUrl = wikipediaUrl
        self.imageUrl = imageUrl
    }
}

extension Product {
    static let mockProducts: [Product] = [
        Product(
            slug: "tomate",
            name: "Tomates",
            nameEn: "Tomato",
            pricePerKg: 800,
            category: "Légumes-fruits",
            imageName: "leaf",
            isSystemImage: true,
            wikipediaUrl: "https://fr.wikipedia.org/wiki/Tomate",
            imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Tomato_je.jpg/320px-Tomato_je.jpg"
        ),
        Product(
            slug: "oignon",
            name: "Oignons",
            nameEn: "Onion",
            pricePerKg: 600,
            category: "Tubercules",
            imageName: "oignon",
            isSystemImage: false,
            wikipediaUrl: "https://fr.wikipedia.org/wiki/Oignon"
        ),
        Product(
            slug: "carotte",
            name: "Carottes",
            nameEn: "Carrot",
            pricePerKg: 500,
            category: "Racines",
            imageName: "carotte",
            isSystemImage: false,
            wikipediaUrl: "https://fr.wikipedia.org/wiki/Carotte"
        ),
        Product(
            slug: "pomme-de-terre",
            name: "Pommes de terre",
            nameEn: "Potato",
            pricePerKg: 450,
            category: "Tubercules",
            imageName: "pomme_de_terre",
            isSystemImage: false,
            wikipediaUrl: "https://fr.wikipedia.org/wiki/Pomme_de_terre"
        ),
        Product(
            slug: "poivron",
            name: "Poivrons",
            nameEn: "Bell pepper",
            pricePerKg: 1200,
            category: "Légumes-fruits",
            imageName: "bell",
            isSystemImage: true,
            wikipediaUrl: "https://fr.wikipedia.org/wiki/Poivron",
            imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Bell_peppers_multicolored.jpg/320px-Bell_peppers_multicolored.jpg"
        )
    ]
}
