import SwiftUI
import Combine

struct CartItem: Identifiable {
    let id = UUID()
    var product: Product? = nil
    var basket: SmartBasket? = nil
    var eventCalculation: EventCalculation? = nil
    var quantity: Int = 1
    
    var title: String {
        if let product = product { return product.name }
        if let basket = basket { return basket.name }
        if let event = eventCalculation { return "\(event.eventType) (\(event.guestCount) pers.)" }
        return "Article E-Food"
    }
    
    var pricePerUnit: Int {
        if let product = product { return product.pricePerKg }
        if let basket = basket { return basket.price }
        if let event = eventCalculation { return event.totalPrice }
        return 0
    }
    
    var totalPrice: Int {
        pricePerUnit * quantity
    }
    
    var unitDescription: String {
        if let product = product { return "\(product.pricePerKg.formattedFCFA) / kg" }
        if let basket = basket { return "\(basket.price.formattedFCFA) (\(basket.servings) pers.)" }
        if let event = eventCalculation { return "\(event.totalPrice.formattedFCFA) (Ingrédients inclus)" }
        return ""
    }
    
    var imageName: String {
        if let product = product { return product.imageName }
        if let basket = basket { return basket.imageName }
        if let _ = eventCalculation { return "sparkles" }
        return "leaf"
    }
    
    var isSystemImage: Bool {
        if let product = product { return product.isSystemImage }
        if let basket = basket { return basket.isSystemImage }
        return true
    }
}

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var toastMessage: String? = nil
    @Published var cartBounces: Bool = false
    @Published var selectedTab: Int = 0 // Routage programmable
    
    var subtotal: Int {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var cartCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var isDeliveryFree: Bool {
        subtotal >= 10000
    }
    
    func addToCart(product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product?.id == product.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
        
        triggerFeedback(message: "\(product.name) ajouté au panier !")
    }
    
    func addBasketToCart(basket: SmartBasket, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.basket?.id == basket.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(basket: basket, quantity: quantity))
        }
        
        triggerFeedback(message: "\(basket.name) ajouté au panier !")
    }
    
    func addEventCalculationToCart(event: EventCalculation) {
        items.append(CartItem(eventCalculation: event, quantity: 1))
        triggerFeedback(message: "Pack \(event.eventType) (\(event.guestCount) pers.) ajouté !")
    }
    
    private func triggerFeedback(message: String) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        showToast(message: message)
    }
    
    func showToast(message: String) {
        toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                if self.toastMessage == message {
                    self.toastMessage = nil
                }
            }
        }
    }
    
    func updateQuantity(for item: CartItem, newQuantity: Int) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity = newQuantity
            if items[index].quantity <= 0 {
                items.remove(at: index)
            }
        }
    }
    
    func removeFromCart(item: CartItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }
    
    func confirmOrderAndNavigateToTracking() {
        items.removeAll()
        selectedTab = 4
    }
}
