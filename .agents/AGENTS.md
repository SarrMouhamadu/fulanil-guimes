# Directives et Règles du Projet Fulani

## ⚠️ Règle Absolue : Préservation Intégrale du Design UI/UX
- **NE JAMAIS ALTÉRER OU MODIFIER LE DESIGN VISUEL EXISTANT**.
- Les choix graphiques, composants UI, thèmes (`Theme.swift`), marges, paddings, animations et layouts des vues (`HomeView`, `CatalogueView`, `CartView`, `ProductDetailView`, `CheckoutView`, `OrderTrackingView`, `ChatbotView`, `TrustBadgesView`) sont STRICTEMENT VERROUILLÉS et VALIDÉS PAR L'UTILISATEUR.
- Toute implémentation de nouvelles fonctionnalités (API Backend, persistance de données, SDK paiement, etc.) doit impérativement s'insérer dans l'architecture visuelle actuelle sans modifier le design ni l'aspect esthétique de l'application.
