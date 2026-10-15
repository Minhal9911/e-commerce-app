import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/core/enums/payment_method.dart';
import 'package:e_commerce_app/core/enums/payment_status.dart';
import 'package:flutter/material.dart';

class PaymentInfoCard extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;

  const PaymentInfoCard({
    super.key,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(StaticSizes.size16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Heading
            Row(
              children: [
                const Icon(Icons.payment_outlined),
                SizedBox(width: StaticSizes.size8),
                Text("Payment", style: theme.textTheme.titleMedium),
              ],
            ),

            SizedBox(height: StaticSizes.size16),

            /// Payment Method
            _PaymentRow(
              icon: _paymentIcon(paymentMethod),
              title: "Method",
              value: _paymentTitle(paymentMethod),
            ),

            SizedBox(height: StaticSizes.size12),

            /// Payment Status
            _PaymentRow(
              icon: _paymentStatusIcon(paymentStatus),
              title: "Status",
              value: _paymentStatus(paymentStatus),
              valueColor: _paymentStatusColor(paymentStatus),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _paymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cod:
        return Icons.payments_outlined;

      case PaymentMethod.card:
        return Icons.credit_card;

      case PaymentMethod.upi:
        return Icons.account_balance_wallet_outlined;
    }
  }

  static String _paymentTitle(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cod:
        return "Cash On Delivery";

      case PaymentMethod.card:
        return "Credit / Debit Card";

      case PaymentMethod.upi:
        return "UPI";
    }
  }

  static String _paymentStatus(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return "Pending";

      case PaymentStatus.paid:
        return "Paid";

      case PaymentStatus.failed:
        return "Failed";

      case PaymentStatus.refunded:
        return "Refunded";
    }
  }

  static Color _paymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange;

      case PaymentStatus.paid:
        return Colors.green;

      case PaymentStatus.failed:
        return Colors.red;

      case PaymentStatus.refunded:
        return Colors.blue;
    }
  }

  static IconData _paymentStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return Icons.schedule;

      case PaymentStatus.paid:
        return Icons.check_circle;

      case PaymentStatus.failed:
        return Icons.error_outline;

      case PaymentStatus.refunded:
        return Icons.replay_circle_filled_outlined;
    }
  }
}

class _PaymentRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  const _PaymentRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
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
            style: TextStyle(color: valueColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
