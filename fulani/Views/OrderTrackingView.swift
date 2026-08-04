import SwiftUI

struct OrderTrackingView: View {
    @EnvironmentObject var orderManager: OrderManager
    
    let statuses = ["Confirmée ✅", "Préparée 🧺", "En livraison 🚴", "Livrée 🏠"]
    
    var currentStep: Int {
        guard let order = orderManager.latestCreatedOrder else { return 2 }
        switch order.status {
        case .new, .confirmed: return 0
        case .preparing: return 1
        case .delivering: return 2
        case .delivered: return 3
        case .cancelled: return 0
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if let order = orderManager.latestCreatedOrder {
                        // Header Status
                        VStack(spacing: 8) {
                            Text("Commande \(order.orderNumber)")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.primaryGreen)
                            
                            Text("Temps estimé restant")
                                .font(.subheadline)
                                .foregroundColor(Theme.textLight)
                            
                            Text(currentStep == 3 ? "Livrée ! 🎉" : "15 mins")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Theme.primaryGreen)
                        }
                        .padding(.top, 16)
                        
                        // Timeline 4 étapes
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(0..<statuses.count, id: \.self) { index in
                                HStack(alignment: .top) {
                                    VStack {
                                        Circle()
                                            .fill(index <= currentStep ? Theme.primaryGreen : Theme.lightGray)
                                            .frame(width: 20, height: 20)
                                        
                                        if index < statuses.count - 1 {
                                            Rectangle()
                                                .fill(index < currentStep ? Theme.primaryGreen : Theme.lightGray)
                                                .frame(width: 4, height: 44)
                                        }
                                    }
                                    
                                    Text(statuses[index])
                                        .font(.headline)
                                        .foregroundColor(index <= currentStep ? Theme.textDark : Theme.textLight)
                                        .padding(.leading, 10)
                                        .padding(.top, -2)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding(16)
                        .background(Theme.lightGray.opacity(0.5))
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        
                        // Info livreur
                        if currentStep >= 2 {
                            HStack(spacing: 16) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(Theme.primaryGreen)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Votre livreur E-Food")
                                        .font(.caption)
                                        .foregroundColor(Theme.textLight)
                                    Text(order.assignedDriverName ?? "Amadou Fall")
                                        .font(.headline)
                                }
                                Spacer()
                                
                                Button(action: {}) {
                                    Image(systemName: "phone.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(Theme.primaryGreen)
                                }
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
                            .padding(.horizontal, 20)
                        }
                    } else {
                        VStack(spacing: 16) {
                            Spacer().frame(height: 60)
                            Image(systemName: "box.truck.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Theme.primaryGreen.opacity(0.4))
                            Text("Aucune commande en cours")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textDark)
                            Text("Passez une commande pour suivre son acheminement en temps réel.")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.secondaryLabel))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    }
                }
                .padding(.bottom, 24)
            }
            .navigationTitle("Suivi de Commande")
        }
    }
}

#Preview {
    OrderTrackingView()
        .environmentObject(OrderManager())
}
