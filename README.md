# 📱 IPOT — Customer QR Ordering System

A Flutter mobile application for restaurant QR-based ordering. Customers scan a QR code at their table, browse the menu, customize items, and submit orders — all from their phone.

## ✨ Features

- **QR Scanner** — Scan table QR codes or manual entry.
- **Dynamic Menu** — Browse menu with categories and availability.
- **Customization** — Select options and modifiers for each dish.
- **Smart Cart** — Manage items, quantities, and notes.
- **Order Tracking** — Real-time status updates (Pending → Served).
- **Internationalization (i18n)** — Full support for **English** and **Chinese (Simplified)** based on system settings.

## 🛠 Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** BLoC / Cubit
- **Navigation:** GoRouter
- **HTTP Client:** Dio
- **Dependency Injection:** GetIt
- **Localizations:** Flutter Gen-L10n

## 🚀 Getting Started

### Setup & Run

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate Localization files**:
   ```bash
   flutter gen-l10n
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### Running Tests

```bash
flutter test
```

## 📂 Architecture

The project follows **Clean Architecture** patterns:
- `core/`: Themes, constants, and global utilities.
- `data/`: Models, Repositories, and Data Sources (including mock data fallback).
- `presentation/`: UI screens, widgets, and Cubit logic.
- `l10n/`: Localization dictionaries (ARB).

---
Created as part of the **IPOT Mobile Developer Technical Test**.
