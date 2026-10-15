import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:flutter/material.dart';

//It is a special data type that represents a fixed set of named constants.
// enum SnackBarType { success, error, warning, info }

//Enhanced Enum
//can have fields, constructors, methods, getters
enum SnackBarType{
  success(bgColor: Colors.green,icon: Icons.check_circle),
  error(bgColor: Colors.red,icon: Icons.error),
  warning(bgColor: Colors.orange,icon: Icons.warning),
  info(bgColor: Colors.blue,icon: Icons.info);
  final Color bgColor;
  final IconData icon;
  const SnackBarType({required this.bgColor, required this.icon});
}

class SnackBarHelper {
  SnackBarHelper._(); //We make private constructor bcz we want to prevent instantiation(Prevent creating an instance of class)
//A constructor that prevents the class from being instantiated(created)from outside(means we can not create object of that class).

  static void show(
    BuildContext context, {
    required String msg,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                type.icon,
                color: Colors.white,
                size: StaticSizes.size20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(msg, style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          backgroundColor: type.bgColor,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(StaticSizes.borderRadius10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
  }

/*  static IconData _getIcon(SnackBarType type) {
    return switch (type) {
      SnackBarType.success => Icons.check_circle,
      SnackBarType.error => Icons.error,
      SnackBarType.warning => Icons.warning,
      SnackBarType.info => Icons.info,
    };
  }*/

/*  static Color _getColor(SnackBarType type) {
    return switch (type) {
      SnackBarType.success => Colors.green,
      SnackBarType.error => Colors.red,
      SnackBarType.warning => Colors.orange,
      SnackBarType.info => Colors.blue,
    };
  }*/
}
