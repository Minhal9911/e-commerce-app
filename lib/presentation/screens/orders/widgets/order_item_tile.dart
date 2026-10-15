import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/data/models/cart_item_model.dart';
import 'package:e_commerce_app/presentation/widgets/app_network_image.dart';
import 'package:flutter/material.dart';

class OrderItemTile extends StatelessWidget {
  final CartItemModel item;

  const OrderItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(StaticSizes.borderRadius12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: EdgeInsets.all(StaticSizes.size12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image----------------------------------------------------
            ClipRRect(
              borderRadius: BorderRadius.circular(StaticSizes.borderRadius10),
              child: AppNetworkImage(
                imageUrl: product.thumbnail,
                width: StaticSizes.size80,
                height: StaticSizes.size80,
              ),
            ),

            SizedBox(width: StaticSizes.size12),

            // Product Info-----------------------------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: StaticSizes.size6),

                  Text(
                    product.category,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),

                  SizedBox(height: StaticSizes.size10),

                  Row(
                    children: [
                      Text(
                        "₹${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const Text(" × "),

                      Text(item.quantity.toString()),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: StaticSizes.size12),
            // Total------------------------------------------------------------
            Text(
              "₹${item.totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
