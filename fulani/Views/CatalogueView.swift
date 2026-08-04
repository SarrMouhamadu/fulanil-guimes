import SwiftUI

struct CatalogueView: View {
    @StateObject private var viewModel = CatalogueViewModel()
    @EnvironmentObject var cartManager: CartManager
    @State private var showChatbot = false
    @State private var selectedCatalogMode = 0 // 0 = Légumes, 1 = Paniers Intelligents
    
    var filteredBaskets: [SmartBasket] {
        if viewModel.searchText.isEmpty {
            return SmartBasket.mockBaskets
        } else {
            return SmartBasket.mockBaskets.filter {
                $0.name.lowercased().contains(viewModel.searchText.lowercased()) ||
                $0.recipeName.lowercased().contains(viewModel.searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Barre de recherche
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(.secondaryLabel))
                            
                            TextField("Rechercher un produit ou un panier...", text: $viewModel.searchText)
                                .font(.system(size: 16, design: .rounded))
                            
                            Button(action: {
                                showChatbot = true
                            }) {
                                Image(systemName: "mic.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Theme.primaryGreen)
                                    .padding(6)
                                    .background(Theme.primaryGreen.opacity(0.12))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // Sélecteur Mode Catalogue
                        Picker("Mode Catalogue", selection: $selectedCatalogMode) {
                            Text("Légumes au Kilo").tag(0)
                            Text("Paniers Intelligents").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 20)
                        
                        if selectedCatalogMode == 0 {
                            // Filtres par catégories
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(viewModel.categories, id: \.self) { category in
                                        Button(action: {
                                            viewModel.selectedCategory = category
                                        }) {
                                            Text(category)
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(viewModel.selectedCategory == category ? Theme.primaryGreen : Color.white)
                                                .foregroundColor(viewModel.selectedCategory == category ? .white : Theme.textDark)
                                                .cornerRadius(20)
                                                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 4)
                            }
                            
                            // Grille de produits légumes
                            if viewModel.isLoading {
                                VStack(spacing: 16) {
                                    Spacer().frame(height: 60)
                                    ProgressView()
                                        .scaleEffect(1.3)
                                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.primaryGreen))
                                    Text("Chargement des légumes...")
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                        .foregroundColor(Color(.secondaryLabel))
                                }
                            } else {
                                LazyVGrid(columns: Theme.adaptiveGridColumns, spacing: 16) {
                                    ForEach(viewModel.filteredProducts) { product in
                                        NavigationLink(destination: ProductDetailView(product: product)) {
                                            ProductCardView(product: product)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 4)
                                .padding(.bottom, 24)
                            }
                        } else {
                            // Liste des Paniers Intelligents
                            VStack(spacing: 16) {
                                ForEach(filteredBaskets) { basket in
                                    NavigationLink(destination: SmartBasketDetailView(basket: basket)) {
                                        SmartBasketRowView(basket: basket)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 4)
                            .padding(.bottom, 24)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                HStack {
                    Spacer()
                    Text("Catalogue E-Food")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textDark)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showChatbot) {
                ChatbotView()
            }
        }
    }
}

// Rangée pour les Paniers Intelligents dans le catalogue
struct SmartBasketRowView: View {
    let basket: SmartBasket
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: basket.imageName)
                            .font(.system(size: 34))
                            .foregroundColor(Theme.primaryGreen)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(basket.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                
                Text(basket.recipeName)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.primaryGreen)
                
                Text("\(basket.ingredients.count) ingrédients inclus • \(basket.servings) pers.")
                    .font(.system(size: 12))
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text(basket.price.formattedFCFA)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                
                Button(action: {
                    cartManager.addBasketToCart(basket: basket)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Theme.primaryGreen)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    CatalogueView().environmentObject(CartManager())
}
