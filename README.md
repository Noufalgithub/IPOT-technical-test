# 📱 IPOT — Customer QR Ordering System

A Flutter mobile application for restaurant QR-based ordering. Customers scan a QR code at their table, browse the menu, customize items, and submit orders — all from their phone.

## Features

- **QR Code Scanner** — Scan table QR codes or enter table ID manually
- **Menu Browser** — Category-based menu with images, descriptions, and availability status
- **Cart & Customization** — Single/multi-select customizations, quantity management, price modifiers
- **Order Submission** — Submit orders to backend with full item + customization payload
- **Order Tracking** *(Bonus)* — Real-time status tracking with polling (Pending → Confirmed → Preparing → Ready → Served)

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.11+ / Dart |
| State Management | `flutter_bloc` (Cubit) |
| Navigation | `go_router` |
| HTTP Client | `dio` |
| Dependency Injection | `get_it` |
| QR Scanner | `mobile_scanner` |
| Image Caching | `cached_network_image` |
| Testing | `flutter_test` + `bloc_test` |

## Architecture

The project follows **Clean Architecture** with clear separation of concerns:

```
lib/
├── core/                          # Shared utilities & configuration
│   ├── constants/
│   │   └── api_constants.dart     # API endpoints & timeouts
│   ├── theme/
│   │   └── app_theme.dart         # App-wide dark theme
│   └── utils/
│       └── formatters.dart        # Price & date formatters
├── data/                          # Data layer
│   ├── datasources/
│   │   ├── api_client.dart        # Dio HTTP client wrapper
│   │   └── mock_data.dart         # Offline mock data (11 menu items)
│   ├── models/
│   │   ├── cart_item_model.dart    # Cart item with customizations
│   │   ├── category_model.dart    # Menu category
│   │   ├── customization_model.dart # Customization groups & options
│   │   ├── menu_item_model.dart   # Menu item
│   │   └── order_model.dart       # Order with status enum
│   └── repositories/
│       ├── menu_repository.dart   # Menu data fetching + mock fallback
│       └── order_repository.dart  # Order submission + status polling
├── presentation/                  # UI layer
│   ├── scanner/
│   │   └── scanner_screen.dart    # QR scanner + manual input
│   ├── menu/
│   │   ├── menu_screen.dart       # Category tabs + item list
│   │   ├── cubit/menu_cubit.dart  # Menu state management
│   │   └── widgets/
│   │       └── customization_bottom_sheet.dart
│   ├── cart/
│   │   ├── cart_screen.dart       # Cart summary + checkout
│   │   └── cubit/cart_cubit.dart  # Cart operations (add/remove/update)
│   └── order/
│       ├── order_confirmation_screen.dart
│       ├── order_tracking_screen.dart
│       └── cubit/order_cubit.dart # Order submission + status polling
├── injection_container.dart       # GetIt DI setup
├── router.dart                    # GoRouter navigation config
└── main.dart                      # App entry point
```

### State Management Flow

```
User Action → Cubit Method → Repository → API/Mock → Cubit emits State → UI rebuilds
```

- **CartCubit** — Singleton; persists cart across all screens
- **MenuCubit** — Factory; fresh instance per menu screen, fetches categories + items
- **OrderCubit** — Factory; handles order submission and status polling

### Error Handling Strategy

All repository methods catch `DioException` and fall back to mock data, so the app is **fully functional offline**. This allows demo/review without a running backend.

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.11.0
- Dart SDK ≥ 3.11.0
- Android Studio / Xcode (for device builds)

### Setup

```bash
# Clone the repository
git clone https://github.com/<your-username>/ipot_technical_test.git
cd ipot_technical_test

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### API Configuration

The API base URL is configured in [`lib/core/constants/api_constants.dart`](lib/core/constants/api_constants.dart):

```dart
static const String baseUrl = 'https://api.ipot.app';
```

Change this to point to your backend. When the API is unreachable, the app automatically falls back to built-in mock data.

### Build APK

```bash
flutter build apk --release
```

The APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

## Running Tests

```bash
# Run all tests
flutter test

# Run with verbose output
flutter test --reporter expanded

# Run specific test file
flutter test test/cart_cubit_test.dart
```

### Test Coverage

| Test File | Tests | What's Covered |
|---|---|---|
| `cart_cubit_test.dart` | 17 | Add/remove items, quantity updates, price calculations with customization modifiers, cart merge logic, customer notes |
| `widget_test.dart` | 4 | App renders, scanner UI elements, IPOT branding, manual table entry flow |
| **Total** | **21** | **All passing ✅** |

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/v1/menu?table_id={id}` | Fetch menu for a table |
| `GET` | `/api/v1/categories` | List menu categories |
| `POST` | `/api/v1/orders` | Create new order |
| `GET` | `/api/v1/orders/{id}` | Get order status |
| `GET` | `/api/v1/tables/{id}/status` | Get table status |

### Order Submission Payload

```json
{
  "table_id": "T001",
  "items": [
    {
      "menu_item_id": "item_3",
      "quantity": 2,
      "customizations": [
        {
          "group_id": "cg_4",
          "group_name": "Tingkat Kepedasan",
          "selected_options": [
            { "id": "co_10", "name": "Pedas", "price_modifier": 0 }
          ]
        }
      ]
    }
  ],
  "customer_note": "No MSG please"
}
```

## User Flow

```
┌─────────────┐    ┌──────────────┐    ┌────────────┐    ┌──────────────┐    ┌────────────────┐
│  QR Scanner  │───▶│  Menu Browse  │───▶│    Cart     │───▶│  Confirmation │───▶│ Order Tracking  │
│  (or Manual) │    │  + Customize  │    │  + Checkout │    │  (Order ID)   │    │  (Live Status)  │
└─────────────┘    └──────────────┘    └────────────┘    └──────────────┘    └────────────────┘
```

## Static Analysis

```bash
flutter analyze lib/
# Result: No issues found!
```

## License

This project is created as part of the IPOT Mobile Developer Technical Test.
