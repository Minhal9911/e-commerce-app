import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:equatable/equatable.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

final class LoadWishlist extends WishlistEvent {}

final class ToggleWishlist extends WishlistEvent {
  final ProductModel product;

  const ToggleWishlist(this.product);

  @override
  List<Object?> get props => [product];
}
