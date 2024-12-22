import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ErrorHandler {
  final Logger _logger = Logger();

  String handleError(DioException dioError) {
    final dioExceptions = DioExceptions.fromDioError(dioError);
    _logger.e('DioError: ${dioExceptions.toString()}');
    return dioExceptions.toString();
  }
}

class DioExceptions implements Exception {
  late final String message;

  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled.";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with API server.";
        break;
      case DioExceptionType.connectionError:
        message =
            "Network error: Unable to connect. Please check your internet connection.";
        break;
      case DioExceptionType.unknown:
        message = "Something went wrong. Please try again later.";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server.";
        break;
      case DioExceptionType.badResponse:
        if (dioError.response != null) {
          print(' dioError.response!.data ');
          print(dioError.response!.data);
          message = _handleError(
            dioError.response!.statusCode ?? 0,
            dioError.response!.data,
          );
        } else {
          message = "Unexpected error occurred.";
        }
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with API server.";
        break;
      default:
        message = "Something went wrong.";
        break;
    }
  }

  String _handleError(int statusCode, dynamic error) {
    final dynamic message = error['message'];
    if (message is String) {
      return message;
    } else if (message is List) {
      return message.join(', ');
    } else {
      return 'An unexpected error occurred.';
    }
  }

  @override
  String toString() => message;
}
