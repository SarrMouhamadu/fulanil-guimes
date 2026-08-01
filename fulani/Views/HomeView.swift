import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Grille Produits Vedettes
                        Text("Nos arrivages du jour")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textDark)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        // Grille responsive adaptative (du petit iPhone au iPad)
                        LazyVGrid(columns: Theme.adaptiveGridColumns, spacing: 16) {
                            // On met en avant uniquement les légumes qui ont une vraie photo
                            ForEach(Product.mockProducts.filter { !$0.isSystemImage }) { product in
                                ProductCardView(product: product)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 24)
                }
            }
            .safeAreaInset(edge: .top) {
                // En-tête Dynamique (Sticky Header) avec Glassmorphism
                HStack {
                    Button(action: {
                        print("Drawer menu cliqué - Ouverture du menu latéral...")
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Theme.primaryGreen)
                            .frame(width: 40, height: 40)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Text("Fulani Légumes")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textDark)
                    
                    Spacer()
                    
                    // Espaceur invisible pour garder le titre parfaitement centré
                    Color.clear
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
            }
            .navigationBarHidden(true)
        }
    }
}


// Sous-composant responsive pour les cartes produits
struct ProductCardView: View {
    let product: Product
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Conteneur d'image carré à ratio fluide
            Rectangle()
                .fill(Color(.systemGray6))
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Group {
                        if product.isSystemImage {
                            Image(systemName: product.imageName)
                                .font(.system(size: 44))
                                .foregroundColor(Theme.primaryGreen)
                        } else {
                            Image(product.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Textes protégés contre la troncature (lineLimit & minimumScaleFactor)
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78) // Garantit que les noms longs rentrent sur iPhone SE
                
                Text(product.pricePerKg.formattedFCFA + " / kg")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(.secondaryLabel))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            
            Spacer(minLength: 0)
            
            // Bouton d'ajout au panier tactile et harmonisé
            Button(action: {
                cartManager.addToCart(product: product)
            }) {
                HStack(alignment: .center, spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .bold))
                    Text("Ajouter")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
                .foregroundColor(Theme.primaryGreen)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Theme.primaryGreen.opacity(0.14))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(14) // Grille d'espacement HIG
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    HomeView()
        .environmentObject(CartManager())
}
