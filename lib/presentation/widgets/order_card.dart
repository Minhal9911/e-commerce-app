import 'dart:math';

import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/data/models/order_model.dart';
import 'package:e_commerce_app/presentation/widgets/order_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(StaticSizes.borderRadius12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(StaticSizes.size16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Order Id
              Row(
                children: [
                  const Icon(Icons.receipt_long),

                  SizedBox(width: StaticSizes.size8),

                  Expanded(
                    child: Text(
                      "Order #${order.id.substring(0, min(8, order.id.length))}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: StaticSizes.fontSize16,
                      ),
                    ),
                  ),

                  OrderStatusChip(status: order.status),

                ],
              ),

              SizedBox(height: StaticSizes.size12),

              /// Date
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),

                  SizedBox(width: StaticSizes.size8),

                  Text(DateFormat('dd MMM yyyy',).format(order.orderDate)),
                ],
              ),

              SizedBox(height: StaticSizes.size8),

              /// Items
              Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 18),

                  SizedBox(width: StaticSizes.size8),

                  Text("${order.items.length} Items"),
                ],
              ),

              SizedBox(height: StaticSizes.size8),

              /// Total
              Row(
                children: [
                  const Icon(Icons.currency_rupee, size: 18),

                  SizedBox(width: StaticSizes.size8),

                  Text(
                    order.total.toStringAsFixed(2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              if (order.canCancel) ...[
                SizedBox(height: StaticSizes.size16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onCancel,
                    child: const Text("Cancel Order"),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
