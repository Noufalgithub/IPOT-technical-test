// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get seeMenu => 'See Menu';

  @override
  String get scanQrToOrder => 'Scan QR Code to Order';

  @override
  String get positionQr => 'Position QR code within frame to scan';

  @override
  String get needCameraPermission => 'We need camera permission to scan QR code';

  @override
  String get cameraError => 'Camera Error';

  @override
  String get or => 'OR';

  @override
  String get enterTableId => 'Enter Table ID';

  @override
  String get submit => 'Submit';

  @override
  String get tableId => 'Table ID';

  @override
  String get enterTableIdDescription => 'Enter your table number to view the menu';

  @override
  String get exampleTableId => 'Example: T001';

  @override
  String get emptyTableIdError => 'Please enter a table number first';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get pointCameraToQr => 'Point camera to table QR code';

  @override
  String get qrAvailableOnTable => 'QR Code is available on your table';

  @override
  String get manualInputTableId => 'Manual input of table number';

  @override
  String get invalidQrCode => 'Invalid QR Code. Please try scanning again.';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get viewCart => 'View Cart';

  @override
  String failedCreateOrder(String message) {
    return 'Failed to create order: $message';
  }

  @override
  String get cart => 'Cart';

  @override
  String itemCount(int count) {
    return '$count item(s)';
  }

  @override
  String get clearAll => 'Clear All';

  @override
  String get emptyCart => 'Empty Cart';

  @override
  String get addFavoriteMenu => 'Add your favorite menu!';

  @override
  String get viewMenu => 'View Menu';

  @override
  String get kitchenNoteHint => 'Note for kitchen (optional)...\nExample: No onions, not spicy';

  @override
  String subtotal(int count) {
    return 'Subtotal ($count items)';
  }

  @override
  String get total => 'Total';

  @override
  String get processingOrder => 'Processing Order...';

  @override
  String get orderNow => 'Order Now';

  @override
  String get clearCartTitle => 'Clear Cart';

  @override
  String get clearCartContent => 'Clear all items from cart?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get note => 'Note';

  @override
  String get orderSuccessTitle => 'Order Successful!';

  @override
  String get orderSuccessMessage => 'Your order is being processed by the kitchen';

  @override
  String get orderId => 'Order ID';

  @override
  String get statusWaiting => 'Waiting';

  @override
  String get estimatedTime => 'Estimated Time';

  @override
  String get trackOrder => 'Track Order';

  @override
  String get orderMore => 'Order More';

  @override
  String get liveUpdate => 'Live Update';

  @override
  String get orderStatus => 'Order Status';

  @override
  String get orderDetail => 'Order Detail';

  @override
  String get orderCompleted => 'Order Completed';

  @override
  String get statusPending => 'Waiting for Confirmation';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusPreparing => 'Preparing';

  @override
  String get statusReady => 'Ready to Serve';

  @override
  String get statusServed => 'Served';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get descPending => 'Your order is waiting for cashier confirmation';

  @override
  String get descConfirmed => 'Your order has been confirmed!';

  @override
  String get descPreparing => 'The kitchen is preparing your order...';

  @override
  String get descReady => 'Your order is ready! Will be served shortly';

  @override
  String get descServed => 'Enjoy your meal!';

  @override
  String get loadingMenu => 'Loading menu...';

  @override
  String get failedLoadMenu => 'Failed to load menu';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get menu => 'Menu';

  @override
  String get noMenuFound => 'Menu not found';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get add => 'Add';

  @override
  String get pleaseSelectAllRequired => 'Please select all required options';

  @override
  String addedToCart(String itemName) {
    return '$itemName added to cart';
  }

  @override
  String get optional => 'Optional';

  @override
  String get required => 'Required';

  @override
  String get chooseOption => 'Choose 1';

  @override
  String get chooseMultiple => 'Choose multiple';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get updateItem => 'Update Item';

  @override
  String get searchMenu => 'Search menu...';

  @override
  String failedPlaceOrder(String message) {
    return 'Failed to place order: $message';
  }

  @override
  String itemsCount(int count) {
    return '$count items';
  }

  @override
  String get cartEmpty => 'Cart is Empty';

  @override
  String get addNote => 'Add note (optional)';

  @override
  String get checkout => 'Checkout';

  @override
  String get clearCartMessage => 'Remove all items from cart?';

  @override
  String get remove => 'Remove';

  @override
  String get table => 'Table';

  @override
  String get orderID => 'Order ID';

  @override
  String mins(int time) {
    return '$time mins';
  }

  @override
  String get orderPlaced => 'Order Placed Successfully!';

  @override
  String get orderDetails => 'Order Details';
}
