import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:flutter/material.dart';

enum AppButtonType { primary, secondary, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonType type;
  final double? width;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = switch (type) {
      AppButtonType.primary   => colorScheme.primary,
      AppButtonType.secondary => Colors.transparent,
      AppButtonType.danger    => Colors.red,
    };

    final foregroundColor = switch (type) {
      AppButtonType.primary   => colorScheme.onPrimary,
      AppButtonType.secondary => colorScheme.primary,
      AppButtonType.danger    => Colors.white,
    };

    return SizedBox(
      width: width ?? double.infinity,
      height: StaticSizes.size50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        child: isLoading
            ? SizedBox(
          width: StaticSizes.size20,
          height: StaticSizes.size20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: foregroundColor,
          ),
        )
            : icon != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: StaticSizes.fontSize18),
            SizedBox(width: StaticSizes.size8),
            Text(label),
          ],
        )
            : Text(label),
      ),
    );
  }
}