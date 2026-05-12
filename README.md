# 📱 IPOT — Mobile Developer Technical Test

A high-performance, polished Flutter application for restaurant QR-based ordering, built as part of the technical assessment for IPOT.

## 🚀 Tech Stack

- **Framework:** Flutter (Dart)
- **Architecture:** Clean Architecture (Core, Data, Presentation)
- **State Management:** BLoC / Cubit
- **Navigation:** GoRouter
- **Dependency Injection:** GetIt
- **Localization:** Flutter Gen-L10n (English & Chinese)

## ✅ Implementation Checklist

Below is the status of features implemented based on the technical requirements:

### **Core Features**
- [x] **QR Code Scanner** — Scans `ipot://table/{id}` and navigates to the menu.
- [x] **Dynamic Menu Browser** — Browse items by categories with search filtering.
- [x] **Cart & Customizations** — Add/remove items with quantity controls and modifiers (e.g., Spicy Level).
- [x] **Order Submission** — Submit orders with real-time feedback.
- [x] **Multi-language Support** — Full **English** and **Chinese** localization.

### **Technical Requirements**
- [x] **Clean Architecture** — Separated layers for better maintainability.
- [x] **State Management** — Robust logic handling using Cubit.
- [x] **Unit Testing** — Meaningful tests for Cart and calculation logic.
- [x] **Responsive UI** — Polished design that works across different screen sizes.

### **Bonus Features**
- [x] **Order Tracking** — Real-time status updates (Pending → Preparing → Served).
- [x] **Micro-animations** — Smooth transitions and interactive elements for a premium feel.

## 🛠 Getting Started

1.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Generate Localization files**:
    ```bash
    flutter gen-l10n
    ```

3.  **Run the application**:
    ```bash
    flutter run
    ```

4.  **Run tests**:
    ```bash
    flutter test
    ```

---
*Created by Noufal Ibrahim*
