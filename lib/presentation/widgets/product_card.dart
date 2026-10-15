import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/config/routes/route_const.dart';
import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:e_commerce_app/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/wishlist/wishlist_event.dart';
import 'package:e_commerce_app/presentation/blocs/wishlist/wishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.push(RouteConst.productDetail,extra: product);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(StaticSizes.borderRadius12),
          color: Colors.pink[50],
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(4, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: "product_${product.id}",
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(StaticSizes.borderRadius12)),
                        child: CachedNetworkImage(
                          imageUrl: product.thumbnail,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey.shade300)
                                  .animate(onPlay: (c) => c.repeat())
                                  .shimmer(
                                duration: 1200.ms,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                          errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                  ),

                  ///Heart Icon
                  Positioned(
                      top:StaticSizes.size8,
                      right: StaticSizes.size8,
                      child: BlocBuilder<WishlistBloc,WishlistState>(
                        builder: (BuildContext context, state) {
                          final isFavorite = state.products.any((e)=>e.id == product.id);
                          return InkWell(
                            onTap: (){
                              context.read<WishlistBloc>().add(ToggleWishlist(product));
                            },
                            borderRadius: BorderRadius.circular(StaticSizes.borderRadius20),
                            child: Container(
                              padding: EdgeInsets.all(StaticSizes.size8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08),blurRadius: 8)]
                              ),
                              child: Icon(isFavorite?Icons.favorite:Icons.favorite_border,color: isFavorite?Colors.red:Colors.grey,),
                            ),
                          );
                        },))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(StaticSizes.size8),
              child: Column(
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: StaticSizes.size4),
                  Text(
                    "\$${product.price}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}