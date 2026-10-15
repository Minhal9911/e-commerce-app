import 'package:e_commerce_app/core/constants/storage_keys.dart';
import 'package:e_commerce_app/dependencyInjection/injection_container.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_event.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_event.dart';
import 'package:e_commerce_app/presentation/blocs/theme/theme_event.dart';
import 'package:e_commerce_app/presentation/blocs/theme/theme_state.dart';
import 'package:e_commerce_app/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

import 'config/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/blocs/theme/theme_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(StorageKeys.appStorage);
  await initDependencies();

  sl<AppBloc>().add(AppStarted());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_)=>sl<ThemeBloc>()..add(LoadTheme())),
          BlocProvider(create: (_)=>sl<CartBloc>()..add(LoadCart()),),
          BlocProvider(create: (_)=>sl<WishlistBloc>()),
        ],
        child: BlocBuilder<ThemeBloc,ThemeState>(
          builder: (context,state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'E-Commerce App',
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: state.themeMode,
              routerConfig: appRouter,
            );
          }
        ),
      ),
    );
  }
}
