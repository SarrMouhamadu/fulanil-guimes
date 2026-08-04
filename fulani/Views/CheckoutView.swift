import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locationManager = LocationManager()
    
    @State private var address: String = ""
    @State private var deliveryDate = Date()
    @State private var paymentMethod = 0
    @State private var isOrderConfirmed = false
    
    let paymentMethods = ["Wave", "Orange Money", "Espèces à la livraison"]
    
    var body: some View {
        Form {
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
        .navigationTitle("Checkout")
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.userAddress) { _, newAddress in
            if !newAddress.isEmpty {
                address = newAddress
            }
        }
        .alert(isPresented: $isOrderConfirmed) {
            Alert(
                title: Text("Commande confirmée ✅"),
                message: Text("Votre commande est en cours de préparation."),
                dismissButton: .default(Text("OK")) {
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
    }
}
