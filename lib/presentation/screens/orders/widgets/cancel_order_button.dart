import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/core/utils/app_dialog.dart';
import 'package:flutter/material.dart';

class CancelOrderButton extends StatelessWidget {
  final VoidCallback onConfirm;

  const CancelOrderButton({super.key, required this.onConfirm});

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final confirmed = await AppDialogs.showConfirmDialog(
      context: context,
      title: "Cancel Order",
      message: "Are you sure you want to cancel this order?",
      confirmText: "yes",
      cancelText: "No",
      isDangerous: true,
    );
    if (confirmed) {
      onConfirm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showConfirmationDialog(context),
        icon: const Icon(Icons.cancel_outlined),
        label: const Text("Cancel Order"),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: EdgeInsets.symmetric(vertical: StaticSizes.size14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(StaticSizes.borderRadius12),
          ),
        ),
      ),
    );
  }
}
