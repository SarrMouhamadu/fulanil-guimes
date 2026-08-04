import SwiftUI
import Combine

class OrderManager: ObservableObject {
    @Published var orders: [Order] = []
    @Published var latestCreatedOrder: Order? = nil
    
    init() {
        // Commande de démonstration initiale
        let sampleItems = [
            OrderItem(productName: "Tomates", pricePerKg: 800, quantity: 3, unit: "kg"),
            OrderItem(productName: "Oignons", pricePerKg: 600, quantity: 2, unit: "kg")
        ]
        
        let sampleOrder = Order(
            orderNumber: "#EF-8492",
            clientName: "Mamadou Diallo",
            clientPhone: "+221 77 123 45 67",
            deliveryAddress: "Mermoz, Dakar, Sénégal",
            items: sampleItems,
            subtotal: 3600,
            deliveryFee: 1000,
            status: .delivering,
            paymentMethod: "Wave",
            assignedDriverName: "Amadou Fall",
            createdAt: Date()
        )
        
        self.orders = [sampleOrder]
        self.latestCreatedOrder = sampleOrder
    }
    
    func createOrder(clientName: String, clientPhone: String, deliveryAddress: String, cartItems: [CartItem], paymentMethod: String) -> Order {
        let orderItems = cartItems.map {
            OrderItem(
                productName: $0.product.name,
                pricePerKg: $0.product.pricePerKg,
                quantity: $0.quantity,
                unit: $0.product.unit
            )
        }
        
        let subtotal = cartItems.reduce(0) { $0 + ($1.product.pricePerKg * $1.quantity) }
        let deliveryFee = subtotal >= 10000 ? 0 : 1000
        let randomNum = Int.random(in: 1000...9999)
        let orderNumber = "#EF-\(randomNum)"
        
        let newOrder = Order(
            orderNumber: orderNumber,
            clientName: clientName,
            clientPhone: clientPhone,
            deliveryAddress: deliveryAddress,
            items: orderItems,
            subtotal: subtotal,
            deliveryFee: deliveryFee,
            status: .new,
            paymentMethod: paymentMethod,
            assignedDriverName: nil,
            createdAt: Date()
        )
        
        orders.insert(newOrder, at: 0)
        latestCreatedOrder = newOrder
        return newOrder
    }
    
    func updateStatus(orderId: UUID, newStatus: OrderStatus) {
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            orders[index].status = newStatus
            if latestCreatedOrder?.id == orderId {
                latestCreatedOrder?.status = newStatus
            }
        }
    }
    
    func assignDriver(orderId: UUID, driverName: String) {
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            orders[index].assignedDriverName = driverName
            orders[index].status = .delivering
            if latestCreatedOrder?.id == orderId {
                latestCreatedOrder?.assignedDriverName = driverName
                latestCreatedOrder?.status = .delivering
            }
        }
    }
    
    // Statistiques financières E-Food
    var totalGrossRevenue: Int {
        orders.filter { $0.status != .cancelled }.reduce(0) { $0 + $1.subtotal }
    }
    
    var totalEFoodCommission: Int {
        orders.filter { $0.status != .cancelled }.reduce(0) { $0 + $1.commissionAmount }
    }
    
    var totalSupplierPayouts: Int {
        orders.filter { $0.status != .cancelled }.reduce(0) { $0 + $1.supplierPayout }
    }
}
