import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:equatable/equatable.dart';

class CartItemModel extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItemModel({required this.product, required this.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json["product"]),
      quantity: json["quantity"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"product": product.toJson(), "quantity": quantity};
  }

  double get totalPrice => product.price * quantity;

  CartItemModel copyWith({ProductModel? product, int? quantity}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}

