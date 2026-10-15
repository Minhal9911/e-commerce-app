import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/config/routes/route_const.dart';
import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/data/models/cart_item_model.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_event.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/*class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (BuildContext context, state) {
        if (state.items.isEmpty) {
          return Center(child: Text("Cart is empty"));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: state.items.length,
                separatorBuilder: (_,_)=>SizedBox(height: StaticSizes.size16,),
                itemBuilder: (BuildContext context, int index) {
                  final item = state.items[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: item.product.thumbnail,
                      width: 60,
                    ),
                    title: Text(item.product.title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                          context.read<CartBloc>().add(DecreaseQuantity(item.product.id));
                        }, icon: Icon(Icons.remove)),
                        Text(item.quantity.toString()),
                        IconButton(onPressed: () {
                          context.read<CartBloc>().add(IncreaseQuantity(item.product.id));
                        }, icon: Icon(Icons.add)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total",style: TextStyle(fontSize: StaticSizes.fontSize18,fontWeight: FontWeight.bold),),
                      Text("\$${state.totalPrice.toStringAsFixed(2)}",style: TextStyle(fontSize: StaticSizes.fontSize18),),


                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){},
                      child: Text('Checkout'),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}*/

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Cart'),centerTitle: true,),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {

          // EMPTY STATE
          if (state.items.isEmpty) {
            return const _EmptyCartView();
          }

          return Column(
            children: [

              /// CART ITEMS
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(
                    StaticSizes.size16,
                  ),

                  itemCount: state.items.length,

                  separatorBuilder: (_,_) =>
                      SizedBox(height: StaticSizes.size16),

                  itemBuilder: (_, index) {

                    final item = state.items[index];

                    return Dismissible(
                      key: ValueKey(item.product.id),
                      direction:
                      DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: StaticSizes.size20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(
                            StaticSizes.borderRadius15,
                          ),
                        ),

                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) {
                        context.read<CartBloc>().add(RemoveFromCart(item.product.id));
                      },
                      child: _CartItemCard(item: item),
                    ).animate().fadeIn().slideX();
                  },
                ),
              ),

              /// TOTAL SECTION
              _CheckoutSection(state: state,totalPrice: state.totalPrice),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {

  final CartItemModel item;

  const _CartItemCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(StaticSizes.size12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(
          StaticSizes.borderRadius15,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(
              StaticSizes.borderRadius12,
            ),

            child: CachedNetworkImage(
              imageUrl: item.product.thumbnail,

              width: 90,
              height: 90,

              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: StaticSizes.size12),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  item.product.title,

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize:
                    StaticSizes.fontSize14,

                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: StaticSizes.size8),

                Text(
                  "\$${item.product.price}",

                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: StaticSizes.fontSize16,
                  ),
                ),

                SizedBox(height: StaticSizes.size12),

                /// QUANTITY CONTROLS
                Row(
                  children: [

                    _QtyButton(
                      icon: Icons.remove,

                      onTap: () {
                        context.read<CartBloc>().add(
                          DecreaseQuantity(
                            item.product.id,
                          ),
                        );
                      },
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: StaticSizes.size12,
                      ),

                      child: Text(
                        item.quantity.toString(),

                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                          StaticSizes.fontSize14,
                        ),
                      ),
                    ),

                    _QtyButton(
                      icon: Icons.add,

                      onTap: () {
                        context.read<CartBloc>().add(
                          IncreaseQuantity(item.product.id),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {

  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(
        StaticSizes.borderRadius10,
      ),

      child: Container(
        padding: EdgeInsets.all(
          StaticSizes.size6,
        ),

        decoration: BoxDecoration(
          color: Colors.grey.shade200,

          borderRadius: BorderRadius.circular(
            StaticSizes.borderRadius10,
          ),
        ),

        child: Icon(
          icon,
          size: StaticSizes.size18,
        ),
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),

          SizedBox(height: StaticSizes.size16),

          Text(
            "Your cart is empty",

            style: TextStyle(
              fontSize: StaticSizes.fontSize18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: StaticSizes.size8),

          Text(
            "Looks like you haven't added anything yet",

            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

class _CheckoutSection extends StatelessWidget {
 final CartState state;
  final double totalPrice;

  const _CheckoutSection({
    required this.state,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        StaticSizes.size16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            StaticSizes.borderRadius20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: StaticSizes.fontSize18,
                  ),
                ),
                Text(
                  "\$${totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: StaticSizes.fontSize18,
                  ),
                ),
              ],
            ),
            SizedBox(height: StaticSizes.size16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.items.isEmpty ?null :(){
                  context.push(RouteConst.checkout);
                },
                child: const Text(
                  "Checkout",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
