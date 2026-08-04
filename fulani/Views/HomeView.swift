import SwiftUI

struct HomeView: View {
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Bannière Hero E-Food
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("E-FOOD SÉNÉGAL 🇸🇳")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Theme.primaryGreen)
                                    .cornerRadius(10)
                                Spacer()
                            }
                            
                            Text("Marché de Thiaroye & Approvisionnement en 1 clic")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textDark)
                            
                            Text("Commandez vos légumes au kilo ou vos paniers repas complets pour le ménage, les événements et les restaurants.")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(.secondaryLabel))
                                .lineSpacing(3)
                        }
                        .padding(18)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // SECTION 1 : Paniers Intelligents (Recettes Traditionnelles)
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Paniers Intelligents 🧺")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textDark)
                                Spacer()
                                NavigationLink(destination: CatalogueView()) {
                                    Text("Voir tout")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(Theme.primaryGreen)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(SmartBasket.mockBaskets) { basket in
                                        NavigationLink(destination: SmartBasketDetailView(basket: basket)) {
                                            SmartBasketCardView(basket: basket)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 4)
                            }
                        }
                        
                        // SECTION 2 : Événements & Espace Pro B2B
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Services Spécialisés 🌟")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textDark)
                                .padding(.horizontal, 20)
                            
                            HStack(spacing: 12) {
                                NavigationLink(destination: EventCalculatorView()) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 24))
                                            .foregroundColor(Theme.primaryGreen)
                                        Text("Calculateur Événements")
                                            .font(.system(size: 15, weight: .bold, design: .rounded))
                                            .foregroundColor(Theme.textDark)
                                        Text("Magal, Gamou, Mariages")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(.secondaryLabel))
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(18)
                                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: ProSpaceView()) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Image(systemName: "building.2.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(Theme.primaryGreen)
                                        Text("Espace Pro & Cantines")
                                            .font(.system(size: 15, weight: .bold, design: .rounded))
                                            .foregroundColor(Theme.textDark)
                                        Text("Restaurants & Vendeurs")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(.secondaryLabel))
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(18)
                                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // SECTION 3 : Arrivages du Jour (Légumes au kilo)
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Arrivages du jour (Marché Thiaroye)")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textDark)
                                .padding(.horizontal, 20)
                            
                            LazyVGrid(columns: Theme.adaptiveGridColumns, spacing: 16) {
                                ForEach(Product.mockProducts.filter { !$0.isSystemImage }) { product in
                                    ProductCardView(product: product)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .safeAreaInset(edge: .top) {
                // Header Sticky Glassmorphism
                HStack {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Theme.primaryGreen)
                    
                    Spacer()
                    
                    Text("E-Food Sénégal")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textDark)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 24, height: 24)
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

// Carte pour les Paniers Intelligents (Horizontal Scroll)
struct SmartBasketCardView: View {
    let basket: SmartBasket
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .frame(width: 170, height: 110)
                    .overlay(
                        Image(systemName: basket.imageName)
                            .font(.system(size: 40))
                            .foregroundColor(Theme.primaryGreen)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                
                Text("\(basket.price.formattedFCFA)")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.primaryGreen)
                    .cornerRadius(10)
                    .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(basket.name)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                    .lineLimit(1)
                
                Text(basket.recipeName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(.secondaryLabel))
                    .lineLimit(1)
            }
            
            Button(action: {
                cartManager.addBasketToCart(basket: basket)
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .bold))
                    Text("Ajouter Panier")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                }
                .foregroundColor(Theme.primaryGreen)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Theme.primaryGreen.opacity(0.14))
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(12)
        .frame(width: 194)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

// Carte Produit pour les Légumes au kilo
struct ProductCardView: View {
    let product: Product
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
                
                Text(product.pricePerKg.formattedFCFA + " / kg")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(.secondaryLabel))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            
            Spacer(minLength: 0)
            
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
        .padding(14)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    HomeView()
        .environmentObject(CartManager())
}
