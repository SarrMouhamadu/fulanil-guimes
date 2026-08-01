import SwiftUI
import Combine

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
}

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var toastMessage: String? = nil
    @Published var cartBounces: Bool = false
    @Published var selectedTab: Int = 0 // Routage programmable (ex: 0 = Accueil, 1 = Catalogue)
    
    var subtotal: Int {
        items.reduce(0) { $0 + ($1.product.pricePerKg * $1.quantity) }
    }
    
    var cartCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var isDeliveryFree: Bool {
        subtotal >= 10000
    }
    
    func addToCart(product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Animation et Toast
        withAnimation {
            cartBounces.toggle()
        }
        showToast(message: "\(product.name) ajouté(es) au panier !")
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
    
    func clearCart() {
        items.removeAll()
    }
}
