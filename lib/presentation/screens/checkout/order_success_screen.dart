import 'package:e_commerce_app/config/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),

            const SizedBox(height: 16),

            const Text("Order Placed Successfully"),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                context.go(RouteConst.home);
              },

              child: const Text("Continue Shopping"),
            ),
          ],
        ),
      ),
    );
  }
}
