import SwiftUI

struct OrderTrackingView: View {
    let statuses = ["Confirmée ✅", "Préparée 🧺", "En livraison 🚴", "Livrée 🏠"]
    @State private var currentStep = 2 // Simulation : "En livraison"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header Status
                    VStack(spacing: 8) {
                        Text("Temps estimé restant")
                            .font(.subheadline)
                            .foregroundColor(Theme.textLight)
                        Text("15 mins")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(Theme.primaryGreen)
                    }
                    .padding(.top, 20)
                    
                    // Ligne de progression
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<statuses.count, id: \.self) { index in
                            HStack(alignment: .top) {
                                // Colonne du trait et de la puce
                                VStack {
                                    Circle()
                                        .fill(index <= currentStep ? Theme.primaryGreen : Theme.lightGray)
                                        .frame(width: 20, height: 20)
                                    
                                    if index < statuses.count - 1 {
                                        Rectangle()
                                            .fill(index < currentStep ? Theme.primaryGreen : Theme.lightGray)
                                            .frame(width: 4, height: 50)
                                    }
                                }
                                
                                // Texte du statut
                                Text(statuses[index])
                                    .font(.headline)
                                    .foregroundColor(index <= currentStep ? Theme.textDark : Theme.textLight)
                                    .padding(.leading, 10)
                                    .padding(.top, -2)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(Theme.lightGray.opacity(0.5))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Info livreur
                    if currentStep >= 2 {
                        HStack(spacing: 16) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(Theme.primaryGreen)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Votre livreur")
                                    .font(.caption)
                                    .foregroundColor(Theme.textLight)
                                Text("Amadou Fall")
                                    .font(.headline)
                            }
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "phone.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Theme.primaryGreen)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Suivi")
        }
    }
}

#Preview {
    OrderTrackingView()
}
