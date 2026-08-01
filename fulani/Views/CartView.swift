import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fond de l'application aligné exactement sur l'Accueil
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    if cartManager.items.isEmpty {
                        emptyStateView
                    } else {
                        VStack(spacing: 0) {
                            // Liste de produits avec marges identiques à la page Accueil (20 pt)
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 16) {
                                    ForEach(cartManager.items) { item in
                                        cartItemCard(for: item)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                .padding(.bottom, 24)
                            }
                            
                            // Section inférieure : Sous-total, Jauge, Badges et Bouton de commande
                            bottomCheckoutSection
                        }
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                // En-tête avec Glassmorphism (.ultraThinMaterial), identique à l'Accueil et au Catalogue
                headerView
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header (Aligné sur HomeView.swift & CatalogueView.swift)
    private var headerView: some View {
        HStack {
            Button(action: {
                if presentationMode.wrappedValue.isPresented {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    cartManager.selectedTab = 0
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.primaryGreen)
                    .frame(width: 36, height: 36)
                    .background(Theme.primaryGreen.opacity(0.12))
                    .clipShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Text("Panier")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textDark)
            
            Spacer()
            
            // Espaceur équilibré pour garder le titre parfaitement centré
            Color.clear
                .frame(width: 36, height: 36)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
    
    // MARK: - Carte Produit Responsive
    private func cartItemCard(for item: CartItem) -> some View {
        HStack(alignment: .center, spacing: 12) {
            // Miniature produit calibrée (70x70 pt) et strictement découpée contre le débordement
            Group {
                if item.product.isSystemImage {
                    Image(systemName: item.product.imageName)
                        .font(.system(size: 30))
                        .foregroundColor(Theme.primaryGreen)
                        .frame(width: 70, height: 70)
                } else {
                    Image(item.product.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                }
            }
            .frame(width: 70, height: 70)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            
            // Détails : Nom, Prix et Contrôleur de quantité
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.product.name)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textDark)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                    
                    Text(item.product.pricePerKg.formattedFCFA + " / kg")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(.secondaryLabel))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                
                // Contrôleur de quantité optimisé pour éviter tout débordement sur petit écran
                HStack(spacing: 10) {
                    Button(action: { cartManager.updateQuantity(for: item, newQuantity: item.quantity - 1) }) {
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.primaryGreen)
                            .frame(width: 26, height: 26)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("\(item.quantity) kg")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textDark)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(minWidth: 32, alignment: .center)
                    
                    Button(action: { cartManager.updateQuantity(for: item, newQuantity: item.quantity + 1) }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.primaryGreen)
                            .frame(width: 26, height: 26)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(4)
                .background(Color(.systemGray6))
                .cornerRadius(18)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Icône de suppression confortable et accessible
            Button(action: {
                cartManager.removeFromCart(item: item)
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color.red.opacity(0.8))
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(14) // Grille d'espacement HIG de 14pt (identique aux cartes de la page Accueil)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
    }
    
    // MARK: - Section Inférieure de Commande
    private var bottomCheckoutSection: some View {
        VStack(spacing: 16) {
            // Sous-total aligné sur les marges de 20 pt de l'Accueil et garanti anti-coupure
            HStack(alignment: .center) {
                Text("Sous-total")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(.secondaryLabel))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Spacer()
                
                Text(cartManager.subtotal.formattedFCFA)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            
            // Jauge de livraison offerte
            VStack(alignment: .leading, spacing: 6) {
                if cartManager.isDeliveryFree {
                    Text("🎉 Livraison offerte sur cette commande !")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.primaryGreen)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                    
                    customProgressBar(progress: 1.0, color: Theme.primaryGreen)
                } else {
                    Text("Plus que \((10000 - cartManager.subtotal).formattedFCFA) pour la livraison offerte !")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color.orange)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                    
                    customProgressBar(progress: min(Double(cartManager.subtotal) / 10000.0, 1.0), color: Color.orange)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Badges de réassurance
            TrustBadgesView()
                .padding(.top, 2)
            
            // Bouton de commande Premium
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
        .padding(.horizontal, 20) // Marges latérales de 20 pt exactes
        .padding(.top, 20)
        .padding(.bottom, 20)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.05), radius: 12, y: -3)
        )
    }
    
    // MARK: - Barre de progression personnalisée
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
}

#Preview {
    CartView().environmentObject(CartManager())
}
