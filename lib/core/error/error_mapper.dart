import 'dart:io';
import 'package:dio/dio.dart';
import 'exceptions.dart';

class ErrorMapper {
  ErrorMapper._();

  static AppException map(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return AppException(
            message: 'Connection timeout',
            type: ErrorType.timeout,
            originalError: error,
          );
        case DioExceptionType.badResponse:
          return AppException(
            message: 'Server error: ${error.response?.statusCode}',
            type: ErrorType.server,
            originalError: error,
          );
        case DioExceptionType.connectionError:
          if (error.error is HandshakeException) {
             return AppException(
              message: 'Secure connection failed',
              type: ErrorType.handshake,
              originalError: error,
            );
          }
          return AppException(
            message: 'Network connection issue',
            type: ErrorType.network,
            originalError: error,
          );
        default:
          final errorStr = error.toString().toLowerCase();
          final innerError = error.error;

          if (innerError is SocketException ||
              errorStr.contains('socketexception') ||
              errorStr.contains('connection refused')) {
            return AppException(
              message: 'No internet connection',
              type: ErrorType.network,
              originalError: error,
            );
          }

          if (innerError is HandshakeException ||
              errorStr.contains('handshake') ||
              errorStr.contains('tls') ||
              errorStr.contains('cert')) {
            return AppException(
              message: 'Secure connection failed',
              type: ErrorType.handshake,
              originalError: error,
            );
          }

          return AppException(
            message: 'Unexpected error occurred',
            type: ErrorType.unknown,
            originalError: error,
          );
      }
    }
    
    final errorStr = error.toString().toLowerCase();

    if (error is SocketException || errorStr.contains('socketexception')) {
      return AppException(
        message: 'Network connection issue',
        type: ErrorType.network,
        originalError: error,
      );
    }

    if (error is HandshakeException ||
        errorStr.contains('handshake') ||
        errorStr.contains('tls')) {
      return AppException(
        message: 'Secure connection failed',
        type: ErrorType.handshake,
        originalError: error,
      );
    }

    return AppException(
      message: error.toString(),
      type: ErrorType.unknown,
      originalError: error,
    );
  }
}
