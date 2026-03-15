# 💰 Entitlements — Debt & Financial Tracking App

> **A professional Flutter app to track your receivables and payables with friends and clients**
---

## 📖 Overview

**Entitlements** is a mobile app built with Flutter that helps you track your financial debts and receivables in a clean, organized way. You can add people you deal with financially, record every transaction (debt or receivable), and instantly see your net balance at a glance.

The app supports **Arabic and English**, works in **dark and light mode**, and syncs in real time using **Firebase Firestore**.

---

## ✨ Features

### 🔐 Authentication & Account Management
- Sign in with **Email & Password** with email verification
- Sign in with **Google** (OAuth 2.0)
- **Create a new account** with input validation
- **Password reset** via email
- **Edit display name** directly from the account profile

### 📊 Dashboard
- **Net balance card** showing total receivables and payables at a glance
- **Quick stats**: number of people who owe you vs. people you owe
- **Last 6 transactions** with date, amount, and color-coded indicators
- **Quick actions**: add a new person or new transaction in one tap
- **Smart greeting** (Good Morning / Good Evening) based on time of day

### 👥 Client Management
- Add, edit, and delete financial contacts
- **Instant search** by name
- Display the **total balance** per person with a color indicator (green = receivable, red = payable)
- Navigate to a person's full transaction history in one tap

### 💸 Transaction Details
- Add new transactions (debt or receivable) with description and amount
- Edit a transaction's description or amount
- Delete a transaction with confirmation
- Full transaction history per person
- **Automatic balance update** on every change

### ⚙️ Settings
- **Switch language** between Arabic and English (saved automatically)
- **Switch theme** between dark and light mode (saved automatically)
- **Contact the developer** via WhatsApp

### 🌐 Technical Features
- **Real-time internet connectivity monitoring** with instant offline alert
- Full **RTL support** for Arabic
- **Real-time sync** with Firebase Firestore
- **Persistent settings** stored locally with SharedPreferences

---

## 🛠️ Requirements

### Development Environment

| Tool | Required Version |
|------|-----------------|
| **Flutter SDK** | `^3.x` (latest stable recommended) |
| **Dart SDK** | `^3.10.4` |
| **Android Studio / VS Code** | Latest version |
| **Java JDK** | 17 or higher |

### Android

| Requirement | Value |
|-------------|-------|
| **minSdkVersion** | 21 (Android 5.0+) |
| **targetSdkVersion** | 34 |
| **compileSdkVersion** | 34 |

### iOS

| Requirement | Value |
|-------------|-------|
| **iOS Deployment Target** | 13.0+ |
| **Xcode** | 15+ |

### Firebase
- A Google Firebase account
- A Firebase project with the following enabled:
  - **Firebase Authentication** (Email/Password + Google Sign-In)
  - **Cloud Firestore**

---

## 📦 Dependencies

```yaml
dependencies:
  firebase_core: ^4.4.0           # Firebase initialization
  cloud_firestore: ^6.1.2         # Cloud database
  firebase_auth: ^6.1.4           # Authentication
  google_sign_in: ^7.2.0          # Google Sign-In
  flutter_localizations: sdk      # Multi-language support
  url_launcher: ^6.3.2            # Open external links (WhatsApp)
  shared_preferences: ^2.5.4      # Local settings storage
  connectivity_plus: ^7.0.0       # Internet connectivity monitoring
```

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/entitlements.git
cd entitlements
```

### 2. Set Up Firebase

#### a) Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or use an existing one
3. Enable **Authentication** and select sign-in methods:
   - ✅ Email/Password
   - ✅ Google
4. Create a **Firestore Database** in test or production mode

#### b) Add Configuration Files
- **Android**: Place `google-services.json` at:
  ```
  android/app/google-services.json
  ```
- **iOS**: Place `GoogleService-Info.plist` at:
  ```
  ios/Runner/GoogleService-Info.plist
  ```

#### c) Update firebase_options.dart
If you regenerate Firebase files, run:
```bash
flutterfire configure
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Check Your Environment

```bash
flutter doctor
```

Make sure all checks are ✅ before proceeding.

### 5. Run the App

```bash
# Run on connected device or emulator
flutter run

# Build release APK
flutter build apk --release

# Build App Bundle (for Google Play)
flutter build appbundle --release

# Run on iOS (requires Mac + Xcode)
flutter run -d ios
```

---

## 🗂️ Project Structure

```
lib/
├── main.dart                 # Entry point, theme and locale setup
├── homepage.dart             # Home screen + dashboard
├── signin.dart               # Sign-in screen
├── signup.dart               # Sign-up screen
├── myclients.dart            # Client list with search
├── persondetailes.dart       # Transaction details per person
├── myaccount.dart            # User account profile
├── settings.dart             # Settings screen
├── connected.dart            # Internet connectivity wrapper
├── firebase_options.dart     # Firebase config (auto-generated)
├── data/
│   └── appwords.dart         # Localization strings (Arabic/English)
└── mywidgets/
    ├── myappbar.dart         # Custom AppBar
    ├── mycard.dart           # Custom Card widget
    └── mytextfield.dart      # Custom TextField widget
```

---

## 🔥 Firestore Data Structure

```
users_accounts/
└── {userId}/
    ├── full_name: string
    ├── email: string
    ├── My_Clients/
    │   └── {clientId}/
    │       ├── full_name: string
    │       ├── total_amount: number     ← auto-updated on every transaction
    │       ├── created_at: timestamp
    │       └── transactions/
    │           └── {txId}/
    │               ├── amount: number
    │               ├── description: string
    │               ├── isdebt: boolean
    │               └── time: timestamp
    └── recent_transactions/
        └── {txId}/
            ├── amount: number
            ├── description: string
            ├── isdebt: boolean
            └── time: timestamp
```

---

## 🎨 Color System

| Mode | Primary Color | Background | Card Background |
|------|--------------|------------|----------------|
| **Dark** | `#19E26A` | `#061A13` | `#0F2C22` |
| **Light** | `#1B8C4E` | `#F1F8F4` | `#E8F5E9` |

---

## 🌍 Supported Languages

| Language | Code | RTL |
|----------|------|-----|
| Arabic | `ar` | ✅ |
| English | `en` | ❌ |

---

## ⚠️ Important Notes

> **`google-services.json` and `GoogleService-Info.plist`** are not included in the source code for security reasons. You must add them manually from the Firebase Console.

> **`key.properties`** (Android signing config) is not included. Make sure to configure it before building a release APK.

---

## 🤝 Contact the Developer

whatsapp: 967717471102

Made with ❤️ using Flutter & Firebase

**Entitlements** — *Your debts, all in one place*
