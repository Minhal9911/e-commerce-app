import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/constants/api_constants.dart';
import 'package:e_commerce_app/core/constants/storage_keys.dart';
import 'package:e_commerce_app/core/network/api_client.dart';
import 'package:e_commerce_app/core/network/auth_failure_interceptor.dart';
import 'package:e_commerce_app/core/network/auth_interceptor.dart';
import 'package:e_commerce_app/core/network/connectivity_service.dart';
import 'package:e_commerce_app/core/network/logger_interceptor.dart';
import 'package:e_commerce_app/core/services/session_services.dart';
import 'package:e_commerce_app/core/services/storage_service.dart';
import 'package:e_commerce_app/data/datasources/address_local_datasource.dart';
import 'package:e_commerce_app/data/datasources/address_remote_datasource.dart';
import 'package:e_commerce_app/data/datasources/auth_remote_datasource.dart';
import 'package:e_commerce_app/data/datasources/cart_local_datasource.dart';
import 'package:e_commerce_app/data/datasources/cart_remote_datasource.dart';
import 'package:e_commerce_app/data/datasources/order_local_datasource.dart';
import 'package:e_commerce_app/data/datasources/order_remote_datasource.dart';
import 'package:e_commerce_app/data/datasources/product_remote_datasource.dart';
import 'package:e_commerce_app/data/datasources/profile_local_datasource.dart';
import 'package:e_commerce_app/data/datasources/wishlist_local_datasource.dart';
import 'package:e_commerce_app/data/repositories/address_repository.dart';
import 'package:e_commerce_app/data/repositories/auth_repository.dart';
import 'package:e_commerce_app/data/repositories/cart_repository.dart';
import 'package:e_commerce_app/data/repositories/order_repository.dart';
import 'package:e_commerce_app/data/repositories/product_repository.dart';
import 'package:e_commerce_app/data/repositories/profile_repository.dart';
import 'package:e_commerce_app/data/repositories/theme_repository.dart';
import 'package:e_commerce_app/data/repositories/wishlist_repository.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/home/home_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/profile/profile_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/theme/theme_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  ///Local Storage--------------------------------------------------------------
  sl.registerLazySingleton<GetStorage>(() => GetStorage(StorageKeys.appStorage));
  sl.registerLazySingleton<StorageService>(() => StorageService(sl()));

  ///Theme Repository-----------------------------------------------------------
  sl.registerLazySingleton(()=> ThemeRepository(sl<StorageService>()));
  sl.registerLazySingleton(()=>ThemeBloc(sl()));

  ///Session Service------------------------------------------------------------
  sl.registerLazySingleton<SessionServices>(() => SessionServices(sl<StorageService>()));


  ///Network - Dio--------------------------------------------------------------
  sl.registerLazySingleton<Dio>((){
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      )
    );
    dio.interceptors.add(sl<LoggerInterceptor>());
    dio.interceptors.add(sl<AuthInterceptor>());
    dio.interceptors.add(sl<AuthFailureInterceptor>());
    return dio;
  });

  ///Core Services--------------------------------------------------------------
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));

  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService(sl()));

  // sl.registerLazySingleton(()=> NavigationService());


  ///Interceptors---------------------------------------------------------------
  sl.registerLazySingleton(()=> AuthInterceptor(sl<SessionServices>()));
  sl.registerLazySingleton(()=> LoggerInterceptor());
  sl.registerLazySingleton(()=> AuthFailureInterceptor());

  ///Data Sources---------------------------------------------------------------
  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasource(sl()));

  ///Repository-----------------------------------------------------------------
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl()));

  ///AppBloc--------------------------------------------------------------------
  sl.registerLazySingleton(() => AppBloc(sl<SessionServices>()));

  ///AuthBloc-------------------------------------------------------------------
  sl.registerFactory(() => AuthBloc(sl<AuthRepository>(), sl<SessionServices>(),sl<AppBloc>()));

  ///HomeBloc-------------------------------------------------------------------
  sl.registerFactory(()=>HomeBloc());

  ///ProductBloc----------------------------------------------------------------
  sl.registerLazySingleton(()=>ProductRemoteDatasource(sl()));
  sl.registerLazySingleton(()=>ProductRepository(sl()));
  //Screen-specific blocs should be registered as factories to ensure a new instance is created each time the screen is opened.
  sl.registerFactory(()=>ProductBloc(sl()));

  ///CartBloc-------------------------------------------------------------------
  sl.registerLazySingleton(()=>CartLocalDatasource(sl<GetStorage>()));
  sl.registerLazySingleton(()=>CartRemoteDatasource(sl()));
  sl.registerLazySingleton(()=>CartRepository(remote: sl(), local: sl()));
  sl.registerLazySingleton(()=>CartBloc(sl()));

  ///Wishlist-------------------------------------------------------------------
  sl.registerLazySingleton(()=>WishlistLocalDatasource(sl<GetStorage>()));
  sl.registerLazySingleton(()=>WishlistRepository(sl()));
  sl.registerLazySingleton(()=>WishlistBloc(sl()));

  ///Address--------------------------------------------------------------------
  sl.registerLazySingleton(()=>AddressLocalDatasource(sl<GetStorage>()));
  sl.registerLazySingleton(()=>AddressRemoteDatasource());
  sl.registerLazySingleton(()=>AddressRepository(local: sl(), remote: sl()));
  sl.registerFactory(()=>AddressBloc(sl()));

  ///Order----------------------------------------------------------------------
  sl.registerLazySingleton(()=> OrderLocalDatasource(sl<GetStorage>()));
  sl.registerLazySingleton(()=> OrderRemoteDatasource());
  sl.registerLazySingleton(()=> OrderRepository(local: sl(), remote: sl()));
  sl.registerFactory(()=> OrderBloc(sl()));

  ///Profile--------------------------------------------------------------------
  sl.registerLazySingleton(()=> ProfileLocalDatasource(sl<GetStorage>()));
  sl.registerLazySingleton(()=> ProfileRepository(sl<ProfileLocalDatasource>()));
  sl.registerFactory(()=> ProfileBloc(sl<ProfileRepository>()));
}
