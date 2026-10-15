import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/config/routes/route_const.dart';
import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/core/services/session_services.dart';
import 'package:e_commerce_app/core/utils/app_dialog.dart';
import 'package:e_commerce_app/data/models/profile_model.dart';
import 'package:e_commerce_app/dependencyInjection/injection_container.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_event.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_event.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_state.dart';
import 'package:e_commerce_app/presentation/blocs/home/home_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/home/home_event.dart';
import 'package:e_commerce_app/presentation/blocs/profile/profile_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/profile/profile_event.dart';
import 'package:e_commerce_app/presentation/blocs/profile/profile_state.dart';
import 'package:e_commerce_app/presentation/blocs/theme/theme_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/theme/theme_event.dart';
import 'package:e_commerce_app/presentation/blocs/theme/theme_state.dart';
import 'package:e_commerce_app/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/wishlist/wishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: StaticSizes.size16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: StaticSizes.size24),

            // PROFILE HEADER---------------------------------------------------
            const _ProfileHeaderSection(),

            // THEME -----------------------------------------------------------
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Card(
                  child: SwitchListTile(
                    title: const Text("Dark Mode"),
                    value: state.isDark,
                    onChanged: (_) {
                      context.read<ThemeBloc>().add(const ToggleTheme());
                    },
                  ),
                );
              },
            ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2, end: 0),

            SizedBox(height: StaticSizes.size12),

            //MY ORDERS---------------------------------------------------------
            Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text("My Orders"),
                trailing: const Icon(Icons.chevron_right),
                onTap: (){
                  context.push(RouteConst.orders);
                },
              ),
            ).animate().fadeIn(delay: 330.ms).slideX(begin: -0.2, end: 0),
            SizedBox(height: StaticSizes.size12),

            //MY ADDRESSES------------------------------------------------------
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: const Text("My Addresses"),
                trailing: const Icon(Icons.chevron_right),
                onTap: (){
                  final bloc = sl<AddressBloc>()..add(LoadAddresses());
                  context.push(RouteConst.addressList,extra: bloc);
                },
              ),
            ).animate().fadeIn(delay: 340.ms).slideX(begin: -0.2, end: 0),
            SizedBox(height: StaticSizes.size12),

            // WISHLIST COUNT --------------------------------------------------
            BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, state) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text("Wishlist"),
                    trailing: Text(state.products.length.toString()),
                    onTap: (){
                      context.read<HomeBloc>().add(const HomeTabChanged(1));
                    },
                  ),
                );
              },
            ).animate().fadeIn(delay: 350.ms).slideX(begin: -0.2, end: 0),

            SizedBox(height: StaticSizes.size12),

            // CART COUNT ------------------------------------------------------
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text("Cart Items"),
                    trailing: Text(state.items.length.toString()),
                    onTap: (){
                      context.read<HomeBloc>().add(const HomeTabChanged(2));
                    },
                  ),
                );
              },
            ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2, end: 0),

            SizedBox(height: StaticSizes.size24),

            // LOGOUT ----------------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                onPressed: () async {
                  final confirmed = await AppDialogs.showConfirmDialog(
                    context: context,
                    title: "Logout",
                    message: "Are you sure you want to logout?",
                    confirmText: "Logout",
                    isDangerous: true,
                  );

                  if (!confirmed) return;
                  sl<AppBloc>().add(LoggedOut());
                },
              ),
            )
                .animate()
                .fadeIn(delay: 500.ms)
                .slideY(begin: 0.3, end: 0),

            SizedBox(height: StaticSizes.size24),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderSection extends StatelessWidget {
  const _ProfileHeaderSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc,ProfileState>(
      builder: (context,state){
        return switch (state) {
          ProfileInitial() => const _ProfileHeaderLoading(),
          ProfileLoading() => const _ProfileHeaderLoading(),
          ProfileLoaded()=> _ProfileHeader(profile:state.profile),
          ProfileEmpty()=> const _EmptyProfile(),
          ProfileError()=> _ProfileHeaderError(message:state.message),
        };
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ProfileModel profile;
  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final session = sl<SessionServices>();
    final user = session.currentUser;
    final hasImage = user?.image.isNotEmpty == true;
    debugPrint('Profile Header: ${user?.username}, ${user?.email}, hasImage: $hasImage');
    return Column(
      children: [
        CircleAvatar(
          radius: StaticSizes.size50,
          backgroundImage: hasImage
              ? CachedNetworkImageProvider(user!.image)
              : null,
          child: hasImage ? null : const Icon(Icons.person, size: 40),
        )
            .animate()
            .scale(duration: 400.ms, curve: Curves.easeOut),

        SizedBox(height: StaticSizes.size16),

        Text(
          user?.username ?? "Guest User",
          style: TextStyle(
            fontSize: StaticSizes.fontSize20,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms)
            .slideY(begin: 0.3, end: 0),

        SizedBox(height: StaticSizes.size8),

        Text(
          user?.email ?? "guest@email.com",
          style: TextStyle(
            color: Colors.grey,
            fontSize: StaticSizes.fontSize14,
          ),
        )
            .animate()
            .fadeIn(delay: 250.ms, duration: 400.ms)
            .slideY(begin: 0.3, end: 0),

        SizedBox(height: StaticSizes.size32),
      ],
    );
  }
}


class _ProfileHeaderLoading extends StatelessWidget {
  const _ProfileHeaderLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        StaticSizes.size16,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 36,
            child: CircularProgressIndicator(),
          ),

          SizedBox(
            width: StaticSizes.size16,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Container(
                  height: 18,
                  width: 140,
                  color: Colors.grey.shade300,
                ),

                SizedBox(
                  height: StaticSizes.size8,
                ),

                Container(
                  height: 14,
                  width: 190,
                  color: Colors.grey.shade300,
                ),

                SizedBox(
                  height: StaticSizes.size6,
                ),

                Container(
                  height: 14,
                  width: 120,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderError extends StatelessWidget {
  final String message;

  const _ProfileHeaderError({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        StaticSizes.size16,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 40,
          ),

          SizedBox(
            height: StaticSizes.size8,
          ),

          Text(
            message,
            textAlign: TextAlign.center,
          ),

          SizedBox(
            height: StaticSizes.size8,
          ),

          TextButton(
            onPressed: () {
              context.read<ProfileBloc>().add(const LoadProfile());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyProfile extends StatelessWidget {
  const _EmptyProfile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:StaticSizes.size8),
      child: Column(
        children: [
          CircleAvatar(
            radius: StaticSizes.size50,
            child: Icon(
              Icons.person_outline,
              size: StaticSizes.size40,
            ),
          ),

          SizedBox(height: StaticSizes.size8),

          Text('Profile not set up',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          TextButton(
            onPressed: () {
              //todo Open Edit Profile
            },
            child: const Text(
              'Create Profile',
            ),
          ),
        ],
      ),
    );
  }
}
