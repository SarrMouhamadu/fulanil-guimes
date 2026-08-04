import SwiftUI

struct SmartBasketDetailView: View {
    let basket: SmartBasket
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    @State private var quantity: Int = 1
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Image Banner
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Theme.lightGray)
                        .frame(height: 260)
                        .overlay(
                            Group {
                                if basket.isSystemImage {
                                    Image(systemName: basket.imageName)
                                        .font(.system(size: 90))
                                        .foregroundColor(Theme.primaryGreen)
                                } else {
                                    Image(basket.imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                            }
                        )
                        .clipped()
                    
                    // Badge Panier Recette
                    Text("PANIER RECETTE TRADITIONNELLE")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.primaryGreen)
                        .cornerRadius(12)
                        .padding(16)
                }
                
                VStack(alignment: .leading, spacing: 18) {
                    // Title and Price
                    VStack(alignment: .leading, spacing: 4) {
                        Text(basket.name)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textDark)
                        
                        Text(basket.recipeName)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.primaryGreen)
                    }
                    
                    HStack {
                        Text(basket.price.formattedFCFA)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textDark)
                        
                        Text("•  Pour \(basket.servings) personnes")
                            .font(.subheadline)
                            .foregroundColor(Theme.textLight)
                        
                        Spacer()
                    }
                    
                    Text(basket.description)
                        .font(.body)
                        .foregroundColor(Color(.darkGray))
                        .lineSpacing(4)
                    
                    Divider().padding(.vertical, 4)
                    
                    // Ingredients List
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ingrédients inclus dans ce panier (Marché Thiaroye) :")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textDark)
                        
                        ForEach(basket.ingredients, id: \.self) { ingredient in
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Theme.primaryGreen)
                                    .font(.system(size: 18))
                                
                                Text(ingredient)
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundColor(Theme.textDark)
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Quantity Stepper
                    HStack {
                        Text("Nombre de paniers")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Spacer()
                        Stepper(value: $quantity, in: 1...10) {
                            Text("\(quantity)")
                                .font(.headline)
                                .frame(width: 36, alignment: .center)
                        }
                        .fixedSize()
                    }
                    .padding(.top, 8)
                    
                    // Add to Cart Button
                    Button(action: {
                        cartManager.addBasketToCart(basket: basket, quantity: quantity)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "basket.fill")
                            Text("Ajouter au panier (\((basket.price * quantity).formattedFCFA))")
                        }
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Theme.primaryGreen)
                        .cornerRadius(18)
                        .shadow(color: Theme.primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        SmartBasketDetailView(basket: SmartBasket.mockBaskets[0])
            .environmentObject(CartManager())
    }
}
