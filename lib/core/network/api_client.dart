import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/errors/exceptions.dart';
import 'package:flutter/material.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ServerException(_handleDioError(e));
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    debugPrint("REQUEST: ${dio.options.baseUrl + path}");
    debugPrint("BODY: $data");
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      throw ServerException(_handleDioError(e));
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await dio.put(path, data: data);
    } on DioException catch (e) {
      throw ServerException(_handleDioError(e));
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioException catch (e) {
      throw ServerException(_handleDioError(e));
    }
  }

  /// Centralized error handling
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout";
      case DioExceptionType.sendTimeout:
        return "Send timeout";
      case DioExceptionType.badResponse:
        return e.response?.data["message"] ??
            "Server error (${e.response?.statusCode})";
      case DioExceptionType.cancel:
        return "Request cancelled";
      case DioExceptionType.unknown:
        return "No internet connection";
      default:
        return "Unexpected error";
    }
  }
}
