import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/data/models/address_model.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const AddressCard({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: StaticSizes.size16),
      child: Padding(
        padding: EdgeInsets.all(StaticSizes.size16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Header------------------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    address.fullName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: StaticSizes.fontSize18,
                    ),
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: StaticSizes.size10,
                      vertical: StaticSizes.size4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(
                        StaticSizes.borderRadius20,
                      ),
                    ),
                    child: Text(
                      "Default",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),
            Text(address.phone),
            const SizedBox(height: 8),
            Text(address.addressLine1),
            if (address.addressLine2.isNotEmpty)
              Text("${address.city}, ${address.state}"),
            Text("${address.country} - ${address.postalCode}"),
            const Divider(height: 30),

            Row(
              children: [
                IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
                IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
                const Spacer(),
                if (!address.isDefault)
                  TextButton(onPressed: onSetDefault,child: Text('Set Default')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
