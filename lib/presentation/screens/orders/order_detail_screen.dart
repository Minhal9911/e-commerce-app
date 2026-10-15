import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/core/utils/snackbar_helper.dart';
import 'package:e_commerce_app/data/models/order_model.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_event.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_state.dart';
import 'package:e_commerce_app/presentation/screens/orders/widgets/cancel_order_button.dart';
import 'package:e_commerce_app/presentation/screens/orders/widgets/order_info_card.dart';
import 'package:e_commerce_app/presentation/screens/orders/widgets/order_item_tile.dart';
import 'package:e_commerce_app/presentation/screens/orders/widgets/payment_info_card.dart';
import 'package:e_commerce_app/presentation/screens/orders/widgets/price_summary_card.dart';
import 'package:e_commerce_app/presentation/screens/orders/widgets/shipping_address_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listenWhen: (previous, current) =>
          previous.orders != current.orders || previous.error != current.error,
      listener: (BuildContext context, state) {
        if (state.error != null) {
          SnackBarHelper.show(context, msg: state.error!);
        }
        final updatedOrder=state.orders.where((e)=>e.id == order.id);
        if(updatedOrder.isEmpty){
          SnackBarHelper.show(context, msg: "Order cancelled successfully");
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Order Details'),centerTitle: true),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(StaticSizes.size16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderInfoCard(order: order),
              SizedBox(height: StaticSizes.size16),
              ShippingAddressCard(address: order.address),
              SizedBox(height: StaticSizes.size16),
              PaymentInfoCard(paymentMethod: order.paymentMethod, paymentStatus: order.paymentStatus,),
              SizedBox(height: StaticSizes.size16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(StaticSizes.size16),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text("Items",style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: StaticSizes.size16),
                      ...order.items.map(
                            (item) => Padding(
                              padding: EdgeInsets.only(bottom: StaticSizes.size12),
                          child: OrderItemTile(item: item),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: StaticSizes.size16),
              PriceSummaryCard(order: order),
              SizedBox(height: StaticSizes.size16),
              if(order.canCancel)...[
                SizedBox(height: StaticSizes.size24),
                CancelOrderButton(
                  onConfirm: (){
                    context.read<OrderBloc>().add(CancelOrder(orderId: order.id));
                  },
                ),
              ]

            ],
          ),
        ),
      ),
    );
  }
}
