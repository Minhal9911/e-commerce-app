import 'package:e_commerce_app/core/enums/order_status.dart';
import 'package:flutter/material.dart';

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({super.key, required this.status});

  Color get _backgroundColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange.shade100;

      case OrderStatus.processing:
        return Colors.blue.shade100;

      case OrderStatus.confirmed:
        return Colors.cyan.shade100;

      case OrderStatus.shipped:
        return Colors.purple.shade100;

      case OrderStatus.delivered:
        return Colors.green.shade100;

      case OrderStatus.cancelled:
        return Colors.red.shade100;
    }
  }

  Color get _foregroundColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange.shade800;

      case OrderStatus.processing:
        return Colors.blue.shade800;

      case OrderStatus.confirmed:
        return Colors.cyan.shade800;

      case OrderStatus.shipped:
        return Colors.purple.shade800;

      case OrderStatus.delivered:
        return Colors.green.shade800;

      case OrderStatus.cancelled:
        return Colors.red.shade800;
    }
  }

  String get _label {
    switch (status) {
      case OrderStatus.pending:
        return "Pending";

      case OrderStatus.processing:
        return "Processing";

      case OrderStatus.confirmed:
        return "Confirmed";

      case OrderStatus.shipped:
        return "Shipped";

      case OrderStatus.delivered:
        return "Delivered";

      case OrderStatus.cancelled:
        return "Cancelled";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        _label,
        style: TextStyle(color: _foregroundColor, fontWeight: FontWeight.w600),
      ),
      backgroundColor: _backgroundColor,
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
