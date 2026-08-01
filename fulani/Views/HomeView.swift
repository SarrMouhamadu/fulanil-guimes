import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Grille Produits Vedettes
                    Text("Nos arrivages du jour")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 24)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        // On met en avant uniquement les légumes qui ont une vraie photo
                        ForEach(Product.mockProducts.filter { !$0.isSystemImage }) { product in
                            ProductCardView(product: product)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .padding(.bottom, 20)
            }
            .safeAreaInset(edge: .top) {
                // En-tête Dynamique (Sticky Header) avec Glassmorphism
                HStack {
                    Button(action: {
                        print("Drawer menu cliqué - Ouverture du menu latéral...")
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title3)
                            .foregroundColor(Theme.primaryGreen)
                            .padding(4)
                    }
                    
                    Spacer()
                    Text("Fulani Légumes")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    
                    // Espaceur invisible pour garder le titre parfaitement centré
                    Image(systemName: "line.3.horizontal")
                        .font(.title3)
                        .opacity(0)
                        .padding(4)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
            }
            .navigationBarHidden(true)
        }
    }
}


// Sous-composant pour les cartes produits
struct ProductCardView: View {
    let product: Product
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Theme.lightGray)
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Group {
                        if product.isSystemImage {
                            Image(systemName: product.imageName)
                                .font(.largeTitle)
                                .foregroundColor(Theme.primaryGreen)
                        } else {
                            Image(product.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                )
                .cornerRadius(12)
            
            Text(product.name)
                .font(.headline)
                .foregroundColor(Theme.textDark)
            
            Text("\(product.pricePerKg) FCFA / kg")
                .font(.subheadline)
                .foregroundColor(Theme.textLight)
            
            Button(action: {
                cartManager.addToCart(product: product)
            }) {
                Text("Ajouter")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryGreen)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Theme.primaryGreen.opacity(0.15))
                    .cornerRadius(8)
            }
            .padding(.top, 4)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
        .environmentObject(CartManager())
}
