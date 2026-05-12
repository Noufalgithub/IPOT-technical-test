import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ipot_technical_test/l10n/app_localizations.dart';

class Formatters {
  Formatters._();

  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatPrice(double price, BuildContext context) {
    if (price == 0) return AppLocalizations.of(context)!.free;
    if (price > 0) return '+${formatCurrency(price)}';
    return formatCurrency(price);
  }
}
