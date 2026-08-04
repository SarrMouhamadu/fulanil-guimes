import SwiftUI
import Combine

class CatalogueViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "Tous"
    @Published var isLoading: Bool = true
    
    init() {
        // Simulation d'un appel réseau (1.5 secondes)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
        }
    }
    
    let categories = ["Tous", "Racines", "Feuilles", "Tubercules", "Légumes-fruits", "Céréales & Légumineuses"]
    
    var filteredProducts: [Product] {
        var result = Product.mockProducts
        
        if selectedCategory != "Tous" {
            result = result.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        return result
    }
}
