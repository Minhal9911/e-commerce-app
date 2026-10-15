import 'dart:math';
import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/data/models/order_model.dart';
import 'package:e_commerce_app/presentation/widgets/order_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderInfoCard extends StatelessWidget {
  final OrderModel order;

  const OrderInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(StaticSizes.size16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Information", style: theme.textTheme.titleMedium),

            SizedBox(height: StaticSizes.size16),

            _InfoRow(
              icon: Icons.receipt_long,
              title: "Order ID",
              value: "#${order.id.substring(0, min(8, order.id.length))}",
            ),

            SizedBox(height: StaticSizes.size12),

            Row(
              children: [
                const Icon(Icons.local_shipping),

                SizedBox(width: StaticSizes.size12),

                const Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const Spacer(),

                OrderStatusChip(status: order.status),
              ],
            ),

            SizedBox(height: StaticSizes.size12),

            _InfoRow(
              icon: Icons.calendar_today,
              title: "Order Date",
              value: DateFormat("dd MMM yyyy, hh:mm a").format(order.orderDate),
            ),

            SizedBox(height: StaticSizes.size12),

            _InfoRow(
              icon: Icons.shopping_bag_outlined,
              title: "Items",
              value: "${order.items.length}",
            ),

            SizedBox(height: StaticSizes.size12),

            _InfoRow(
              icon: Icons.currency_rupee,
              title: "Total Amount",
              value: "₹${order.total.toStringAsFixed(2)}",
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),

        SizedBox(width: StaticSizes.size12),

        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

        const Spacer(),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
