import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @seeMenu.
  ///
  /// In en, this message translates to:
  /// **'See Menu'**
  String get seeMenu;

  /// No description provided for @scanQrToOrder.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code to Order'**
  String get scanQrToOrder;

  /// No description provided for @positionQr.
  ///
  /// In en, this message translates to:
  /// **'Position QR code within frame to scan'**
  String get positionQr;

  /// No description provided for @needCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'We need camera permission to scan QR code'**
  String get needCameraPermission;

  /// No description provided for @cameraError.
  ///
  /// In en, this message translates to:
  /// **'Camera Error'**
  String get cameraError;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @enterTableId.
  ///
  /// In en, this message translates to:
  /// **'Enter Table ID'**
  String get enterTableId;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @tableId.
  ///
  /// In en, this message translates to:
  /// **'Table ID'**
  String get tableId;

  /// No description provided for @enterTableIdDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your table number to view the menu'**
  String get enterTableIdDescription;

  /// No description provided for @exampleTableId.
  ///
  /// In en, this message translates to:
  /// **'Example: T001'**
  String get exampleTableId;

  /// No description provided for @emptyTableIdError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a table number first'**
  String get emptyTableIdError;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @pointCameraToQr.
  ///
  /// In en, this message translates to:
  /// **'Point camera to table QR code'**
  String get pointCameraToQr;

  /// No description provided for @qrAvailableOnTable.
  ///
  /// In en, this message translates to:
  /// **'QR Code is available on your table'**
  String get qrAvailableOnTable;

  /// No description provided for @manualInputTableId.
  ///
  /// In en, this message translates to:
  /// **'Manual input of table number'**
  String get manualInputTableId;

  /// No description provided for @invalidQrCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR Code. Please try scanning again.'**
  String get invalidQrCode;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @viewCart.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get viewCart;

  /// No description provided for @failedCreateOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to create order: {message}'**
  String failedCreateOrder(String message);

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} item(s)'**
  String itemCount(int count);

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Cart is Empty'**
  String get emptyCart;

  /// No description provided for @addFavoriteMenu.
  ///
  /// In en, this message translates to:
  /// **'Add your favorite menu!'**
  String get addFavoriteMenu;

  /// No description provided for @viewMenu.
  ///
  /// In en, this message translates to:
  /// **'View Menu'**
  String get viewMenu;

  /// No description provided for @kitchenNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Note for kitchen (optional)...\nExample: No onions, not spicy'**
  String get kitchenNoteHint;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal ({count} items)'**
  String subtotal(int count);

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @processingOrder.
  ///
  /// In en, this message translates to:
  /// **'Processing Order...'**
  String get processingOrder;

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNow;

  /// No description provided for @clearCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get clearCartTitle;

  /// No description provided for @clearCartContent.
  ///
  /// In en, this message translates to:
  /// **'Clear all items from cart?'**
  String get clearCartContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @orderSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Successful!'**
  String get orderSuccessTitle;

  /// No description provided for @orderSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order is being processed by the kitchen'**
  String get orderSuccessMessage;

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderId;

  /// No description provided for @statusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusWaiting;

  /// No description provided for @estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated Time'**
  String get estimatedTime;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// No description provided for @orderMore.
  ///
  /// In en, this message translates to:
  /// **'Order More'**
  String get orderMore;

  /// No description provided for @liveUpdate.
  ///
  /// In en, this message translates to:
  /// **'Live Update'**
  String get liveUpdate;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatus;

  /// No description provided for @orderDetail.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get orderDetail;

  /// No description provided for @orderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Order Completed'**
  String get orderCompleted;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get statusPreparing;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @statusServed.
  ///
  /// In en, this message translates to:
  /// **'Served'**
  String get statusServed;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @descPending.
  ///
  /// In en, this message translates to:
  /// **'Your order is waiting for cashier confirmation'**
  String get descPending;

  /// No description provided for @descConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your order has been confirmed!'**
  String get descConfirmed;

  /// No description provided for @descPreparing.
  ///
  /// In en, this message translates to:
  /// **'The kitchen is preparing your order...'**
  String get descPreparing;

  /// No description provided for @descReady.
  ///
  /// In en, this message translates to:
  /// **'Your order is ready! Will be served shortly'**
  String get descReady;

  /// No description provided for @descServed.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your meal!'**
  String get descServed;

  /// No description provided for @loadingMenu.
  ///
  /// In en, this message translates to:
  /// **'Loading menu...'**
  String get loadingMenu;

  /// No description provided for @failedLoadMenu.
  ///
  /// In en, this message translates to:
  /// **'Failed to load menu'**
  String get failedLoadMenu;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @noMenuFound.
  ///
  /// In en, this message translates to:
  /// **'Menu not found'**
  String get noMenuFound;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @pleaseSelectAllRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select all required options'**
  String get pleaseSelectAllRequired;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'{itemName} added to cart'**
  String addedToCart(String itemName);

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @chooseOption.
  ///
  /// In en, this message translates to:
  /// **'Choose 1'**
  String get chooseOption;

  /// No description provided for @chooseMultiple.
  ///
  /// In en, this message translates to:
  /// **'Choose multiple'**
  String get chooseMultiple;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @updateItem.
  ///
  /// In en, this message translates to:
  /// **'Update Item'**
  String get updateItem;

  /// No description provided for @searchMenu.
  ///
  /// In en, this message translates to:
  /// **'Search menu...'**
  String get searchMenu;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note (optional)'**
  String get addNote;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @table.
  ///
  /// In en, this message translates to:
  /// **'Table {id}'**
  String table(String id);

  /// No description provided for @tableLabel.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get tableLabel;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @digitalOrdering.
  ///
  /// In en, this message translates to:
  /// **'Digital Ordering'**
  String get digitalOrdering;

  /// No description provided for @mins.
  ///
  /// In en, this message translates to:
  /// **'{time} mins'**
  String mins(int time);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
