import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/dependencyInjection/injection_container.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_state.dart';
import 'package:e_commerce_app/presentation/blocs/home/home_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/home/home_event.dart';
import 'package:e_commerce_app/presentation/blocs/home/home_state.dart';
import 'package:e_commerce_app/presentation/blocs/profile/profile_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/profile/profile_event.dart';
import 'package:e_commerce_app/presentation/screens/cart/cart_screen.dart';
import 'package:e_commerce_app/presentation/screens/home/tab/home_tab.dart';
import 'package:e_commerce_app/presentation/screens/home/tab/profile_tab.dart';
import 'package:e_commerce_app/presentation/screens/home/tab/wishlist_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> screens =  [
    HomeTab(),
    WishlistTab(),
    CartScreen(),
    BlocProvider(create: (_)=> sl<ProfileBloc>()..add(const LoadProfile()),child: ProfileTab(),),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final currentIndex = state.currentIndex;
        return Scaffold(
          body: IndexedStack(index: currentIndex, children: screens),
          bottomNavigationBar: Container(
            height: StaticSizes.size70,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home, label: 'Home', index: 0, currentIndex: currentIndex),
                _NavItem(icon: Icons.favorite, label: 'Wishlist', index: 1, currentIndex: currentIndex),
                //Cart with badges
                BlocBuilder<CartBloc,CartState>(builder: (BuildContext context, state) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _NavItem(icon: Icons.shopping_cart, label: 'Cart', index: 2, currentIndex: currentIndex),
                      //Badge
                      if(state.totalItems>0)
                        Positioned(
                            right:-8,
                            top: -4,
                            child: Container(
                              padding: EdgeInsets.all(StaticSizes.size4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle
                              ),
                              child: Text(state.totalItems.toString(),style: TextStyle(color: Colors.white,fontSize: StaticSizes.fontSize10,fontWeight: FontWeight.bold),),
                            ))
                    ],
                  );
                },),

                _NavItem(icon: Icons.person, label: 'Profile', index: 3, currentIndex: currentIndex),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {

  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {

    final isSelected = currentIndex == index;

    return InkWell(

      borderRadius: BorderRadius.circular(
        StaticSizes.borderRadius12,
      ),

      onTap: () {
        context.read<HomeBloc>().add(
          HomeTabChanged(index),
        );
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: EdgeInsets.symmetric(
          horizontal: StaticSizes.size12,
          vertical: StaticSizes.size6,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.1)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(
            StaticSizes.borderRadius12,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              size: StaticSizes.size24,
              color: isSelected
                  ? Colors.blue
                  : Colors.grey,
            ),

            SizedBox(height: StaticSizes.size4),

            Text(
              label,

              style: TextStyle(
                fontSize: StaticSizes.fontSize12,
                fontWeight: FontWeight.w500,

                color: isSelected
                    ? Colors.blue
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
