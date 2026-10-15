import 'package:e_commerce_app/config/routes/route_const.dart';
import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/core/enums/payment_method.dart';
import 'package:e_commerce_app/core/utils/snackbar_helper.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_state.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_event.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_state.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_event.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listenWhen: ((previous, current) => previous.orderPlaced != current.orderPlaced),
      listener: (BuildContext context, state) {
        if (state.orderPlaced) {
          //clearing cart after successful order
          context.read<CartBloc>().add(ClearCart());
          //reset flag to prevent multiple navigation
          context.read<OrderBloc>().add(ResetOrderPlaced());
          //Navigate to success screen
          context.go(RouteConst.orderSuccess);
        }
        if (state.error != null) {
          SnackBarHelper.show(context, msg: state.error!);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (BuildContext context, state) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(StaticSizes.size16),
                    children: [
                      _AddressCard(),
                      SizedBox(height: StaticSizes.size16),
                      _PaymentCard(),
                      SizedBox(height: StaticSizes.size16),
                      _OrderSummary(state: state),
                    ],
                  ),
                ),
                _PlaceOrderButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (BuildContext context, state) {
        final address = state.defaultAddress;
        return Card(
          child: ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("Shipping Address"),
            subtitle: address == null
                ? const Text("No address selected",style: TextStyle(color: Colors.red))
                : Text(
                    "${address.fullName}\n"
                    "${address.addressLine1}\n"
                    "${address.city}, ${address.state}",
                  ),
            trailing: TextButton(
              onPressed: () {
                context.push(RouteConst.addressList,extra: context.read<AddressBloc>());
              },
              child: const Text("Change"),
            ),
          ),
        );
      },
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.payment),
        title: const Text("Cash On Delivery"),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartState state;

  const _OrderSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    final subtotal = state.totalPrice;
    const shipping = 5.0;
    final total = subtotal + shipping;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            _row("Items", "${state.totalItems}"),
            _row("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
            _row("Shipping", "\$5"),
            const Divider(),
            _row("Total", "\$${total.toStringAsFixed(2)}", isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value, {bool isBold = false}) {
    final style = isBold
        ? TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: StaticSizes.fontSize16,
          )
        : null;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: StaticSizes.size6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _PlaceOrderButton extends StatelessWidget {
  const _PlaceOrderButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (BuildContext context, state) {
        final cartState = context.watch<CartBloc>().state;
        final addressState = context.watch<AddressBloc>().state;
        final isEmpty = cartState.items.isEmpty;
        // final hasAddress = addressState.defaultAddress !=null;
        // final isDisabled = isEmpty || state.isLoading || !hasAddress;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(StaticSizes.size16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:(isEmpty || state.isLoading)
                    ? null
                    : () {
                  final address = addressState.defaultAddress;
                  if (address == null) {
                    SnackBarHelper.show(context, msg:"Please add a shipping address");
                    return;
                  }
                  // const shipping = 5.0;
                  // final total = cartState.totalPrice + shipping;

                  context.read<OrderBloc>().add(
                    PlaceOrder(
                      items: cartState.items,
                      // totalAmount: total,
                      address: address,
                      paymentMethod: PaymentMethod.cod,
                    ),
                  );
                  // context.push(RouteConst.orderSuccess);
                },
                child: state.isLoading
                    ? SizedBox(
                    height: StaticSizes.size22,
                    width: StaticSizes.size22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text("Place Order"),
              ),
            ),
          ),
        );
      },
    );
  }
}
