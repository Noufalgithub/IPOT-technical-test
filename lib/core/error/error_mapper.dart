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
          if (error.error is SocketException) {
            return AppException(
              message: 'No internet connection',
              type: ErrorType.network,
              originalError: error,
            );
          }
          if (error.error is HandshakeException) {
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
    
    if (error is SocketException) {
      return AppException(
        message: 'Network connection issue',
        type: ErrorType.network,
        originalError: error,
      );
    }

    if (error is HandshakeException) {
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
