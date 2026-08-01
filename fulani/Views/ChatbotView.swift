import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isBot: Bool
}

struct ChatbotView: View {
    @State private var messages = [
        ChatMessage(text: "Salam, souma nga. Naka la la mën a dimbali tay ci say njënd ?", isBot: true)
    ]
    @State private var isRecording = false
    
    var body: some View {
        NavigationView {
            VStack {
                // En-tête indicateur
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text("Bot vocal : en wolof 🇸🇳")
                        .font(.caption)
                        .foregroundColor(Theme.textLight)
                }
                .padding(.top, 8)
                
                // Liste des messages
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isBot {
                                    Text(message.text)
                                        .padding()
                                        .background(Theme.primaryGreen.opacity(0.2))
                                        .foregroundColor(Theme.textDark)
                                        .cornerRadius(16)
                                        .cornerRadius(4, corners: [.bottomLeft])
                                    Spacer()
                                } else {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Theme.primaryGreen)
                                        .foregroundColor(.white)
                                        .cornerRadius(16)
                                        .cornerRadius(4, corners: [.bottomRight])
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                // Suggestions
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        SuggestionChip(text: "Maa ngi bëgg naa...")
                        SuggestionChip(text: "Yaa ngi fii ci...")
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
                
                // Bouton Micro
                Button(action: {
                    isRecording.toggle()
                    // Simulation d'une réponse après enregistrement
                    if !isRecording {
                        messages.append(ChatMessage(text: "Maa ngi bëgg naa tomates...", isBot: false))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            messages.append(ChatMessage(text: "Léegi, dinañu ko teg ci sa pañe.", isBot: true))
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(isRecording ? Color.red.opacity(0.2) : Theme.primaryGreen.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 30))
                            .foregroundColor(isRecording ? .red : Theme.primaryGreen)
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Assistant")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Composant pour les coins arrondis spécifiques
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct SuggestionChip: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Theme.lightGray)
            .foregroundColor(Theme.textDark)
            .cornerRadius(20)
    }
}

#Preview {
    ChatbotView()
}
