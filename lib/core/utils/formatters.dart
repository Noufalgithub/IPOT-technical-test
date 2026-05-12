import 'package:intl/intl.dart';

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

  static String formatPrice(double price) {
    if (price == 0) return 'Free';
    if (price > 0) return '+${formatCurrency(price)}';
    return formatCurrency(price);
  }
}
