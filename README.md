# 🌿 Fulani Légumes 🇸🇳

> **Application mobile e-commerce de livraison de légumes frais et locaux du marché de Thiaroye (Sénégal).**

![Platform](https://img.shields.io/badge/Plateforme-iOS%2015%2B-000000?style=for-the-badge&logo=apple&logoColor=white)
![Language](https://img.shields.io/badge/Langage-SwiftUI%20%7C%20Swift%205-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-008000?style=for-the-badge)
![Design](https://img.shields.io/badge/Design-Apple%20HIG%20%2F%20Premium-326CE5?style=for-the-badge)

---

## 🌟 Présentation

**Fulani Légumes** est une application iOS e-commerce *mobile-first* conçue pour rapprocher les producteurs et commerçants du **Marché de Thiaroye (Dakar, Sénégal)** des foyers urbains. L'application garantit des légumes d'une fraîcheur irréprochable tout en simplifiant au maximum l'expérience d'achat grâce à des interfaces modernes et une innovation majeure : un **Assistant Vocal en Wolof**.

---

## ✨ Fonctionnalités & Expérience Utilisateur (UI/UX)

- 🛍️ **Catalogue & Accueil Responsives** :
  - **Grille Adaptative et Universelle** : L'affichage des produits s'ajuste dynamiquement sur tous les écrans, du plus petit iPhone (SE/Mini) au Pro Max et à l'iPad (`LazyVGrid` adaptative).
  - **Recherche et Filtres Fluides** : Navigation instantanée par catégories (*Légumes-fruits*, *Tubercules*, *Racines*, *Feuilles*).

- 🎨 **Design Premium selon les Apple HIG** :
  - **Glassmorphism & Sticky Headers** : En-têtes fixes et semi-transparents avec effet de flou (`.ultraThinMaterial`), garantissant une immersion visuelle totale au défilement.
  - **Hiérarchie et Grille de 8 points** : Espacements rigoureux, ombres portées douces sur fond système (`.systemGroupedBackground`) et cartes produits modernes en relief.
  - **Contrôleurs de Quantité "Pilule"** : Design ergonomique et natif inspiré des meilleures applications du marché (*Instacart*, *Uber Eats*, *Apple Store*).

- 🇸🇳 **Assistant d'Achat Vocal en Wolof (Innovation Locale)** :
  - Un bot interactif par commandes vocales et textuelles (*"Salam, souma nga..."*) conçu pour surmonter les barrières de langue et faciliter l'adoption auprès de toute la population sénégalaise.
  - Puces de suggestions contextualisées en wolof.

- 🚚 **Panier, Checkout & Suivi de Commande Intuitifs** :
  - **Jauge de Livraison Gratuite** : Barre de progression animée incitant intelligemment au complément d'achat pour atteindre le palier des **10 000 FCFA**.
  - **Format Monétaire Sénégalais / Français** : Uniformisation de l'affichage des devises en FCFA avec séparateur insecable (**`1 500 FCFA`**).
  - **Moyens de Paiement Locaux intégrés** : Support natif pour **Wave**, **Orange Money** et **Espèces à la livraison**.
  - **Suivi en Temps Réel** : Chronologie du cycle de livraison et mise en relation directe avec le livreur attitré.

---

## 🏗️ Architecture & Organisation du Dépôt

Le projet respecte rigoureusement l'architecture **MVVM (Model-View-ViewModel)** et découpe les responsabilités pour une maintenabilité et une testabilité optimales :

```text
fulani/
│
├── 🗂 fulani.xcodeproj/           # Fichier de configuration du projet Xcode
│
└── 📁 fulani/                     # Code source principal de l'application
    │
    ├── 📁 Models/                 # Entités et structures de données
    │   └── Product.swift          # Modèle produit, données mockées du marché
    │
    ├── 📁 ViewModels/             # Logique métier et gestion d'état centralisée
    │   ├── CartManager.swift      # Source de vérité (panier, sous-total, navigation d'onglets, toasts)
    │   └── CatalogueViewModel.swift # Logique de recherche et de filtrage du catalogue
    │
    ├── 📁 Views/                  # Écrans et composants graphiques SwiftUI
    │   ├── MainTabView.swift      # Conteneur d'onglets principal avec badge panier
    │   ├── HomeView.swift         # Écran d'accueil avec grille arrivages & ProductCardView
    │   ├── CatalogueView.swift    # Catalogue complet avec barre de recherche & catégories
    │   ├── ProductDetailView.swift # Fiche produit détaillée et sélection de quantité
    │   ├── CartView.swift         # Panier redesigné selon les Apple HIG (Empty State inclus)
    │   ├── CheckoutView.swift     # Validation d'adresse et choix du paiement local (Wave/Orange Money)
    │   ├── OrderTrackingView.swift # Chronologie interactive de livraison & contact livreur
    │   ├── ChatbotView.swift      # Assistant de commande vocale et conversationnelle en Wolof
    │   └── TrustBadgesView.swift  # Composant réutilisable de badges de réassurance
    │
    ├── 📁 Core/                   # Thématique et outils transversaux
    │   └── Theme.swift            # Palette de couleurs, grille adaptative et formateurs FCFA
    │
    └── 🎨 Assets.xcassets/        # Catalogue d'images optimisées (sans caractères accentués ni espaces problématiques)
```

---

## 🚀 Installation & Démarrage

### Prérequis
- **Mac** sous macOS Monterey / Ventura ou supérieur.
- **Xcode 14+** (SDK iOS 15.0+).

### Instructions de lancement :
1. **Clonage du dépôt** :
   ```bash
   git clone https://github.com/SarrMouhamadu/fulanil-guimes.git
   cd fulanil-guimes
   ```
2. **Ouverture dans Xcode** :
   Double-cliquez sur `fulani.xcodeproj` (ou lancez `open fulani.xcodeproj` depuis le terminal).
3. **Compilation et Simulation** :
   - Sélectionnez un simulateur iOS (ex: *iPhone 15*, *iPhone Pro Max* ou *iPhone SE (3rd generation)* pour tester la résilience responsive).
   - Appuyez sur **`Cmd + R`** (Bouton ▶️) pour lancer l'application !

---

## 👨‍💻 Conception & Philosophie

Ce dépôt est conçu dans un esprit d'excellence visuelle et de robustesse technique, en plaçant les besoins des commerçants et foyers sénégalais au cœur de la réflexion ergonomique. 

**Fulani Légumes** : *La fraîcheur du marché de Thiaroye, livrée chez vous, au son de votre voix.* 🇸🇳🌾