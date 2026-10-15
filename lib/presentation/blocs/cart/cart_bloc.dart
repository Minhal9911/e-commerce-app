import 'package:e_commerce_app/data/models/cart_item_model.dart';
import 'package:e_commerce_app/data/repositories/cart_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repo;

  CartBloc(this.repo) : super(const CartState()) {
    //Load saved Cart
    on<LoadCart>(_loadCart);
    on<AddToCart>(_addToCart);
    on<RemoveFromCart>(_removeFromCart);
    on<IncreaseQuantity>(_increaseQty);
    on<DecreaseQuantity>(_decreaseQty);
    on<ClearCart>(_clearCart);
  }

  // LOAD CART FROM STORAGE
  Future<void> _loadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      debugPrint('LOAD CART CALLED');
      final items = await repo.getCart();
      debugPrint('LOADED ITEMS COUNT: ${items.length}');
      emit(state.copyWith(items: items));
    } catch (e) {
      debugPrint('LOAD CART ERROR: $e');
      emit(state.copyWith(items: []));
    }
  }

  Future<void> _addToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      //creates a brand new list with same items
      final items = List<CartItemModel>.from(state.items);

      //finds position of item by matching condition
      final index = items.indexWhere((e) => e.product.id == event.product.id);

      if (index != -1) {
        items[index] = items[index].copyWith(
          quantity: items[index].quantity + 1,
        );
      } else {
        items.add(CartItemModel(product: event.product, quantity: 1));
      }
      emit(state.copyWith(items: items));
      //Save update cart
      await repo.saveCart(items);
    } catch (e) {
      //Handle error if needed
      //keep the current state or show error message
      //   emit(state);
      debugPrint('Error adding to cart: $e');
    }
  }

  Future<void> _removeFromCart(RemoveFromCart event,Emitter<CartState> emit) async {
    try {
      final items = state.items.where((e) => e.product.id != event.productId).toList();

      emit(state.copyWith(items: items));
      //Save update cart
      await repo.saveCart(items);
    } catch (e) {
      debugPrint('Error removing from cart: $e');
    }
  }

  Future<void> _increaseQty(IncreaseQuantity event,Emitter<CartState> emit) async {
    try{
      final items = state.items.map((e) {
        if (e.product.id == event.productId) {
          return e.copyWith(quantity: e.quantity + 1);
        }
        return e;
      }).toList();
      emit(state.copyWith(items: items));
      await repo.saveCart(items);
    }catch(e){
      //Keep current state or show error message
      //   emit(state);
      debugPrint('Error increasing quantity: $e');
    }
  }

  Future<void> _decreaseQty(DecreaseQuantity event,Emitter<CartState> emit) async {
   try{
     final items = state.items.map((e) {
       if (e.product.id == event.productId) {
         return e.copyWith(quantity: e.quantity - 1);
       }
       return e;
     })
         .where((e) => e.quantity > 0)
         .toList();

     emit(state.copyWith(items: items));

     await repo.saveCart(items);
   }catch(e){
     //keep current state or show error message
      //   emit(state);
      debugPrint('Error decreasing quantity: $e');
   }
  }

  Future<void> _clearCart(ClearCart event, Emitter<CartState> emit) async {
  try{
    emit(state.copyWith(items: []));
    await repo.clearCart();
  }catch(e){
    //Keep current state or show error message
    //   emit(state);
    debugPrint('Error clearing cart: $e');
  }
  }
}
