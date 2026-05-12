import 'package:flutter/widgets.dart';
import 'package:ipot_technical_test/l10n/app_localizations.dart';

enum ErrorType {
  network,
  server,
  timeout,
  handshake,
  unknown,
}

class AppException implements Exception {
  final String message;
  final ErrorType type;
  final dynamic originalError;

  AppException({
    required this.message,
    required this.type,
    this.originalError,
  });

  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case ErrorType.network:
        return l10n.errorNetwork;
      case ErrorType.server:
        return l10n.errorServer;
      case ErrorType.timeout:
        return l10n.errorTimeout;
      case ErrorType.handshake:
        return l10n.errorHandshake;
      case ErrorType.unknown:
        return l10n.errorUnknown;
    }
  }

  @override
  String toString() => message;
}
