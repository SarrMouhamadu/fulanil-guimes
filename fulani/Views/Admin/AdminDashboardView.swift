import SwiftUI

struct AdminDashboardView: View {
    @EnvironmentObject var orderManager: OrderManager
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Cartes de statistiques financières E-Food
                        financialSummaryCards
                        
                        // Liste des commandes avec gestion des statuts
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Toutes les Commandes (\(orderManager.orders.count))")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textDark)
                                .padding(.horizontal, 4)
                            
                            ForEach(orderManager.orders) { order in
                                adminOrderCard(for: order)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Dashboard Admin E-Food")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Résumé Financier & Commissions E-Food
    private var financialSummaryCards: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                statCard(
                    title: "Chiffre d'Affaires",
                    value: orderManager.totalGrossRevenue.formattedFCFA,
                    iconName: "chart.line.uptrend.xyaxis",
                    color: Theme.primaryGreen
                )
                
                statCard(
                    title: "Commission E-Food (15%)",
                    value: orderManager.totalEFoodCommission.formattedFCFA,
                    iconName: "dollarsign.circle.fill",
                    color: Color.purple
                )
            }
            
            statCard(
                title: "Règlements Dus aux Fournisseurs (Thiaroye)",
                value: orderManager.totalSupplierPayouts.formattedFCFA,
                iconName: "bag.fill",
                color: Color.blue
            )
        }
    }
    
    private func statCard(title: String, value: String, iconName: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textDark)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color(.secondaryLabel))
                .lineLimit(1)
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
    
    // MARK: - Carte de Gestion d'une Commande
    private func adminOrderCard(for order: Order) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(order.orderNumber)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.primaryGreen)
                
                Spacer()
                
                Text(order.status.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Theme.primaryGreen.opacity(0.15))
                    .foregroundColor(Theme.primaryGreen)
                    .cornerRadius(12)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Client : \(order.clientName) (\(order.clientPhone))")
                    .font(.system(size: 13, weight: .medium))
                Text("Adresse : \(order.deliveryAddress)")
                    .font(.system(size: 12))
                    .foregroundColor(Color(.secondaryLabel))
                Text("Paiement : \(order.paymentMethod) • Total : \(order.grandTotal.formattedFCFA)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.textDark)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Commission E-Food : \(order.commissionAmount.formattedFCFA)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.purple)
                Text("Part Fournisseur : \(order.supplierPayout.formattedFCFA)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.blue)
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            // Actions de statut Admin
            HStack(spacing: 8) {
                Menu {
                    ForEach(OrderStatus.allCases) { status in
                        Button(status.rawValue) {
                            orderManager.updateStatus(orderId: order.id, newStatus: status)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                        Text("Changer Statut")
                    }
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray5))
                    .foregroundColor(Theme.textDark)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    orderManager.assignDriver(orderId: order.id, driverName: "Amadou Fall")
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("Affecter Livreur")
                    }
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Theme.primaryGreen)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    AdminDashboardView()
        .environmentObject(OrderManager())
        .environmentObject(AuthManager())
}
