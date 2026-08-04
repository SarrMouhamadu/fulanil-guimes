import SwiftUI

struct EventCalculatorView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedEventType = "Magal / Gamou"
    @State private var guestCount: Int = 50
    @State private var selectedMeal = "Thiéboudienne Festif"
    @State private var isOrdered = false
    
    let eventTypes = ["Magal / Gamou", "Baptême", "Mariage", "Journée Communautaire", "Événement Pro"]
    let mealTypes = [
        "Thiéboudienne Festif": 1200, // FCFA par personne (ingrédients)
        "Yassa au Poulet/Poisson": 1100,
        "Mafé Réception": 1000,
        "Soupou Kandia Royal": 1400
    ]
    
    var costPerPerson: Int {
        mealTypes[selectedMeal] ?? 1200
    }
    
    var totalPrice: Int {
        guestCount * costPerPerson
    }
    
    var calculatedIngredients: [String] {
        let riceKg = max(1, guestCount / 5) // ~200g par personne
        let onionKg = max(1, guestCount / 8)
        let tomatoKg = max(1, guestCount / 10)
        let oilLiters = max(1, guestCount / 15)
        
        return [
            "\(riceKg) kg de Riz brisé de qualité supérieure",
            "\(onionKg) kg d'Oignons frais du marché",
            "\(tomatoKg) kg de Tomates & Légumes assortis",
            "\(oilLiters) L d'Huile de cuisine",
            "Condiments & Piments pour \(guestCount) convives"
        ]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Banner Hero Événements E-Food
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 20))
                                Text("SERVICE ÉVÉNEMENTIEL E-FOOD")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(Theme.primaryGreen)
                            
                            Text("Calculateur d'Approvisionnement")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textDark)
                            
                            Text("Mariages, Baptêmes, Magal, Gamou... Commandez exactement ce qu'il vous faut en gros directement auprès du marché de Thiaroye.")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.secondaryLabel))
                                .lineSpacing(3)
                        }
                        .padding(18)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // 1. Choix du type d'événement
                        VStack(alignment: .leading, spacing: 12) {
                            Text("1. Type d'événement")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textDark)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(eventTypes, id: \.self) { type in
                                        Button(action: {
                                            selectedEventType = type
                                        }) {
                                            Text(type)
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 10)
                                                .background(selectedEventType == type ? Theme.primaryGreen : Color(.systemGray6))
                                                .foregroundColor(selectedEventType == type ? .white : Theme.textDark)
                                                .cornerRadius(16)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        .padding(18)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                        .padding(.horizontal, 20)
                        
                        // 2. Nombre de convives & Menu
                        VStack(alignment: .leading, spacing: 16) {
                            Text("2. Convives et Repas")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textDark)
                            
                            // Stepper convives
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Nombre d'invités")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    Text("\(guestCount) personnes")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(Theme.primaryGreen)
                                }
                                Spacer()
                                Stepper(value: $guestCount, in: 20...1000, step: 10) {
                                    EmptyView()
                                }
                                .labelsHidden()
                            }
                            
                            Divider()
                            
                            // Menu sélectionné
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Menu principal")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.textLight)
                                
                                Menu {
                                    ForEach(Array(mealTypes.keys), id: \.self) { meal in
                                        Button(meal) {
                                            selectedMeal = meal
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedMeal)
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundColor(Theme.textDark)
                                        Spacer()
                                        Image(systemName: "chevron.up.chevron.down")
                                            .foregroundColor(Theme.primaryGreen)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(14)
                                }
                            }
                        }
                        .padding(18)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                        .padding(.horizontal, 20)
                        
                        // 3. Calculateur d'ingrédients & Budget
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Estimation des ingrédients requises")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textDark)
                                Spacer()
                            }
                            
                            ForEach(calculatedIngredients, id: \.self) { ing in
                                HStack(spacing: 10) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(Theme.primaryGreen)
                                        .font(.system(size: 16))
                                    Text(ing)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(Theme.textDark)
                                    Spacer()
                                }
                            }
                            
                            Divider().padding(.vertical, 4)
                            
                            HStack {
                                Text("Budget Estimé :")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textDark)
                                Spacer()
                                Text(totalPrice.formattedFCFA)
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.primaryGreen)
                            }
                            
                            // Bouton d'ajout de la commande événementielle
                            Button(action: {
                                let calculation = EventCalculation(
                                    eventType: selectedEventType,
                                    guestCount: guestCount,
                                    mealType: selectedMeal,
                                    totalPrice: totalPrice,
                                    ingredientsBreakdown: calculatedIngredients
                                )
                                cartManager.addEventCalculationToCart(event: calculation)
                                cartManager.selectedTab = 3 // Redirection panier
                            }) {
                                HStack {
                                    Image(systemName: "cart.badge.plus")
                                    Text("Commander le pack (\(totalPrice.formattedFCFA))")
                                }
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Theme.primaryGreen)
                                .cornerRadius(16)
                                .shadow(color: Theme.primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .padding(.top, 8)
                        }
                        .padding(18)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                HStack {
                    Spacer()
                    Text("Événements E-Food")
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
        }
    }
}

#Preview {
    EventCalculatorView()
        .environmentObject(CartManager())
}
