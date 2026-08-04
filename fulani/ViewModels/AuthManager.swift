import SwiftUI
import Combine

class AuthManager: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var isLoggedIn: Bool = false
    @Published var selectedRole: UserRole = .client
    
    init() {
        // Utilisateur démo initialisé
        let defaultUser = User(
            name: "Mamadou Diallo",
            phoneNumber: "+221 77 123 45 67",
            address: "Mermoz, Dakar, Sénégal",
            role: .client
        )
        self.currentUser = defaultUser
        self.isLoggedIn = true
    }
    
    func signUp(name: String, phoneNumber: String, address: String, role: UserRole = .client) {
        let newUser = User(name: name, phoneNumber: phoneNumber, address: address, role: role)
        self.currentUser = newUser
        self.selectedRole = role
        self.isLoggedIn = true
    }
    
    func login(phoneNumber: String) {
        if var user = currentUser {
            user.phoneNumber = phoneNumber
            self.currentUser = user
            self.isLoggedIn = true
        } else {
            signUp(name: "Client E-Food", phoneNumber: phoneNumber, address: "Dakar, Sénégal")
        }
    }
    
    func updateAddress(_ newAddress: String) {
        currentUser?.address = newAddress
    }
    
    func switchRole(_ newRole: UserRole) {
        selectedRole = newRole
        currentUser?.role = newRole
    }
    
    func logout() {
        isLoggedIn = false
        currentUser = nil
    }
}
