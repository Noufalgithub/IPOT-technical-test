import 'package:go_router/go_router.dart';
import 'presentation/scanner/scanner_screen.dart';
import 'presentation/menu/menu_screen.dart';
import 'presentation/cart/cart_screen.dart';
import 'presentation/order/order_confirmation_screen.dart';
import 'presentation/order/order_tracking_screen.dart';

class AppRouter {
  AppRouter._();

  static const String scanner = '/';
  static const String menu = '/menu';
  static const String cart = '/cart';
  static const String orderConfirmation = '/order-confirmation';
  static const String orderTracking = '/order-tracking';

  static final GoRouter router = GoRouter(
    initialLocation: scanner,
    routes: [
      GoRoute(
        path: scanner,
        name: 'scanner',
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        path: menu,
        name: 'menu',
        builder: (context, state) {
          final tableId = state.uri.queryParameters['tableId'] ?? 'T001';
          return MenuScreen(tableId: tableId);
        },
      ),
      GoRoute(
        path: cart,
        name: 'cart',
        builder: (context, state) {
          final tableId = state.uri.queryParameters['tableId'] ?? 'T001';
          return CartScreen(tableId: tableId);
        },
      ),
      GoRoute(
        path: orderConfirmation,
        name: 'orderConfirmation',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OrderConfirmationScreen(
            orderId: extra?['orderId'] ?? '',
            tableId: extra?['tableId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: orderTracking,
        name: 'orderTracking',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OrderTrackingScreen(
            orderId: extra?['orderId'] ?? '',
          );
        },
      ),
    ],
  );
}
