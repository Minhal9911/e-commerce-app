import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:flutter/material.dart';

class AppEmptyView extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData icon;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const AppEmptyView({
    super.key,
    required this.message,
    this.subMessage,
    this.icon = Icons.inbox_outlined,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(StaticSizes.size32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: StaticSizes.size64, color: Colors.grey.shade400),
            SizedBox(height: StaticSizes.size16),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (subMessage != null) ...[
              SizedBox(height: StaticSizes.size8),
              Text(
                subMessage!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonLabel != null && onButtonPressed != null) ...[
              SizedBox(height:StaticSizes.size24),
              ElevatedButton(
                onPressed: onButtonPressed,
                child: Text(buttonLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
