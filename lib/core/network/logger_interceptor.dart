import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class LoggerInterceptor extends Interceptor{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler){
    debugPrint('REQUEST => ${options.method} ${options.uri}');

    debugPrint('HEADERS => ${options.headers}');
    handler.next(options);
    // super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler){
    debugPrint('RESPONSE => ${response.statusCode}');

    handler.next(response);
    // super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler){
    debugPrint('ERROR => ${err.message}');

    handler.next(err);
    // super.onError(err, handler);
  }
}