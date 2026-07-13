import 'dart:async';

import 'package:dio/dio.dart' hide Response;
import 'package:emvigo_test/core/network/utils/exceptions.dart';
import 'package:emvigo_test/core/network/utils/response.dart';
import 'package:emvigo_test/dependencies/get_dependencies.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AppServices {
  late final Dio _dio;

  static Completer<bool>? _refreshCompleter;

  AppServices() {
    _dio = Dio(BaseOptions(
      baseUrl: urls.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = prefs.getAuthToken();
        if (token != null) {
          options.headers['x-auth-token'] = token;
        }
        return handler.next(options);
      },
      onError: (DioException err, ErrorInterceptorHandler handler) async {
        if (err.response?.statusCode == 401) {
          if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
            final refreshed = await _refreshCompleter!.future;
            if (refreshed) {
              err.requestOptions.headers['x-auth-token'] = prefs.getAuthToken();
              return handler.resolve(await _dio.fetch(err.requestOptions));
            }
          }
          prefs.clearAuth();
        }
        return handler.next(err);
      },
    ));

    _dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      compact: false,
    ));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final res = await _dio.get(path, queryParameters: queryParameters);
      return Response.success(fromJson(res.data));
    } on DioException catch (e) {
      return Response.failure(handleDioException(e));
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final res = await _dio.post(path, data: data);
      return Response.success(fromJson(res.data));
    } on DioException catch (e) {
      return Response.failure(handleDioException(e));
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final res = await _dio.put(path, data: data);
      return Response.success(fromJson(res.data));
    } on DioException catch (e) {
      return Response.failure(handleDioException(e));
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final res = await _dio.delete(path);
      return Response.success(fromJson(res.data));
    } on DioException catch (e) {
      return Response.failure(handleDioException(e));
    }
  }
}
