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
    
    init(slug: String, name: String, nameEn: String, pricePerKg: Int, category: String, imageName: String = "leaf.fill", isSystemImage: Bool = true, wikipediaUrl: String? = nil) {
        self.slug = slug
        self.name = name
        self.nameEn = nameEn
        self.pricePerKg = pricePerKg
        self.category = category
        self.imageName = imageName
        self.isSystemImage = isSystemImage
        self.wikipediaUrl = wikipediaUrl
    }
}

extension Product {
    static let mockProducts: [Product] = [
        Product(slug: "tomate", name: "Tomate", nameEn: "Tomato", pricePerKg: 800, category: "Légumes-fruits", imageName: "leaf", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Tomate"),
        Product(slug: "oignon", name: "Oignon", nameEn: "Onion", pricePerKg: 600, category: "Tubercules", imageName: "oignon", isSystemImage: false, wikipediaUrl: "https://fr.wikipedia.org/wiki/Oignon"),
        Product(slug: "ail", name: "Ail", nameEn: "Garlic", pricePerKg: 1500, category: "Tubercules", imageName: "sparkles", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Ail"),
        Product(slug: "echalote", name: "Échalote", nameEn: "Shallot", pricePerKg: 1200, category: "Tubercules", imageName: "leaf", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/%C3%89chalote"),
        Product(slug: "carotte", name: "Carotte", nameEn: "Carrot", pricePerKg: 500, category: "Racines", imageName: "carotte", isSystemImage: false, wikipediaUrl: "https://fr.wikipedia.org/wiki/Carotte"),
        Product(slug: "navet", name: "Navet", nameEn: "Turnip", pricePerKg: 600, category: "Racines", imageName: "carrot.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Navet"),
        Product(slug: "betterave", name: "Betterave", nameEn: "Beetroot", pricePerKg: 700, category: "Racines", imageName: "drop.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Betterave"),
        Product(slug: "radis", name: "Radis", nameEn: "Radish", pricePerKg: 800, category: "Racines", imageName: "leaf.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Radis"),
        Product(slug: "pomme-de-terre", name: "Pomme de terre", nameEn: "Potato", pricePerKg: 450, category: "Tubercules", imageName: "pomme_de_terre", isSystemImage: false, wikipediaUrl: "https://fr.wikipedia.org/wiki/Pomme_de_terre"),
        Product(slug: "patate-douce", name: "Patate douce", nameEn: "Sweet potato", pricePerKg: 400, category: "Tubercules", imageName: "oval.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Patate_douce"),
        Product(slug: "manioc", name: "Manioc", nameEn: "Cassava", pricePerKg: 350, category: "Tubercules", imageName: "leaf.arrow.triangle.circlepath", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Manioc"),
        Product(slug: "igname", name: "Igname", nameEn: "Yam", pricePerKg: 900, category: "Tubercules", imageName: "square.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Igname"),
        Product(slug: "taro", name: "Taro", nameEn: "Taro", pricePerKg: 850, category: "Tubercules", imageName: "circle.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Taro"),
        Product(slug: "gingembre", name: "Gingembre", nameEn: "Ginger", pricePerKg: 1200, category: "Racines", imageName: "flame.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Gingembre"),
        Product(slug: "curcuma", name: "Curcuma", nameEn: "Turmeric", pricePerKg: 1400, category: "Racines", imageName: "sun.max.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Curcuma"),
        Product(slug: "poivron", name: "Poivron", nameEn: "Bell pepper", pricePerKg: 1200, category: "Légumes-fruits", imageName: "bell", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Poivron"),
        Product(slug: "piment", name: "Piment", nameEn: "Chili pepper", pricePerKg: 1500, category: "Légumes-fruits", imageName: "flame", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Piment"),
        Product(slug: "aubergine", name: "Aubergine", nameEn: "Eggplant", pricePerKg: 700, category: "Légumes-fruits", imageName: "capsule.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Aubergine"),
        Product(slug: "gombo", name: "Gombo", nameEn: "Okra", pricePerKg: 800, category: "Légumes-fruits", imageName: "star.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Gombo"),
        Product(slug: "concombre", name: "Concombre", nameEn: "Cucumber", pricePerKg: 500, category: "Légumes-fruits", imageName: "oval", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Concombre"),
        Product(slug: "courgette", name: "Courgette", nameEn: "Zucchini", pricePerKg: 900, category: "Légumes-fruits", imageName: "capsule", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Courgette"),
        Product(slug: "courge", name: "Courge", nameEn: "Squash", pricePerKg: 600, category: "Légumes-fruits", imageName: "circle.grid.cross.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Courge"),
        Product(slug: "citrouille", name: "Citrouille", nameEn: "Pumpkin", pricePerKg: 500, category: "Légumes-fruits", imageName: "circle", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Citrouille"),
        Product(slug: "potiron", name: "Potiron", nameEn: "Pumpkin", pricePerKg: 550, category: "Légumes-fruits", imageName: "circle.inset.filled", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Potiron"),
        Product(slug: "chou", name: "Chou", nameEn: "Cabbage", pricePerKg: 700, category: "Feuilles", imageName: "leaf.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Chou"),
        Product(slug: "chou-fleur", name: "Chou-fleur", nameEn: "Cauliflower", pricePerKg: 1300, category: "Feuilles", imageName: "cloud.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Chou-fleur"),
        Product(slug: "brocoli", name: "Brocoli", nameEn: "Broccoli", pricePerKg: 1500, category: "Feuilles", imageName: "tree.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Brocoli"),
        Product(slug: "epinard", name: "Épinard", nameEn: "Spinach", pricePerKg: 900, category: "Feuilles", imageName: "leaf", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/%C3%89pinard"),
        Product(slug: "laitue", name: "Laitue", nameEn: "Lettuce", pricePerKg: 800, category: "Feuilles", imageName: "wind", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Laitue"),
        Product(slug: "poireau", name: "Poireau", nameEn: "Leek", pricePerKg: 1000, category: "Feuilles", imageName: "line.3.horizontal", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Poireau"),
        Product(slug: "haricot-vert", name: "Haricot vert", nameEn: "Green bean", pricePerKg: 1100, category: "Feuilles", imageName: "line.diagonal", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Haricot_vert"),
        Product(slug: "petit-pois", name: "Petit pois", nameEn: "Green pea", pricePerKg: 1200, category: "Feuilles", imageName: "smallcircle.filled.circle", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Pois"),
        Product(slug: "feve", name: "Fève", nameEn: "Broad bean", pricePerKg: 1000, category: "Feuilles", imageName: "ellipsis.circle.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/F%C3%A8ve"),
        Product(slug: "mais", name: "Maïs", nameEn: "Maize", pricePerKg: 400, category: "Céréales & Légumineuses", imageName: "square.grid.3x3.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Ma%C3%AFs"),
        Product(slug: "ble", name: "Blé", nameEn: "Wheat", pricePerKg: 500, category: "Céréales & Légumineuses", imageName: "chart.bar.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Bl%C3%A9"),
        Product(slug: "riz", name: "Riz", nameEn: "Rice", pricePerKg: 450, category: "Céréales & Légumineuses", imageName: "shippingbox.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Riz"),
        Product(slug: "mil", name: "Mil", nameEn: "Millet", pricePerKg: 400, category: "Céréales & Légumineuses", imageName: "circle.grid.2x2.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Mil"),
        Product(slug: "sorgho", name: "Sorgho", nameEn: "Sorghum", pricePerKg: 450, category: "Céréales & Légumineuses", imageName: "rays", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Sorgho"),
        Product(slug: "fonio", name: "Fonio", nameEn: "Fonio", pricePerKg: 1200, category: "Céréales & Légumineuses", imageName: "sparkle", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Fonio"),
        Product(slug: "niebe", name: "Niébé", nameEn: "Cowpea", pricePerKg: 700, category: "Céréales & Légumineuses", imageName: "suit.heart.fill", isSystemImage: true, wikipediaUrl: "https://fr.wikipedia.org/wiki/Ni%C3%A9b%C3%A9")
    ]
}
