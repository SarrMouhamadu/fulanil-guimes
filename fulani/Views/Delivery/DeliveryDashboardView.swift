import SwiftUI

struct DeliveryDashboardView: View {
    @EnvironmentObject var orderManager: OrderManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Feuille de Route Livreur 🚴")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textDark)
                                Text("Livraisons E-Food à effectuer")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(.secondaryLabel))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 4)
                        .padding(.top, 10)
                        
                        let activeDeliveries = orderManager.orders.filter { $0.status == .delivering || $0.status == .preparing || $0.status == .delivered }
                        
                        if activeDeliveries.isEmpty {
                            Text("Aucune livraison en cours pour le moment.")
                                .font(.subheadline)
                                .foregroundColor(Color(.secondaryLabel))
                                .padding(.top, 40)
                        } else {
                            ForEach(activeDeliveries) { order in
                                deliveryCard(for: order)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Espace Livreur")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func deliveryCard(for order: Order) -> some View {
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
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(Theme.primaryGreen)
                    Text("Client : \(order.clientName) (\(order.clientPhone))")
                        .font(.system(size: 14, weight: .semibold))
                }
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.red)
                    Text("Adresse : \(order.deliveryAddress)")
                        .font(.system(size: 13))
                        .foregroundColor(Color(.secondaryLabel))
                }
                
                HStack {
                    Image(systemName: "banknote.fill")
                        .foregroundColor(.orange)
                    Text("À encaisser (\(order.paymentMethod)) : \(order.grandTotal.formattedFCFA)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.textDark)
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            if order.status != .delivered {
                Button(action: {
                    orderManager.updateStatus(orderId: order.id, newStatus: .delivered)
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Confirmer la Livraison Réussie")
                    }
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Theme.primaryGreen)
                    .cornerRadius(14)
                }
            } else {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(Theme.primaryGreen)
                    Text("Commande Livrée avec succès 🎉")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Theme.primaryGreen)
                    Spacer()
                }
                .padding(.vertical, 6)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    DeliveryDashboardView()
        .environmentObject(OrderManager())
}
