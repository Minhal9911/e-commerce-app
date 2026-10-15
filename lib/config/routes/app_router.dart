import 'package:e_commerce_app/config/routes/route_const.dart';
import 'package:e_commerce_app/core/utils/go_router_refresh_stream.dart';
import 'package:e_commerce_app/data/models/address_model.dart';
import 'package:e_commerce_app/data/models/order_model.dart';
import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:e_commerce_app/dependencyInjection/injection_container.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_event.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_state.dart';
import 'package:e_commerce_app/presentation/blocs/home/home_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_event.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_event.dart';
import 'package:e_commerce_app/presentation/screens/address/add_edit_address_screen.dart';
import 'package:e_commerce_app/presentation/screens/address/address_list_screen.dart';
import 'package:e_commerce_app/presentation/screens/auth/login_screen.dart';
import 'package:e_commerce_app/presentation/screens/checkout/checkout_screen.dart';
import 'package:e_commerce_app/presentation/screens/checkout/order_success_screen.dart';
import 'package:e_commerce_app/presentation/screens/home/home_screen.dart';
import 'package:e_commerce_app/presentation/screens/home/product/product_detail_screen.dart';
import 'package:e_commerce_app/presentation/screens/orders/order_detail_screen.dart';
import 'package:e_commerce_app/presentation/screens/orders/orders_screen.dart';
import 'package:e_commerce_app/presentation/screens/splash/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  // navigatorKey: sl<NavigationService>().navigatorKey,
  initialLocation: RouteConst.splash,
  refreshListenable: GoRouterRefreshStream(sl<AppBloc>().stream),
  redirect: (context, state) {
    final appState = sl<AppBloc>().state;
    final isSplash = state.matchedLocation == RouteConst.splash;
    final isLogin = state.matchedLocation == RouteConst.login;

    if (appState is AppInitial) {
      return isSplash ? null : RouteConst.splash;
    }
    if (appState is AppUnauthenticated) {
      return isLogin ? null : RouteConst.login;
    }
    //if user is authenticated but other condition like isLogin and isSplash both are false then overall condition will be false so no redirect, just stay on the current screen,
    //for example if user is authenticated and current screen is product detail then both isLogin and isSplash will be false but we don't want to redirect to home, we want to stay on product detail, so return null
    if (appState is AppAuthenticated && (isSplash || isLogin)) {
      return RouteConst.home;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: RouteConst.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteConst.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteConst.home,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<HomeBloc>()),
          BlocProvider(create: (_) => sl<ProductBloc>()..add(FetchProducts())),
        ],
        child: HomeScreen(),
      ),
    ),
    GoRoute(
      path: RouteConst.productDetail,
      builder: (context, state) {
        final product = state.extra as ProductModel;
        return ProductDetailScreen(product: product);
      },
    ),
    GoRoute(
      path: RouteConst.checkout,
      builder: (_, _) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<AddressBloc>()..add(LoadAddresses())),
          BlocProvider(create: (_) => sl<OrderBloc>()),
        ],
        child: const CheckoutScreen(),
      ),
    ),
    GoRoute(
      path: RouteConst.orderSuccess,
      builder: (_, _) => const OrderSuccessScreen(),
    ),
    GoRoute(
      path: RouteConst.addressList,
      builder: (context, state) {
        final bloc = state.extra as AddressBloc;
        return BlocProvider.value(
          value: bloc,
          child: const AddressListScreen(),
        );
      },
      routes: [
        GoRoute(
          path: RouteConst.addEditAddress,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return BlocProvider.value(
              value: extra["bloc"] as AddressBloc,
              child: AddEditAddressScreen(
                address: extra["address"] as AddressModel?,
              ),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: RouteConst.orders,
      builder: (_, _) => BlocProvider(
        create: (_) => sl<OrderBloc>()..add(LoadOrders()),
        child: const OrdersScreen(),
      ),
    ),
    GoRoute(
      path: RouteConst.orderDetail,
      builder: (context, state) {
        return OrderDetailScreen(order: state.extra as OrderModel);
      },
    ),
  ],
);

/*redirect: (context, state) {
    final appState = context.read<AppBloc>().state;
    final isLoginRoute = state.fullPath == RouteConst.login;

    if (appState is AppUnauthenticated && !isLoginRoute) {
      return RouteConst.login;
    }
    if (appState is AppAuthenticated && isLoginRoute) {
      return RouteConst.home;
    }
    return null;
  },*/

/*
//(Splash-first flow)
redirect: (context, state) {
  final appState = context.read<AppBloc>().state;

  final isSplash = state.fullPath == RouteConst.splash;
  final isLogin = state.fullPath == RouteConst.login;

  /// 🔹 1. While app is initializing → stay on splash
  if (appState is AppInitial) {
    return isSplash ? null : RouteConst.splash;
  }

  /// 🔹 2. Not logged in → go login
  if (appState is AppUnauthenticated) {
    return isLogin ? null : RouteConst.login;
  }

  /// 🔹 3. Logged in → go home
  if (appState is AppAuthenticated) {
    return state.fullPath == RouteConst.home
        ? null
        : RouteConst.home;
  }

  return null;
},
*/
