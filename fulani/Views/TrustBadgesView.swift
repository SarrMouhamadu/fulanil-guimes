import SwiftUI

struct TrustBadgesView: View {
    var body: some View {
        HStack(spacing: 8) {
            PilierView(icon: "leaf.fill", title: "Frais & Local")
            PilierView(icon: "bolt.fill", title: "Rapide")
            PilierView(icon: "lock.fill", title: "Sécurisé")
        }
        .frame(maxWidth: .infinity) // Respecte scrupuleusement la largeur du parent (w-full)
    }
}

// Sous-composant pour les piliers
struct PilierView: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Theme.primaryGreen)
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundColor(Color(.darkGray))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    TrustBadgesView()
}
