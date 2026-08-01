import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fond de l'application très légèrement grisé
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    if cartManager.items.isEmpty {
                        emptyStateView
                    } else {
                        VStack(spacing: 0) {
                            // Liste de produits avec marges latérales de sécurité renforcées (20 pt)
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 14) {
                                    ForEach(cartManager.items) { item in
                                        cartItemCard(for: item)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                                .padding(.bottom, 24)
                            }
                            
                            // Section inférieure : Sous-total, Jauge, Badges et Bouton de commande
                            bottomCheckoutSection
                        }
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                headerView
            }
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .tabBar)
        }
    }
    
    // MARK: - Header (En-tête Premium et Visible)
    private var headerView: some View {
        HStack {
            // Bouton retour avec marge latérale confortable pour ne plus jamais être caché
            Button(action: {
                if presentationMode.wrappedValue.isPresented {
                    presentationMode.wrappedValue.dismiss()
                }
                cartManager.selectedTab = 0
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.primaryGreen)
                }
                .frame(width: 44, height: 44, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Text("Panier")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textDark)
            
            Spacer()
            
            // Élément fantôme pour garantir une symétrie parfaite au pixel près
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 24) // Marge élargie pour protéger des bords arrondis et encoches
        .padding(.vertical, 12)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        )
    }
    
    // MARK: - Carte Produit (Layout Compact & Sans Débordement)
    private func cartItemCard(for item: CartItem) -> some View {
        HStack(alignment: .center, spacing: 12) {
            // Miniature produit calibrée à 68x68 pt pour laisser respirer le texte et les contrôles
            Group {
                if item.product.isSystemImage {
                    Image(systemName: item.product.imageName)
                        .font(.system(size: 30))
                        .foregroundColor(Theme.primaryGreen)
                } else {
                    Image(item.product.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 68, height: 68)
            .background(Color(.systemGray6))
            .cornerRadius(14)
            .clipped()
            
            // Détails : Nom, Prix discret et Contrôleur de quantité
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.product.name)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textDark)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75) // Protection stricte contre l'écrasement
                    
                    Text(formatAmount(item.product.pricePerKg) + " / kg")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(.systemGray))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                // Contrôleur de quantité ergonomique et compact (évite tout débordement à gauche)
                HStack(spacing: 10) {
                    Button(action: { cartManager.updateQuantity(for: item, newQuantity: item.quantity - 1) }) {
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.primaryGreen)
                            .frame(width: 26, height: 26)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("\(item.quantity) kg")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textDark)
                        .frame(minWidth: 32, alignment: .center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                    
                    Button(action: { cartManager.updateQuantity(for: item, newQuantity: item.quantity + 1) }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.primaryGreen)
                            .frame(width: 26, height: 26)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(Color(.systemGray6))
                .cornerRadius(20)
            }
            
            Spacer(minLength: 4)
            
            // Icône de suppression tactile
            Button(action: {
                cartManager.removeFromCart(item: item)
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color.red.opacity(0.85))
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
    
    // MARK: - Section Inférieure de Commande
    private var bottomCheckoutSection: some View {
        VStack(spacing: 18) {
            // Sous-total avec protection anti-troncature
            HStack(alignment: .center) {
                Text("Sous-total")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(.secondaryLabel))
                    .lineLimit(1)
                
                Spacer()
                
                Text(formatAmount(cartManager.subtotal))
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65) // Garantit la visibilité totale des grands montants
            }
            
            // Jauge de livraison offerte modernisée
            VStack(alignment: .leading, spacing: 8) {
                if cartManager.isDeliveryFree {
                    Text("🎉 Livraison offerte sur cette commande !")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.primaryGreen)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    customProgressBar(progress: 1.0, color: Theme.primaryGreen)
                } else {
                    Text("Plus que \(formatAmount(10000 - cartManager.subtotal)) pour la livraison offerte !")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color.orange)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    customProgressBar(progress: min(Double(cartManager.subtotal) / 10000.0, 1.0), color: Color.orange)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Badges compacts, uniformes et harmonieux
            TrustBadgesView()
                .padding(.top, 2)
            
            // Bouton de commande Premium avec marge de sécurité renforcée
            NavigationLink(destination: CheckoutView()) {
                Text("Passer la commande")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Theme.primaryGreen)
                    .cornerRadius(20)
                    .shadow(color: Theme.primaryGreen.opacity(0.35), radius: 10, x: 0, y: 5)
            }
        }
        .padding(.horizontal, 24) // Marge élargie (24 pt) pour une visibilité irréprochable des écritures
        .padding(.top, 22)
        .padding(.bottom, 28) // Protection renforcée contre l'indicateur d'accueil iOS (Barre du bas)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.07), radius: 18, y: -4)
        )
    }
    
    // MARK: - Barre de progression personnalisée (Capsule iOS Native)
    private func customProgressBar(progress: Double, color: Color) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(height: 8)
                
                Capsule()
                    .fill(color)
                    .frame(width: max(geometry.size.width * CGFloat(progress), 0), height: 8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: progress)
            }
        }
        .frame(height: 8)
    }
    
    // MARK: - Empty State Premium
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Theme.primaryGreen.opacity(0.12))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "basket.fill")
                    .font(.system(size: 54))
                    .foregroundColor(Theme.primaryGreen)
            }
            .padding(.bottom, 4)
            
            VStack(spacing: 8) {
                Text("Votre panier est vide")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                
                Text("Découvrez les arrivages frais du marché de Thiaroye et commencez à le remplir !")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Button(action: {
                cartManager.selectedTab = 0
            }) {
                Text("Commencer mes achats")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Theme.primaryGreen)
                    .cornerRadius(20)
                    .shadow(color: Theme.primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Formateur de devises (Format Français : 1 550 FCFA)
    private func formatAmount(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let formattedNumber = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        return "\(formattedNumber) FCFA"
    }
}

#Preview {
    CartView().environmentObject(CartManager())
}
