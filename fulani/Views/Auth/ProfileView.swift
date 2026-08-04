import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State private var nameInput: String = ""
    @State private var phoneInput: String = ""
    @State private var addressInput: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Carte de profil utilisateur
                        userHeaderCard
                        
                        // Sélecteur de rôle (Client, Admin, Fournisseur, Livreur)
                        roleSwitchCard
                        
                        // Formulaire de modification du profil (US01-US02)
                        editProfileCard
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Mon Compte E-Food")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let user = authManager.currentUser {
                    nameInput = user.name
                    phoneInput = user.phoneNumber
                    addressInput = user.address
                }
            }
        }
    }
    
    // MARK: - En-tête Profil
    private var userHeaderCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Theme.primaryGreen.opacity(0.15))
                    .frame(width: 60, height: 60)
                
                Image(systemName: authManager.selectedRole.iconName)
                    .font(.system(size: 28))
                    .foregroundColor(Theme.primaryGreen)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(authManager.currentUser?.name ?? "Client E-Food")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                
                Text(authManager.currentUser?.phoneNumber ?? "Non renseigné")
                    .font(.system(size: 13))
                    .foregroundColor(Color(.secondaryLabel))
                
                Text("Rôle actif : \(authManager.selectedRole.rawValue)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Theme.primaryGreen)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
    
    // MARK: - Sélecteur de Rôles
    private var roleSwitchCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Changer d'espace (Test Multi-Rôles)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textDark)
            
            VStack(spacing: 8) {
                ForEach(UserRole.allCases) { role in
                    Button(action: {
                        authManager.switchRole(role)
                    }) {
                        HStack {
                            Image(systemName: role.iconName)
                                .foregroundColor(authManager.selectedRole == role ? Theme.primaryGreen : Color(.secondaryLabel))
                                .frame(width: 24)
                            
                            Text(role.rawValue)
                                .font(.system(size: 14, weight: authManager.selectedRole == role ? .bold : .medium))
                                .foregroundColor(authManager.selectedRole == role ? Theme.primaryGreen : Theme.textDark)
                            
                            Spacer()
                            
                            if authManager.selectedRole == role {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Theme.primaryGreen)
                            }
                        }
                        .padding(12)
                        .background(authManager.selectedRole == role ? Theme.primaryGreen.opacity(0.12) : Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
    
    // MARK: - Formulaire Profil
    private var editProfileCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Mes Informations Personnelles")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textDark)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Nom complet")
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
                TextField("Ex: Fatou Sow", text: $nameInput)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Numéro de téléphone")
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
                TextField("Ex: +221 77 000 00 00", text: $phoneInput)
                    .keyboardType(.phonePad)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Adresse de livraison")
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
                TextField("Ex: Sacré-Cœur 3, Dakar", text: $addressInput)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            Button(action: {
                authManager.signUp(name: nameInput, phoneNumber: phoneInput, address: addressInput, role: authManager.selectedRole)
            }) {
                Text("Enregistrer les modifications")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Theme.primaryGreen)
                    .cornerRadius(14)
            }
            .padding(.top, 6)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager())
}
