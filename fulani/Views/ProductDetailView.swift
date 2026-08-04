import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var cartManager: CartManager
    @State private var quantity: Int = 1
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Theme.lightGray)
                        .frame(height: 300)
                        .overlay(
                            Group {
                                if product.isSystemImage {
                                    Image(systemName: product.imageName)
                                        .font(.system(size: 100))
                                        .foregroundColor(Theme.primaryGreen)
                                } else {
                                    Image(product.imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                            }
                        )
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Titre et Prix
                    HStack {
                        Text(product.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(product.pricePerKg) FCFA / kg")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.primaryGreen)
                    }
                    
                    // Description
                    Text("Origine : Marché de Thiaroye")
                        .font(.subheadline)
                        .foregroundColor(Theme.textLight)
                    
                    Text("Des légumes fraîchement récoltés, parfaits pour vos préparations quotidiennes. Riches en nutriments et garantis sans traitements chimiques lourds.")
                        .font(.body)
                        .padding(.top, 4)
                    
                    Divider().padding(.vertical)
                    
                    // Sélecteur de quantité
                    HStack {
                        Text("Quantité (kg)")
                            .font(.headline)
                        Spacer()
                        Stepper(value: $quantity, in: 1...20) {
                            Text("\(quantity)")
                                .font(.headline)
                                .frame(width: 40, alignment: .center)
                        }
                        .fixedSize()
                    }
                    
                    // Bouton Ajout
                    Button(action: {
                        cartManager.addToCart(product: product, quantity: quantity)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "cart.badge.plus")
                            Text("Ajouter au panier (\(product.pricePerKg * quantity) FCFA)")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.primaryGreen)
                        .cornerRadius(12)
                    }
                    .padding(.top, 16)
                    
                    // Produits similaires
                    Text("Produits similaires")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top, 24)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(Product.mockProducts.filter { $0.category == product.category && $0.id != product.id }) { similarProduct in
                                ProductCardView(product: similarProduct)
                                    .frame(width: 150)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ProductDetailView(product: Product.mockProducts[0])
            .environmentObject(CartManager())
    }
}
