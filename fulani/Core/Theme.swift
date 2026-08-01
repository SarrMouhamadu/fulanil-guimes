import SwiftUI

enum Theme {
    static let primaryGreen = Color(red: 0.2, green: 0.7, blue: 0.3) // Vert fraîcheur
    static let backgroundWhite = Color.white
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.96)
    static let textDark = Color.primary
    static let textLight = Color.secondary
    
    // Grille Responsive universelle pour les catalogues (s'adapte automatiquement de l'iPhone au iPad)
    static let adaptiveGridColumns = [
        GridItem(.adaptive(minimum: 145, maximum: 260), spacing: 16)
    ]
}

// Extension universelle pour le format monétaire français (ex: 1 550 FCFA)
extension Int {
    var formattedFCFA: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let formattedNumber = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(formattedNumber) FCFA"
    }
}
