import 'package:e_commerce_app/data/models/cart_item_model.dart';
import 'package:equatable/equatable.dart';

//Here we don't use sealed class because we have only one state, no loading/error/success needed here
class CartState extends Equatable {
  final List<CartItemModel> items;

  const CartState({this.items = const []});

  //Why we make get of totalPrice because we want to calculate the total price every time we access the cart state(always fresh value)
  double get totalPrice => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
