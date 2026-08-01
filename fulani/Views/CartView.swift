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
                
                // Intégration du Header en tête de VStack pour garantir qu'il ne passe JAMAIS sous l'encoche (Notch/Dynamic Island)
                VStack(spacing: 0) {
                    headerView
                    
                    if cartManager.items.isEmpty {
                        emptyStateView
                    } else {
                        VStack(spacing: 0) {
                            // Liste de produits contrainte strictement dans les limites de l'écran
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 12) {
                                    ForEach(cartManager.items) { item in
                                        cartItemCard(for: item)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 12)
                                .padding(.bottom, 20)
                                .frame(maxWidth: .infinity)
                            }
                            
                            // Section inférieure : Sous-total, Jauge, Badges et Bouton de commande
                            bottomCheckoutSection
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header (En-tête Premium Parfaitement Visible)
    private var headerView: some View {
        HStack {
            // Bouton retour dégagé des bords de l'écran
            Button(action: {
                if presentationMode.wrappedValue.isPresented {
                    presentationMode.wrappedValue.dismiss()
                }
                cartManager.selectedTab = 0
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.primaryGreen)
                    Text("Retour")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.primaryGreen)
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Text("Panier (\(cartManager.cartCount))")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textDark)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Spacer()
            
            // Élément fantôme pour préserver une symétrie exacte
            Color.clear
                .frame(width: 65, height: 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        )
    }
    
    // MARK: - Carte Produit (Calibrage strict pour interdir tout débordement à gauche)
    private func cartItemCard(for item: CartItem) -> some View {
        HStack(alignment: .center, spacing: 12) {
            // Miniature produit calibrée exactement à 60x60 pt pour une insertion parfaite à gauche
            Group {
                if item.product.isSystemImage {
                    Image(systemName: item.product.imageName)
                        .font(.system(size: 28))
                        .foregroundColor(Theme.primaryGreen)
                } else {
                    Image(item.product.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 60, height: 60)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .clipped()
            
            // Colonne Texte flexible qui se rétracte au besoin au lieu d'élargir la carte
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                
                Text(formatAmount(item.product.pricePerKg) + " / kg")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(.systemGray))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Contrôleur de quantité ultra-compact (largeur totale garantie < 85 pt)
            HStack(spacing: 6) {
                Button(action: { cartManager.updateQuantity(for: item, newQuantity: item.quantity - 1) }) {
                    Image(systemName: "minus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.primaryGreen)
                        .frame(width: 24, height: 24)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("\(item.quantity)")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                    .frame(minWidth: 20, alignment: .center)
                
                Button(action: { cartManager.updateQuantity(for: item, newQuantity: item.quantity + 1) }) {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.primaryGreen)
                        .frame(width: 24, height: 24)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(Color(.systemGray6))
            .cornerRadius(16)
            
            // Icône de suppression rapprochée et tactile
            Button(action: {
                cartManager.removeFromCart(item: item)
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.red.opacity(0.85))
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity) // Interdit absolument à la carte de déborder de l'écran
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
    
    // MARK: - Section Inférieure de Commande (Sans Troncature)
    private var bottomCheckoutSection: some View {
        VStack(spacing: 14) {
            // Sous-total avec visibilité 100% garantie sur tous les écrans
            HStack(alignment: .center) {
                Text("Sous-total")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(.secondaryLabel))
                    .lineLimit(1)
                
                Spacer()
                
                Text(formatAmount(cartManager.subtotal))
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(Theme.textDark)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5) // Rend impossible la coupure des chiffres du prix
            }
            
            // Jauge de livraison offerte
            VStack(alignment: .leading, spacing: 6) {
                if cartManager.isDeliveryFree {
                    Text("🎉 Livraison offerte sur cette commande !")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.primaryGreen)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    customProgressBar(progress: 1.0, color: Theme.primaryGreen)
                } else {
                    Text("Plus que \(formatAmount(10000 - cartManager.subtotal)) pour la livraison gratuite !")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.orange)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    customProgressBar(progress: min(Double(cartManager.subtotal) / 10000.0, 1.0), color: Color.orange)
                }
            }
            
            // Badges de réassurance
            TrustBadgesView()
                .padding(.top, 2)
            
            // Bouton de commande
            NavigationLink(destination: CheckoutView()) {
                Text("Passer la commande")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Theme.primaryGreen)
                    .cornerRadius(18)
                    .shadow(color: Theme.primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20) // Espace confortable au-dessus de la Tab Bar
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.06), radius: 16, y: -4)
        )
    }
    
    // MARK: - Barre de progression personnalisée
    private func customProgressBar(progress: Double, color: Color) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(height: 7)
                
                Capsule()
                    .fill(color)
                    .frame(width: max(geometry.size.width * CGFloat(progress), 0), height: 7)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: progress)
            }
        }
        .frame(height: 7)
    }
    
    // MARK: - Empty State Premium
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Theme.primaryGreen.opacity(0.12))
                    .frame(width: 110, height: 110)
                
                Image(systemName: "basket.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Theme.primaryGreen)
            }
            
            VStack(spacing: 8) {
                Text("Votre panier est vide")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                
                Text("Découvrez les arrivages frais du marché de Thiaroye et commencez à le remplir !")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Button(action: {
                cartManager.selectedTab = 0
            }) {
                Text("Commencer mes achats")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Theme.primaryGreen)
                    .cornerRadius(18)
                    .shadow(color: Theme.primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 28)
            .padding(.top, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
