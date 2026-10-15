import 'package:e_commerce_app/core/enums/payment_method.dart';
import 'package:e_commerce_app/data/models/address_model.dart';
import 'package:e_commerce_app/data/models/cart_item_model.dart';
import 'package:equatable/equatable.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

final class LoadOrders extends OrderEvent {}

//final on a class means "this class cannot be extended or implemented further,anywhere"
final class PlaceOrder extends OrderEvent {
  final List<CartItemModel> items;
  final AddressModel address;
  final PaymentMethod paymentMethod;

  const PlaceOrder({
    required this.items,
    required this.address,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [items, address, paymentMethod];
}

final class CancelOrder extends OrderEvent {
  final String orderId;

  const CancelOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

final class ResetOrderPlaced extends OrderEvent{
  const ResetOrderPlaced();
}
