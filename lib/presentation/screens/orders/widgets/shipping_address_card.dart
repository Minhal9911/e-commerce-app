import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/data/models/address_model.dart';
import 'package:flutter/material.dart';

class ShippingAddressCard extends StatelessWidget {
  final AddressModel address;

  const ShippingAddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(StaticSizes.size16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading----------------------------------------------------------
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                SizedBox(width: StaticSizes.size8),
                Text("Shipping Address", style: theme.textTheme.titleMedium),
              ],
            ),
            SizedBox(height: StaticSizes.size16),
            // Name-------------------------------------------------------------
            Text(
              address.fullName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: StaticSizes.size6),
            // Phone------------------------------------------------------------
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 18),
                SizedBox(width: StaticSizes.size8),
                Text(address.phone),
              ],
            ),
            SizedBox(height: StaticSizes.size12),
            // Address Line 1---------------------------------------------------
            // Text(address.addressLine1),
            //
            // if (address.addressLine2.isNotEmpty) ...[
            //   SizedBox(height: StaticSizes.size4),
            //
            //   Text(address.addressLine2),
            // ],
            //
            // SizedBox(height: StaticSizes.size8),
            //
            // Text("${address.city}, ${address.state}"),
            //
            // SizedBox(height: StaticSizes.size4),
            //
            // Text("${address.country} - ${address.postalCode}"),
            Text(address.fullAddress),

            if (address.isDefault) ...[
              SizedBox(height: StaticSizes.size16),

              Chip(
                avatar: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 18,
                ),
                label: const Text("Default Address"),
                backgroundColor: Colors.green.withValues(alpha: 0.12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
