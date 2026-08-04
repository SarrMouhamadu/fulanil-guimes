import SwiftUI

struct SupplierDashboardView: View {
    @EnvironmentObject var orderManager: OrderManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // En-tête fournisseur
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Marché de Thiaroye 🧺")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textDark)
                                Text("Commandes à préparer sans stock")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(.secondaryLabel))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 4)
                        .padding(.top, 10)
                        
                        if orderManager.orders.isEmpty {
                            Text("Aucune commande en attente de préparation.")
                                .font(.subheadline)
                                .foregroundColor(Color(.secondaryLabel))
                                .padding(.top, 40)
                        } else {
                            ForEach(orderManager.orders) { order in
                                supplierOrderCard(for: order)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Espace Fournisseur")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func supplierOrderCard(for order: Order) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Commande \(order.orderNumber)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                Spacer()
                Text(order.status.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Theme.primaryGreen)
            }
            
            Divider()
            
            Text("Légumes à préparer :")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Theme.textDark)
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(order.items) { item in
                    HStack {
                        Text("• \(item.productName)")
                            .font(.system(size: 14, weight: .medium))
                        Spacer()
                        Text("\(item.quantity) \(item.unit)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.primaryGreen)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            HStack {
                Text("Part Net à recevoir :")
                    .font(.system(size: 13, weight: .semibold))
                Spacer()
                Text(order.supplierPayout.formattedFCFA)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.primaryGreen)
            }
            
            // Actions Fournisseur (US13 - Confirmer disponibilité / US14 - Préparer)
            HStack(spacing: 10) {
                Button(action: {
                    orderManager.updateStatus(orderId: order.id, newStatus: .confirmed)
                }) {
                    Text("1. Valider Stock")
                        .font(.system(size: 13, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.15))
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    orderManager.updateStatus(orderId: order.id, newStatus: .preparing)
                }) {
                    Text("2. Prêt pour Livreur")
                        .font(.system(size: 13, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Theme.primaryGreen)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    SupplierDashboardView()
        .environmentObject(OrderManager())
}
