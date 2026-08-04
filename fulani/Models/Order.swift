import Foundation

enum OrderStatus: String, Codable, CaseIterable, Identifiable {
    case new = "Nouvelle"
    case confirmed = "Confirmée ✅"
    case preparing = "En préparation 🧺"
    case delivering = "En livraison 🚴"
    case delivered = "Livrée 🏠"
    case cancelled = "Annulée ❌"
    
    var id: String { self.rawValue }
}

struct OrderItem: Identifiable, Codable {
    var id: UUID = UUID()
    let productName: String
    let pricePerKg: Int
    let quantity: Int
    let unit: String
    
    var itemTotal: Int {
        pricePerKg * quantity
    }
}

struct Order: Identifiable, Codable {
    var id: UUID = UUID()
    let orderNumber: String // Ex: #EF-8492
    let clientName: String
    let clientPhone: String
    let deliveryAddress: String
    let items: [OrderItem]
    let subtotal: Int
    let deliveryFee: Int
    var status: OrderStatus
    let paymentMethod: String
    var assignedDriverName: String?
    let createdAt: Date
    
    // Taux de commission E-Food (15%)
    static let commissionRate: Double = 0.15
    
    var commissionAmount: Int {
        Int(Double(subtotal) * Order.commissionRate)
    }
    
    var supplierPayout: Int {
        subtotal - commissionAmount
    }
    
    var grandTotal: Int {
        subtotal + deliveryFee
    }
}
