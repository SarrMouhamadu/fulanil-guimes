import SwiftUI

struct CatalogueView: View {
    @StateObject private var viewModel = CatalogueViewModel()
    @EnvironmentObject var cartManager: CartManager
    @State private var showChatbot = false
    
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
                            
                            TextField("Rechercher un légume...", text: $viewModel.searchText)
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
                        
                        // Grille de produits responsive adaptative
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
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                // En-tête Sticky Safe Area avec Glassmorphism
                HStack {
                    Spacer()
                    Text("Catalogue")
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
                    
#Preview {
    CatalogueView().environmentObject(CartManager())
}
