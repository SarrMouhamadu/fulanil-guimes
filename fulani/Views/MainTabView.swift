import SwiftUI

struct MainTabView: View {
    @StateObject var cartManager = CartManager()
    @StateObject var authManager = AuthManager()
    @StateObject var orderManager = OrderManager()
    
    var body: some View {
        TabView(selection: $cartManager.selectedTab) {
            HomeView()
                .tabItem {
                    Label("Accueil", systemImage: "house.fill")
                }
                .tag(0)
            
            CatalogueView()
                .tabItem {
                    Label("Catalogue", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)
            
            ChatbotView()
                .tabItem {
                    Label("Achat Vocal", systemImage: "mic.fill")
                }
                .tag(2)
            
            CartView()
                .tabItem {
                    Label("Panier", systemImage: "cart.fill")
                }
                .badge(cartManager.cartCount)
                .tag(3)
            
            OrderTrackingView()
                .tabItem {
                    Label("Suivi", systemImage: "box.truck.badge.clock.fill")
                }
                .tag(4)
            
            // Onglet dynamique E-Food (Profil Client, Admin, Fournisseur ou Livreur)
            roleBasedView
                .tabItem {
                    Label("Mon Compte", systemImage: authManager.selectedRole.iconName)
                }
                .tag(5)
        }
        .environmentObject(cartManager)
        .environmentObject(authManager)
        .environmentObject(orderManager)
        .accentColor(Theme.primaryGreen)
        .overlay(
            VStack {
                Spacer()
                if let toastMessage = cartManager.toastMessage {
                    Text(toastMessage)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(25)
                        .shadow(radius: 10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 60)
                }
            }
            .animation(.easeInOut, value: cartManager.toastMessage)
        )
    }
    
    @ViewBuilder
    private var roleBasedView: some View {
        switch authManager.selectedRole {
        case .client:
            ProfileView()
        case .admin:
            AdminDashboardView()
        case .supplier:
            SupplierDashboardView()
        case .driver:
            DeliveryDashboardView()
        }
    }
}

#Preview {
    MainTabView()
}
