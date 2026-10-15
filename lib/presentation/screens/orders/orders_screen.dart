import 'package:e_commerce_app/config/routes/route_const.dart';
import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_event.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_state.dart';
import 'package:e_commerce_app/presentation/widgets/app_loader.dart';
import 'package:e_commerce_app/presentation/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders"), centerTitle: true),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (BuildContext context, state) {
          if (state.isLoading) {
            return const AppLoader();
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          if (state.orders.isEmpty) {
            return const Center(child: Text("No Orders Yet"));
          }
          return ListView.separated(
            itemCount: state.orders.length,
            separatorBuilder: (_, _) => SizedBox(height: StaticSizes.size13),
            itemBuilder: (_, index) {
              return OrderCard(
                order: state.orders[index],
                onTap: () {
                  context.push(
                    RouteConst.orderDetail,
                    extra: state.orders[index],
                  );
                },
                onCancel: () {
                  //can show confirmation dialog
                  context.read<OrderBloc>().add(
                    CancelOrder(orderId: state.orders[index].id),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
