import SwiftUI

struct ProSpaceView: View {
    @State private var selectedSection = 0 // 0 = Espace Pro, 1 = Espace Vendeur
    
    // Form States Pro
    @State private var companyName = ""
    @State private var companyType = "Restaurant / Fast-Food"
    @State private var phoneNumber = ""
    @State private var selectedPlan = "Pack Pro Mensuel (25 000 FCFA/mois)"
    @State private var isSubmitted = false
    
    let companyTypes = ["Restaurant / Fast-Food", "Cantine Scolaire / Université", "Hôtel / Résidence", "Entreprise / Service Traiteur"]
    let subscriptionPlans = [
        "Pack Starter Pro (10 000 FCFA/mois)",
        "Pack Pro Mensuel (25 000 FCFA/mois)",
        "Pack Premium Institutionnel (50 000 FCFA/mois)"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Segmented Control Pro / Vendeur
                        Picker("Espace", selection: $selectedSection) {
                            Text("Espace Pro & Cantines").tag(0)
                            Text("Devenir Vendeur Partenaire").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        if selectedSection == 0 {
                            proSpaceSection
                        } else {
                            sellerSpaceSection
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .safeAreaInset(edge: .top) {
                HStack {
                    Spacer()
                    Text("E-Food B2B & Partenaires")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textDark)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
            }
            .navigationBarHidden(true)
            .alert(isPresented: $isSubmitted) {
                Alert(
                    title: Text("Demande enregistrée ✅"),
                    message: Text("L'équipe E-Food prendra contact avec vous dans les 24 heures pour finaliser votre accès B2B."),
                    dismissButton: .default(Text("Parfait"))
                )
            }
        }
    }
    
    // MARK: - Espace Pro (Restaurants, Écoles, Entreprises)
    private var proSpaceSection: some View {
        VStack(spacing: 20) {
            // Hero Pro
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "building.2.fill")
                        .foregroundColor(Theme.primaryGreen)
                        .font(.system(size: 22))
                    Text("ESPACE PROFESSIONNELS & INSTITUTIONS")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.primaryGreen)
                }
                
                Text("Approvisionnement Régulier & Facturation Pro")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                
                Text("Bénéficiez de tarifs préférentiels en gros, de livraisons récurrentes programmées et de factures mensuelles pour votre établissement.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.secondaryLabel))
                    .lineSpacing(3)
            }
            .padding(18)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
            .padding(.horizontal, 20)
            
            // Avantages Pro
            VStack(alignment: .leading, spacing: 12) {
                Text("Avantages du compte E-Food Pro :")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                
                ProFeatureRow(icon: "truck.box.fill", title: "Livraisons quotidiennes dès 6h du matin", sub: "Produits frais arrivés directement du marché de Thiaroye")
                ProFeatureRow(icon: "doc.text.fill", title: "Facturation mensuelle centralisée", sub: "Suivi comptable clair et récapitulatif détaillé")
                ProFeatureRow(icon: "percent", title: "Réductions de 10% à 20% sur les commandes gros", sub: "Tarifs négociés directement avec nos producteurs")
            }
            .padding(18)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
            .padding(.horizontal, 20)
            
            // Formulaire d'abonnement / demande
            VStack(alignment: .leading, spacing: 14) {
                Text("Demande d'accès E-Food Pro")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                
                VStack(spacing: 12) {
                    TextField("Nom de l'établissement / entreprise", text: $companyName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Numéro de téléphone / WhatsApp", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Type d'établissement")
                            .font(.caption)
                            .foregroundColor(Theme.textLight)
                        Picker("Type", selection: $companyType) {
                            ForEach(companyTypes, id: \.self) { type in
                                Text(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Formule d'abonnement souhaitée")
                            .font(.caption)
                            .foregroundColor(Theme.textLight)
                        Picker("Plan", selection: $selectedPlan) {
                            ForEach(subscriptionPlans, id: \.self) { plan in
                                Text(plan)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                    }
                }
                
                Button(action: {
                    isSubmitted = true
                }) {
                    Text("Souscrire / Demander un devis B2B")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Theme.primaryGreen)
                        .cornerRadius(16)
                        .shadow(color: Theme.primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.top, 6)
            }
            .padding(18)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Espace Vendeurs Partenaires (Marché Thiaroye & Producteurs)
    private var sellerSpaceSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "storefront.fill")
                        .foregroundColor(Theme.primaryGreen)
                        .font(.system(size: 22))
                    Text("ESPACE VENDEURS PARTENAIRES")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.primaryGreen)
                }
                
                Text("Vendez vos produits sur E-Food Sénégal")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                
                Text("Vous êtes commerçant au marché de Thiaroye ou producteur agricole ? Élargissez votre clientèle et vendez directement aux particuliers et restaurants de Dakar.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.secondaryLabel))
                    .lineSpacing(3)
            }
            .padding(18)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
            .padding(.horizontal, 20)
            
            // Étapes Partenariat
            VStack(alignment: .leading, spacing: 14) {
                Text("Comment ça marche ?")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                
                SellerStepRow(number: "1", title: "Inscrivez votre étal / commerce", desc: "Remplissez le formulaire de partenariat gratuit")
                SellerStepRow(number: "2", title: "Recevez les commandes sur l'application", desc: "Soyez notifié dès qu'une commande est passée dans votre zone")
                SellerStepRow(number: "3", title: "Préparez les produits", desc: "Nos livreurs partenaires E-Food viennent récupérer la commande chez vous")
                SellerStepRow(number: "4", title: "Recevez vos paiements par Wave / OM", desc: "Paiement garanti et sécurisé à chaque vente")
            }
            .padding(18)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
            .padding(.horizontal, 20)
            
            // Bouton de demande partenariat
            Button(action: {
                isSubmitted = true
            }) {
                HStack {
                    Image(systemName: "person.badge.shield.checkmark.fill")
                    Text("Devenir Vendeur Partenaire E-Food")
                }
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Theme.primaryGreen)
                .cornerRadius(18)
                .shadow(color: Theme.primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 20)
        }
    }
}

// Subcomponents
struct ProFeatureRow: View {
    let icon: String
    let title: String
    let sub: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Theme.primaryGreen)
                .frame(width: 32, height: 32)
                .background(Theme.primaryGreen.opacity(0.12))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                Text(sub)
                    .font(.system(size: 12))
                    .foregroundColor(Color(.secondaryLabel))
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct SellerStepRow: View {
    let number: String
    let title: String
    let desc: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Theme.primaryGreen)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textDark)
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundColor(Color(.secondaryLabel))
            }
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ProSpaceView()
}
