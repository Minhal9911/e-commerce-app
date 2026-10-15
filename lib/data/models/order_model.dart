import 'package:e_commerce_app/core/enums/order_status.dart';
import 'package:e_commerce_app/core/enums/payment_method.dart';
import 'package:e_commerce_app/core/enums/payment_status.dart';
import 'package:e_commerce_app/data/models/address_model.dart';
import 'package:e_commerce_app/data/models/cart_item_model.dart';
import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String id;
  final List<CartItemModel> items;
  final AddressModel address;
  final DateTime orderDate;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;

  const OrderModel({
    required this.id,
    required this.items,
    required this.address,
    required this.orderDate,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      items: (json['items'] as List).map((e) => CartItemModel.fromJson(e)).toList(),
      address: AddressModel.fromJson(Map<String,dynamic>.from(json['address'])),
      orderDate: DateTime.parse(json['orderDate']),
      status: OrderStatus.values.firstWhere((e)=>e.name == json['status']),
      paymentMethod: PaymentMethod.values.firstWhere((e)=>e.name == json['paymentMethod']),
      paymentStatus: PaymentStatus.values.firstWhere((e)=>e.name == json['paymentStatus']),
    );
  }
  //Enum OrderStatus.value means [OrderStatus.pending, OrderStatus.processing, OrderStatus.completed, OrderStatus.cancelled]--- it give use List<OrderStatus>
  // .name gets the string name of enum value

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'address': address.toJson(),
      'orderDate': orderDate.toIso8601String(),
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'paymentStatus': paymentStatus.name,
    };
  }

  OrderModel copyWith({
    String? id,
    List<CartItemModel>? items,
    AddressModel? address,
    DateTime? orderDate,
    OrderStatus? status,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
  }) {
    return OrderModel(
      id: id ?? this.id,
      items: items ?? this.items,
      address: address ?? this.address,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus:  paymentStatus ?? this.paymentStatus,
    );
  }

  bool get canCancel => status == OrderStatus.pending;

  bool get isDelivered => status == OrderStatus.delivered;

  bool get isPaid => paymentStatus == PaymentStatus.paid;

  double get subtotal => items.fold(0, (sum, item)=> sum + item.totalPrice);

  double get shippingCharge =>0;

  double get tax => 0;

  double get discount => 0;

  double get total => subtotal + shippingCharge + tax - discount;

  @override
  List<Object?> get props => [id,items,address,orderDate,status,paymentMethod,paymentStatus];
}
