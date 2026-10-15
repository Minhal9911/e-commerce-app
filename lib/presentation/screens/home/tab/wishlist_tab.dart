import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/wishlist/wishlist_state.dart';
import 'package:e_commerce_app/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistTab extends StatelessWidget {
  const WishlistTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wishlist'),),
      body: BlocBuilder<WishlistBloc,WishlistState>(
        builder: (context, state) {

          ///Empty State--------------------------------------------------------
          if (state.products.isEmpty) {
            return const _EmptyWishlistView();
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: state.products.length,

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),

            itemBuilder: (_, index) {

              final product = state.products[index];

              return ProductCard(product);
            },
          );
        },
      ),
    );
  }
}

class _EmptyWishlistView extends StatelessWidget {
  const _EmptyWishlistView();

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(
            Icons.favorite_border,
            size: 100,
            color: Colors.grey.shade400,
          ),

          SizedBox(height: StaticSizes.size16),

          Text(
            "Wishlist is empty",
            style: TextStyle(
              fontSize: StaticSizes.fontSize18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: StaticSizes.size8),

          Text(
            "Save products you love",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
