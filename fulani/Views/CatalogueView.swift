import SwiftUI

struct CatalogueView: View {
    @StateObject private var viewModel = CatalogueViewModel()
    @EnvironmentObject var cartManager: CartManager
    @State private var showChatbot = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Barre de recherche
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Theme.textLight)
                    TextField("Rechercher un légume...", text: $viewModel.searchText)
                    
                    Button(action: {
                        showChatbot = true
                    }) {
                        Image(systemName: "mic.fill")
                            .foregroundColor(Theme.primaryGreen)
                    }
                }
                .padding()
                .background(Theme.lightGray)
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Filtres
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(action: {
                                viewModel.selectedCategory = category
                            }) {
                                Text(category)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(viewModel.selectedCategory == category ? Theme.primaryGreen : Theme.lightGray)
                                    .foregroundColor(viewModel.selectedCategory == category ? .white : Theme.textDark)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Grille de produits
                ScrollView {
                    if viewModel.isLoading {
                        VStack(spacing: 16) {
                            Spacer().frame(height: 50)
                            ProgressView()
                                .scaleEffect(1.5)
                                .progressViewStyle(CircularProgressViewStyle(tint: Theme.primaryGreen))
                            Text("Chargement des légumes...")
                                .foregroundColor(Theme.textLight)
                                .padding(.top, 8)
                        }
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(viewModel.filteredProducts) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductCardView(product: product)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Catalogue")
            .sheet(isPresented: $showChatbot) {
                ChatbotView()
            }
        }
    }
}

#Preview {
    CatalogueView().environmentObject(CartManager())
}
