import 'package:e_commerce_app/data/models/order_model.dart';
import 'package:equatable/equatable.dart';

class OrderState extends Equatable {
  final List<OrderModel> orders;
  final bool isLoading;
  final bool orderPlaced;
  final String? error;

  const OrderState({
    this.orders = const [],
    this.isLoading = false,
    this.orderPlaced = false,
    this.error,
  });

  OrderState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    bool? orderPlaced,
    String? error,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      orderPlaced: orderPlaced ?? this.orderPlaced,
      error: error,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading, orderPlaced, error];
}

/*
sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

final class OrderInitial extends OrderState{}

final class OrderLoading extends OrderState{}

final class OrderPlaced extends OrderState{}

final class OrdersLoaded extends OrderState{
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders);
  @override
  List<Object?> get props=>[orders];
}

final class OrderError extends OrderState{
  final String message;
  const OrderError(this.message);

  @override
  List<Object?> get props=>[message];
}*/
