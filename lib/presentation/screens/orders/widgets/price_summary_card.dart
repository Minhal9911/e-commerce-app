import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/data/models/order_model.dart';
import 'package:flutter/material.dart';

class PriceSummaryCard extends StatelessWidget {
  final OrderModel order;

  const PriceSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(StaticSizes.size16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              "Price Summary",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: StaticSizes.size16),

            _PriceRow(title: "Subtotal", amount: order.subtotal),

            _PriceRow(title: "Shipping", amount: order.shippingCharge),

            _PriceRow(title: "Tax", amount: order.tax),

            if (order.discount > 0)
              _PriceRow(
                title: "Discount",
                amount: -order.discount,
                valueColor: Colors.green,
              ),

            Divider(height: StaticSizes.size24),

            _PriceRow(title: "Total", amount: order.total, isTotal: true),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title;
  final double amount;
  final bool isTotal;
  final Color? valueColor;

  const _PriceRow({
    required this.title,
    required this.amount,
    this.isTotal = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
      fontSize: isTotal ? 18 : 15,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: StaticSizes.size6),
      child: Row(
        children: [
          Expanded(child: Text(title, style: textStyle)),

          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: textStyle?.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
