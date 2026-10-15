import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:equatable/equatable.dart';

sealed class CartEvent extends Equatable{
  const CartEvent();

  @override
  List<Object?> get props=>[];
}

final class LoadCart extends CartEvent{}

final class AddToCart extends CartEvent{
  final ProductModel product;

  const AddToCart(this.product);

  @override
  List<Object?> get props=>[product];
}

final class RemoveFromCart extends CartEvent{
  final int productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object?> get props=>[productId];
}

final class IncreaseQuantity extends CartEvent{
  final int productId;

  const IncreaseQuantity(this.productId);

  @override
  List<Object?> get props=>[productId];
}

final class DecreaseQuantity extends CartEvent{
  final int productId;

  const DecreaseQuantity(this.productId);

  @override
  List<Object?> get props=>[productId];
}

final class ClearCart extends CartEvent{}