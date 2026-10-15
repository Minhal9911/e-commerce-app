import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/constants/api_constants.dart';
import 'package:e_commerce_app/dependencyInjection/injection_container.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_event.dart';

class AuthFailureInterceptor extends Interceptor{
  @override
  void onError(DioException err, ErrorInterceptorHandler handler)async{
    final isLoginRequest = err.requestOptions.path.contains(ApiConstants.loginEndpoint);

    if(err.response?.statusCode ==401 && !isLoginRequest){
      // appRouter.go(RouteConst.login);
      sl<AppBloc>().add(LoggedOut());
    }
    handler.next(err);
  }
}