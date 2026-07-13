import 'package:dio/dio.dart';

abstract class Error implements Exception {
  final String? message;
  final dynamic exception;

  const Error({this.message, this.exception});

  @override
  String toString() {
    if (message != null) return message!;
    if (exception != null) return exception.toString();
    return super.toString();
  }
}

class UnknownError extends Error {
  const UnknownError({super.message, super.exception});
}

class ServerError extends Error {
  const ServerError({super.message, super.exception});
}

class ConnectionError extends Error {
  const ConnectionError({super.message, super.exception});
}

class InvalidError extends Error {
  const InvalidError({super.message, super.exception});
}

Error handleDioException(DioException e) {
  final statusCode = e.response?.statusCode;
  final serverMessage = e.response?.data is Map
      ? e.response?.data['message'] ?? e.response?.data['error']
      : null;

  if (serverMessage != null) {
    return ServerError(message: serverMessage.toString());
  }

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const ConnectionError(message: 'Connection timed out. Please try again.');
    case DioExceptionType.connectionError:
      return const ConnectionError(message: 'No internet connection.');
    default:
      return ServerError(message: 'Something went wrong (${statusCode ?? 'unknown'}).');
  }
}
