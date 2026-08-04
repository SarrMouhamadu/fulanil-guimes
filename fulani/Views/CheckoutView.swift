import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var orderManager: OrderManager
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locationManager = LocationManager()
    
    @State private var clientName: String = ""
    @State private var clientPhone: String = ""
    @State private var address: String = ""
    @State private var deliveryDate = Date()
    @State private var paymentMethod = 0
    @State private var isOrderConfirmed = false
    @State private var createdOrderNumber: String = ""
    
    let paymentMethods = ["Wave", "Orange Money", "Espèces à la livraison"]
    
    var body: some View {
        Form {
            Section(header: Text("Informations Client")) {
                TextField("Nom complet", text: $clientName)
                TextField("Téléphone", text: $clientPhone)
                    .keyboardType(.phonePad)
            }
            
            Section(header: Text("Livraison")) {
                HStack {
                    TextField("Adresse complète", text: $address)
                    
                    if locationManager.isLocating {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Button(action: {
                            locationManager.requestLocation()
                        }) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Theme.primaryGreen)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                
                DatePicker("Date & Heure", selection: $deliveryDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
            }
            
            Section(header: Text("Paiement")) {
                Picker("Moyen de paiement", selection: $paymentMethod) {
                    ForEach(0..<paymentMethods.count, id: \.self) { index in
                        Text(paymentMethods[index])
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                HStack {
                    Spacer()
                    Image(systemName: "lock.fill")
                        .foregroundColor(Theme.primaryGreen)
                    Text("Paiement 100% sécurisé")
                        .font(.caption)
                        .foregroundColor(Theme.textLight)
                    Spacer()
                }
            }
            
            Section {
                Button(action: {
                    let selectedPayment = paymentMethods[paymentMethod]
                    let newOrder = orderManager.createOrder(
                        clientName: clientName.isEmpty ? (authManager.currentUser?.name ?? "Client E-Food") : clientName,
                        clientPhone: clientPhone.isEmpty ? (authManager.currentUser?.phoneNumber ?? "+221 77 000 00 00") : clientPhone,
                        deliveryAddress: address.isEmpty ? (authManager.currentUser?.address ?? "Dakar") : address,
                        cartItems: cartManager.items,
                        paymentMethod: selectedPayment
                    )
                    createdOrderNumber = newOrder.orderNumber
                    isOrderConfirmed = true
                }) {
                    Text("Confirmer la commande")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .listRowBackground(Theme.primaryGreen)
            }
        }
        .navigationTitle("Checkout E-Food")
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            if let user = authManager.currentUser {
                clientName = user.name
                clientPhone = user.phoneNumber
                if !user.address.isEmpty {
                    address = user.address
                }
            }
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.userAddress) { _, newAddress in
            if !newAddress.isEmpty {
                address = newAddress
            }
        }
        .alert(isPresented: $isOrderConfirmed) {
            Alert(
                title: Text("Commande \(createdOrderNumber) confirmée ✅"),
                message: Text("Votre commande de légumes frais a été prise en compte sans stock et transmise au fournisseur."),
                dismissButton: .default(Text("Voir le suivi")) {
                    cartManager.confirmOrderAndNavigateToTracking()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    NavigationView {
        CheckoutView()
            .environmentObject(CartManager())
            .environmentObject(AuthManager())
            .environmentObject(OrderManager())
    }
}
