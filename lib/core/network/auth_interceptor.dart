import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/services/session_services.dart';

class AuthInterceptor extends Interceptor {
  final SessionServices session;

  AuthInterceptor(this.session);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = session.token;

    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
